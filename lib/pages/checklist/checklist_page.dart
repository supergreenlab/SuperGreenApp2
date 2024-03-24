/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/assets/checklist.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/checklist/actions.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/checklist/checklist_bloc.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_section.dart';
import 'package:super_green_app/pages/checklist/items/checklist_item_page.dart';
import 'package:super_green_app/pages/checklist/shortcuts/create_monitoring.dart';
import 'package:super_green_app/pages/checklist/shortcuts/create_timer_reminder.dart';
import 'package:super_green_app/pages/checklist/shortcuts/create_watering_reminder.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/checklist/actions/checklist_action_page.dart';
import 'package:super_green_app/widgets/appbar.dart';
// ignore: unused_import
import 'package:super_green_app/widgets/feed_form/feed_form_textarea.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:tuple/tuple.dart';

class AppearAnimated extends StatefulWidget {
  final bool visible;
  final Widget child;

  const AppearAnimated({Key? key, required this.child, required this.visible})
      : super(key: key);

  @override
  State<AppearAnimated> createState() => _AppearAnimatedState();
}

class _AppearAnimatedState extends State<AppearAnimated> {
  bool visible = false;

  @override
  void initState() {
    Timer(Duration(milliseconds: 1), () {
      setState(() {
        visible = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible && widget.visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 150),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        child: widget.child,
      ),
    );
  }
}

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? autocompleteTimer;

  bool showAutoChecklist = true;
  bool loadingAutoChecklist = false;
  bool showCreateMenu = false;

