/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pages/explorer/explorer_bloc.dart';
import 'package:super_green_app/pages/explorer/explorer_feed_delegate.dart';
import 'package:super_green_app/pages/explorer/models/plants.dart';
import 'package:super_green_app/pages/explorer/search/search_bloc.dart';
import 'package:super_green_app/pages/explorer/search/search_page.dart';
import 'package:super_green_app/pages/explorer/sections/discussions/discussions_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/discussions/discussions_page.dart';
import 'package:super_green_app/pages/explorer/sections/followed/followed_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/followed/followed_page.dart';
import 'package:super_green_app/pages/explorer/sections/likes/likes_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/likes/likes_page.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/list_title.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class ExplorerPage extends TraceableStatefulWidget {
  static String get explorerPageTitle {
    return Intl.message(
      'Explorer',
      name: 'explorerPageTitle',
      desc: 'Explorer page title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get explorerPageSelectPlantTitle {
    return Intl.message(
      'Select which plant you want to make public',
      name: 'explorerPageSelectPlantTitle',
      desc: 'Title of the select page when selecting a plant to make public',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String explorerPagePublicPlantConfirmation(String name) {
    return Intl.message(
      'Plant $name is now public',
      args: [name],
      name: 'explorerPagePublicPlantConfirmation',
      desc: 'Confirmation text when a plant is now public',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get explorerPagePleaseLoginDialogTitle {
    return Intl.message(
      'Make a plant public',
      name: 'explorerPagePleaseLoginDialogTitle',
      desc: 'Title for the dialog when the user is not connected',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get explorerPagePleaseLoginDialogBody {
    return Intl.message(
      'You need to be logged in to make a plant public.',
      name: 'explorerPagePleaseLoginDialogBody',
      desc: 'Content for the dialog when the user is not connected',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _ExplorerPageState createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  final TextEditingController searchController = TextEditingController();
  bool showSearchResults = false;

  Timer autocompleteTimer;
  bool searchLoading = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        showSearchResults = searchController.text != '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExplorerBloc, ExplorerBlocState>(
      listener: (BuildContext context, ExplorerBlocState state) {
        if (state is ExplorerBlocStateLoaded) {}
      },
      child: BlocBuilder<ExplorerBloc, ExplorerBlocState>(
          cubit: BlocProvider.of<ExplorerBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is ExplorerBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is ExplorerBlocStateLoaded) {
              body = _renderFeed(context, state);
            }
            return Scaffold(
              appBar: SGLAppBar(
                '',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
                hideBackButton: true,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:
                      SizedBox(width: 100, height: 100, child: SvgPicture.asset('assets/explorer/logo_sgl_white.svg')),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.bookmark_outline_sharp,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToBookmarks());
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () => onMakePublic(state),
                  ),
                ],
              ),
              body: body,
            );
          }),
    );
  }

  Widget _renderFeed(BuildContext context, ExplorerBlocStateLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _renderSearchField(context, state),
        Expanded(
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                BlocProvider(
                  create: (context) => FeedBloc(ExplorerFeedBlocDelegate()),
                  child: FeedPage(
                    title: '',
                    color: Colors.white,
                    feedColor: Colors.white,
                    elevate: false,
                    appBarEnabled: false,
                    cardActions: (FeedEntryState state) {
                      return [
                        IconButton(
                          icon: Text(
                            'Open plant',
                            style: TextStyle(fontSize: 12.0, color: Color(0xff3bb30b), fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            BlocProvider.of<MainNavigatorBloc>(context)
                                .add(MainNavigateToPublicPlant(state.plantID, feedEntryID: state.feedEntryID));
                          },
                        )
                      ];
                    },
                    firstItem: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BlocProvider(
                            create: (context) => FollowedBloc(),
                            child: FollowedPage(),
                          ),
                          BlocProvider(
                            create: (context) => DiscussionsBloc(),
                            child: DiscussionsPage(),
                          ),
                          BlocProvider(
                            create: (context) => LikesBloc(),
                            child: LikesPage(),
                          ),
                          ListTitle(title: 'Latest pics'),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  key: Key('Search'),
                  bottom: showSearchResults ? 0 : constraints.maxHeight,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    color: Colors.white,
                    child: SearchPage(),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _renderSearchField(BuildContext context, ExplorerBlocStateLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xffe9e9e9),
          border: Border.all(width: 1, color: Color(0xffd8d8d8)),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: [
            Expanded(
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchLoading = true;
                  });
                  if (autocompleteTimer != null) {
                    autocompleteTimer.cancel();
                  }
                  autocompleteTimer = Timer(Duration(milliseconds: 500), () {
                    BlocProvider.of<SearchBloc>(context).add(SearchBlocEventSearch(value, 0));
                    autocompleteTimer = null;
                    setState(() {
                      searchLoading = false;
                    });
                  });
                },
              ),
            ),
            SvgPicture.asset('assets/explorer/icon_search.svg'),
          ]),
        ),
      ),
    );
  }

  void onMakePublic(ExplorerBlocState state) {
    if (state is ExplorerBlocStateLoaded && state.loggedIn) {
      BlocProvider.of<MainNavigatorBloc>(context).add(
          MainNavigateToSelectPlantEvent(ExplorerPage.explorerPageSelectPlantTitle, futureFn: (Future future) async {
        dynamic plant = await future;
        if (plant == null) {
          return;
        }
        if (plant is Plant) {
          BlocProvider.of<ExplorerBloc>(context).add(ExplorerBlocEventMakePublic(plant));
          Fluttertoast.showToast(msg: ExplorerPage.explorerPagePublicPlantConfirmation(plant.name));
          Timer(Duration(milliseconds: 1000), () {
            BlocProvider.of<NotificationsBloc>(context).add(NotificationsBlocEventRequestPermission());
          });
        }
      }));
    } else {
      _login(context);
    }
  }

  void _login(BuildContext context) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(ExplorerPage.explorerPagePleaseLoginDialogTitle),
            content: Text(ExplorerPage.explorerPagePleaseLoginDialogBody),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(CommonL10N.cancel),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(CommonL10N.loginCreateAccount),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth());
    }
  }
}