  bool showCreateTimeReminder = false;
  bool showCreateMonitoring = false;
  bool showCreateWateringReminder = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChecklistBloc, ChecklistBlocState>(
      listener: (BuildContext context, ChecklistBlocState state) {
        if (state is ChecklistBlocStateLoaded) {
          setState(() {
            if (loadingAutoChecklist) {
              AppDB().setCloseAutoChecklist(state.checklist.id);
            }
            showAutoChecklist =
                !AppDB().isCloseAutoChecklist(state.checklist.id);
            loadingAutoChecklist = false;
          });
        }
      },
      child: BlocBuilder<ChecklistBloc, ChecklistBlocState>(
          bloc: BlocProvider.of<ChecklistBloc>(context),
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is ChecklistBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is ChecklistBlocStateLoaded) {
              if (state.checklistSeeds.length != 0 ||
                  _searchController.text != '') {
                body = _renderLoaded(context, state);
              } else {
                body = _renderEmpty(context, state);
              }
              if (showCreateTimeReminder ||
                  showCreateMonitoring ||
                  showCreateWateringReminder) {
                body = Stack(
                  children: [
                    body,
                    InkWell(
                      onTap: () {
                        setState(() {
                          showCreateWateringReminder = false;
                          showCreateMonitoring = false;
                          showCreateTimeReminder = false;
                        });
                      },
                      child: Container(color: Color(0x45ffffff)),
                    ),
                    _renderCreatePopup(context, state),
                  ],
                );
              }
            }
            return Scaffold(
              backgroundColor: Color(0xffEDEDED),
              appBar: SGLAppBar(
                '🦜',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
                actions: state is ChecklistBlocStateLoaded
                    ? [
                        IconButton(
                          icon: PortalTarget(
                            closeDuration: Duration(milliseconds: 150),
                            visible: showCreateMenu,
                            anchor: const Aligned(
                              follower: Alignment.topRight,
                              target: Alignment.bottomCenter,
                            ),
                            portalFollower: _renderCreateMenu(context, state),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showCreateMenu = !showCreateMenu;

                              showCreateWateringReminder = false;
                              showCreateMonitoring = false;
                              showCreateTimeReminder = false;
                            });
                          },
                        ),
                      ]
                    : [],
              ),
              body: body,
            );
          }),
    );
  }

  Widget _renderCreateMenu(
      BuildContext context, ChecklistBlocStateLoaded state) {
    return AppearAnimated(
        visible: showCreateMenu,
        child: TapRegion(
          onTapOutside: (PointerDownEvent e) {
            setState(() {
              showCreateMenu = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            width: 300,
            height: state.checklist.serverID == null ? 250 : 310,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _renderCreateMenuItem(
                      context,
                      'assets/checklist/icon_watering.svg',
                      'Watering reminder', () {
                    setState(() {
                      showCreateMonitoring = false;
                      showCreateTimeReminder = false;

                      showCreateWateringReminder = true;
                      showCreateMenu = false;
                    });
                  }),
                  SvgPicture.asset('assets/checklist/line_separator.svg'),
                  _renderCreateMenuItem(
                      context,
                      'assets/checklist/icon_reminder.svg',
                      'Time reminder', () {
                    setState(() {
                      showCreateWateringReminder = false;
                      showCreateMonitoring = false;

                      showCreateTimeReminder = true;
                      showCreateMenu = false;
                    });
                  }),
                  SvgPicture.asset('assets/checklist/line_separator.svg'),
                  _renderCreateMenuItem(
                      context,
                      'assets/checklist/icon_monitoring.svg',
                      'Metric alert', () {
                    setState(() {
                      showCreateWateringReminder = false;
                      showCreateTimeReminder = false;

                      showCreateMonitoring = true;
                      showCreateMenu = false;
                    });
                  }),
                  SvgPicture.asset('assets/checklist/line_separator.svg'),
                  _renderCreateMenuItem(
                      context,
                      'assets/checklist/icon_custom.svg',
                      'Custom checklist seed', () {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToCreateChecklist(state.checklist));
                    setState(() {
                      showCreateMenu = false;
                    });
                  }),
                  state.checklist.serverID == null
                      ? Container()
                      : SvgPicture.asset('assets/checklist/line_separator.svg'),
                  state.checklist.serverID == null
                      ? Container()
                      : _renderCreateMenuItem(
                          context,
                          'assets/checklist/icon_collections.svg',
                          'Collections', () {
                          BlocProvider.of<MainNavigatorBloc>(context).add(
                              MainNavigateToChecklistCollections(
                                  state.checklist));
                        }),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _renderCreateMenuItem(
      BuildContext context, String icon, String title, Function()? onTap) {
    Widget body = Row(
      children: [
        SizedBox(
          width: 50,
          height: 32,
          child: SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
          ),
        ),
        Expanded(child: Text(title)),
        onTap == null
            ? Container()
            : SvgPicture.asset('assets/checklist/icon_menu_add.svg'),
      ],
    );
    if (onTap == null) {
      return body;
    }
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: body,
      ),
    );
  }

  Widget _renderEmpty(BuildContext context, ChecklistBlocStateLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _renderAutoChecklistPopulate(context, state),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your checklist is empty.\nPress the button below to start using it.',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: Color(0xff454545)),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GreenButton(
                  title: '+ Create new item',
                  onPressed: () {
                    setState(() {
                      showCreateMenu = true;

                      showCreateWateringReminder = false;
                      showCreateMonitoring = false;
                      showCreateTimeReminder = false;
                    });
                  },
                ),
              ),
              state.checklist.serverID == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        children: [
                          Text(
                            'Or checkout our pre-made\nchecklist collections:',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                color: Color(0xff454545)),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GreenButton(
                              color: 0xFF673AB7,
                              onPressed: () {
                                BlocProvider.of<MainNavigatorBloc>(context).add(
                                    MainNavigateToChecklistCollections(
                                        state.checklist));
                              },
                              title: '🦜 View collections',
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderLoaded(BuildContext context, ChecklistBlocStateLoaded state) {
    List<Widget> actions = [];
    if (state.actions == null || state.actions!.length == 0) {
      actions = [_renderNoActions(context, state)];
    } else {
      DateTime? currentDate;
      int? currentChecklistSeedID;
      for (Tuple3<ChecklistSeed, ChecklistAction, ChecklistLog> action
          in state.actions!) {
        if (currentDate == null ||
            DateFormat('E MMM d k').format(currentDate) !=
                DateFormat('E MMM d k').format(action.item3.date)) {
          currentDate = action.item3.date;
          String formattedDate = DateFormat('E MMM d').format(currentDate);
          actions.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  formattedDate == DateFormat('E MMM d').format(DateTime.now())
                      ? 'Today'
                      : formattedDate,
                  style: TextStyle(
                    fontSize: 19,
                    color: Color(0xff959595),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ));
        }
        if (currentChecklistSeedID == null ||
            currentChecklistSeedID != action.item1.id) {
          currentChecklistSeedID = action.item1.id;
          int days = DateTime.now().difference(action.item3.date).inDays;
          Color color = Color(0xff3bb30b);
          if (days >= 2) {
            color = Color(0xffb32d0b);
          } else if (days == 1) {
            color = Color(0xffb3780b);
          }

          actions.add(Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  action.item1.title,
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ));
        }
        actions.add(Padding(
          padding: const EdgeInsets.only(
            bottom: 4.0,
            left: 8.0,
            right: 8.0,
          ),
          child: ChecklistActionButton.getActionPage(
              plant: state.plant,
              box: state.box,
              checklistSeed: action.item1,
              checklistAction: action.item2,
              summarize: true,
              onCheck: () {
                BlocProvider.of<ChecklistBloc>(context)
                    .add(ChecklistBlocEventCheckChecklistLog(action.item3));
              },
              onSkip: () {
                BlocProvider.of<ChecklistBloc>(context)
                    .add(ChecklistBlocEventSkipChecklistLog(action.item3));
              }),
        ));
      }
    }

    bool? currentMine = null;
    return ListView(
      children: [
        _renderAutoChecklistPopulate(context, state),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 0,
          ),
          child: CreateChecklistSection(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 24.0,
                        bottom: 8.0,
                      ),
                      child: Text('To-Do',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff454545),
                            fontSize: 24,
                          )),
                    ),
                    ...actions,
                    Container(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16.0,
                      ),
                      child:
                          Text('Future items (${state.checklistSeeds.length})',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff454545),
                                fontSize: 24,
                              )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _renderSearchField(context),
                    ),
                    ...state.checklistSeeds.map((cks) {
                      ChecklistCollection? collection = state.collections
                          .firstWhereOrNull((c) => c.id == cks.collection);
                      Widget body = ChecklistItemPage(
                        plant: state.plant,
                        box: state.box,
                        checklistSeed: cks,
                        collection: collection,
                        onSelect: cks.mine == false
                            ? null
                            : () {
                                BlocProvider.of<MainNavigatorBloc>(context).add(
                                    MainNavigateToCreateChecklist(
                                        state.checklist,
                                        checklistSeed: cks));
                              },
                        onDelete: cks.mine == false
                            ? null
                            : () {
                                _deleteChecklistSeed(context, cks);
                              },
                      );
                      if (currentMine != cks.mine) {
                        body = Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                  cks.mine ? 'Your items' : 'Collection items',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff454545),
                                      fontSize: 18)),
                            ),
                            body,
                          ],
                        );
                        currentMine = cks.mine;
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: body,
                      );
                    }).toList(),
                    Container(
                      height: 30.0,
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  // TODO DRY
  Widget _renderSearchField(BuildContext context) {
    Widget trailing;
    if (_searchController.text == '') {
      trailing = SvgPicture.asset('assets/explorer/icon_search.svg');
    } else {
      trailing = InkWell(
        child: Icon(Icons.clear),
        onTap: () {
          setState(() {
            _searchController.text = '';
            BlocProvider.of<ChecklistBloc>(context)
                .add(ChecklistBlocEventFilter(''));
            _searchFocus.unfocus();
          });
        },
      );
    }
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xffc8c8c8)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: [
          Expanded(
            child: TextFormField(
              focusNode: _searchFocus,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              onChanged: (value) {
                autocompleteTimer?.cancel();
                autocompleteTimer = Timer(Duration(milliseconds: 500), () {
                  BlocProvider.of<ChecklistBloc>(context)
                      .add(ChecklistBlocEventFilter(value));
                  autocompleteTimer = null;
                });
              },
            ),
          ),
          trailing,
        ]),
      ),
    );
  }

  Widget _renderNoActions(
      BuildContext context, ChecklistBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '🎉',
            style: TextStyle(fontSize: 60),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'You\'re all set for today 👌',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff808080)),
          ),
        ),
      ],
    );
  }

  Widget _renderCreatePopup(
      BuildContext context, ChecklistBlocStateLoaded state) {
    Widget popupBody = Container();
    double? height;
    if (showCreateTimeReminder) {
      height = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewInsets.bottom -
          150;
      popupBody = Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: _renderCreateMenuItem(context,
              'assets/checklist/icon_reminder.svg', 'Time reminder', null),
        ),
        Expanded(
          child: CreateTimerReminder(
            checklist: state.checklist,
            onClose: () {
              setState(() {
                showCreateWateringReminder = false;
                showCreateMonitoring = false;
                showCreateTimeReminder = false;
              });
            },
          ),
        ),
      ]);
    } else if (showCreateMonitoring) {
      height = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewInsets.bottom -
          150;
      popupBody = Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: _renderCreateMenuItem(context,
              'assets/checklist/icon_monitoring.svg', 'Metric alert', null),
        ),
        Expanded(
          child: CreateMonitoring(
            checklist: state.checklist,
            onClose: () {
              setState(() {
                showCreateWateringReminder = false;
                showCreateMonitoring = false;
                showCreateTimeReminder = false;
              });
            },
          ),
        ),
      ]);
    } else if (showCreateWateringReminder) {
      popupBody = Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: _renderCreateMenuItem(context,
              'assets/checklist/icon_watering.svg', 'Watering reminder', null),
        ),
        CreateWateringReminder(
          checklist: state.checklist,
          onClose: () {
            setState(() {
              showCreateWateringReminder = false;
              showCreateMonitoring = false;
              showCreateTimeReminder = false;
            });
          },
        ),
      ]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 350,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: popupBody,
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderAutoChecklistPopulate(
      BuildContext context, ChecklistBlocStateLoaded state) {
    if (!showAutoChecklist ||
        state.checklist.serverID == null ||
        state.collections.indexWhere((c) =>
                c.serverID == BackendAPI().checklistCollectionTheBasics) !=
            -1) {
      return Container(
        height: 12.0,
      );
    }

    if (loadingAutoChecklist) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CreateChecklistSection(
          title: 'Auto checklist',
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FullscreenLoading(
              title: 'Loading collection..',
              size: 40,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CreateChecklistSection(
        titleWidget: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 12.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SvgPicture.asset(
                    ChecklistCollectionCategoryIcons[CO_BASICS]!),
              ),
              Text('Add daily checks?',
                  maxLines: 3,
                  style: TextStyle(
                    color: Color(0xff454545),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        onClose: () {
          setState(() {
            this.showAutoChecklist = false;
            AppDB().setCloseAutoChecklist(state.checklist.id);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Don\'t want to spend time configuring alerts?\n\nSubscribe to the "Daily checks" collection and receive notifications about the most common things to pay attention to for a successful grow.',
                    style: TextStyle(color: Color(0xff454545))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GreenButton(
                    onPressed: () {
                      setState(() {
                        this.loadingAutoChecklist = true;
                      });
                      BlocProvider.of<ChecklistBloc>(context)
                          .add(ChecklistBlocEventAutoChecklist());
                    },
                    title: 'Add collection',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteChecklistSeed(
      BuildContext context, ChecklistSeed checklistSeed) async {
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text('Delete item "${checklistSeed.title}"?'),
            content: Text('This can\'t be reverted. Continue?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm ?? false) {
      BlocProvider.of<ChecklistBloc>(context)
          .add(ChecklistBlocEventDeleteChecklistSeed(checklistSeed));
    }
  }
}
