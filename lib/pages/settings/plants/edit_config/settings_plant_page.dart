import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pages/settings/plants/edit_config/settings_plant_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class SettingsPlantPage extends TraceableStatefulWidget {
  @override
  _SettingsPlantPageState createState() => _SettingsPlantPageState();
}

class _SettingsPlantPageState extends State<SettingsPlantPage> {
  TextEditingController _nameController;
  bool _public;
  Box _box;

  KeyboardVisibilityNotification _keyboardVisibility = KeyboardVisibilityNotification();

  int _listener;

  bool _keyboardVisible = false;

  @protected
  void initState() {
    super.initState();
    _listener = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
        if (!_keyboardVisible) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<SettingsPlantBloc>(context),
      listener: (BuildContext context, SettingsPlantBlocState state) async {
        if (state is SettingsPlantBlocStateLoaded) {
          _nameController = TextEditingController(text: state.plant.name);
          _public = state.plant.public;
          _box = state.box;
        } else if (state is SettingsPlantBlocStateDone) {
          if (_public) {
            Timer(const Duration(milliseconds: 1000), () {
              BlocProvider.of<NotificationsBloc>(context).add(NotificationsBlocEventRequestPermission());
            });
          }
          Timer(const Duration(milliseconds: 2000), () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true));
          });
        } else if (state is SettingsPlantBlocStateError) {
          Timer(const Duration(milliseconds: 3000), () {
            BlocProvider.of<SettingsPlantBloc>(context).add(SettingsPlantBlocEventInit());
          });
        }
      },
      child: BlocBuilder<SettingsPlantBloc, SettingsPlantBlocState>(
          cubit: BlocProvider.of<SettingsPlantBloc>(context),
          builder: (BuildContext context, SettingsPlantBlocState state) {
            Widget body;
            if (state is SettingsPlantBlocStateLoading) {
              body = FullscreenLoading(
                title: 'Loading..',
              );
            } else if (state is SettingsPlantBlocStateDone) {
              body = _renderDone(state);
            } else if (state is SettingsPlantBlocStateLoaded) {
              body = _renderForm(context, state);
            } else if (state is SettingsPlantBlocStateError) {
              body = _renderError(context, state);
            }
            return WillPopScope(
              onWillPop: () async {
                return await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Unsaved changed'),
                        content: Text('Changes will not be saved. Continue?'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text('NO'),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text('YES'),
                          ),
                        ],
                      );
                    });
              },
              child: Scaffold(
                  appBar: SGLAppBar(
                    '🍁',
                    fontSize: 40,
                    backgroundColor: Color(0xff0bb354),
                    titleColor: Colors.white,
                    iconColor: Colors.white,
                    hideBackButton: state is SettingsPlantBlocStateDone,
                  ),
                  backgroundColor: Colors.white,
                  body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body)),
            );
          }),
    );
  }

  Widget _renderDone(SettingsPlantBlocStateDone state) {
    String subtitle;
    if (state.archived ?? false) {
      subtitle = 'Plant ${_nameController.value.text} on lab ${_box.name} archived:)';
    } else {
      subtitle = 'Plant ${_nameController.value.text} on lab ${_box.name} updated:)';
    }
    return Fullscreen(title: 'Done!', subtitle: subtitle, child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm(BuildContext context, SettingsPlantBlocStateLoaded state) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              SectionTitle(
                title: 'Plant name',
                icon: 'assets/box_setup/icon_box_name.svg',
                backgroundColor: Color(0xff0bb354),
                titleColor: Colors.white,
                elevation: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 24.0),
                child: SGLTextField(
                    hintText: 'Ex: Gorilla Kush',
                    controller: _nameController,
                    onChanged: (_) {
                      setState(() {});
                    }),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _renderOptionCheckbx(context, 'Make this plant public', (bool newValue) {
                    setState(() {
                      _public = newValue;
                    });
                  }, _public)),
              ListTile(
                leading: SvgPicture.asset('assets/settings/icon_alerts.svg'),
                title: Text('Alert settings'),
                subtitle: Text('Tap to enable and edit settings'),
                trailing: Icon(Icons.edit),
                onTap: () {
                  BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsPlantAlerts(state.plant));
                },
              ),
              SectionTitle(
                title: 'Plant lab',
                icon: 'assets/settings/icon_lab.svg',
                backgroundColor: Colors.yellow,
                titleColor: Colors.green,
                elevation: 5,
              ),
              ListTile(
                leading: SvgPicture.asset('assets/settings/icon_lab.svg'),
                title: Text(_box.name),
                subtitle: Text('Tap to change'),
                trailing: Icon(Icons.edit),
                onTap: () {
                  _handleChangeBox(context);
                },
              ),
              SectionTitle(
                title: 'Archive plant',
                icon: 'assets/settings/icon_archive.svg',
                backgroundColor: Colors.red,
                titleColor: Colors.white,
                elevation: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  leading: SvgPicture.asset('assets/settings/icon_archive.svg'),
                  title: Text('Archive your plant when it\'s done'),
                  subtitle: Text(
                      'Archiving your plant will remove the plant from the list and all assets from your mobile phone. The plant will still be accessible in the "archived plants" section of the explorer tab.\n\nThis action can\'t be reverted.'),
                  trailing: Icon(Icons.archive),
                  onTap: () {
                    if (state.loggedIn) {
                      handlerArchivePlant(context);
                    } else {
                      _login(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GreenButton(
              title: 'UPDATE PLANT',
              onPressed: _nameController.value.text != '' ? () => _handleInput(context) : null,
            ),
          ),
        ),
      ],
    );
  }

  void _handleChangeBox(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSelectBoxEvent(futureFn: (future) async {
      dynamic res = await future;
      if (res is Box) {
        setState(() {
          _box = res;
        });
      }
    }));
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<SettingsPlantBloc>(context).add(SettingsPlantBlocEventUpdate(
      _nameController.text,
      _public,
      _box,
    ));
  }

  Widget _renderOptionCheckbx(BuildContext context, String text, Function(bool) onChanged, bool value) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            onChanged: onChanged,
            value: value,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                onChanged(!value);
              },
              child: MarkdownBody(
                fitContent: true,
                data: text,
                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _nameController.dispose();
    super.dispose();
  }

  void handlerArchivePlant(BuildContext context) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Archive plant?'),
            content: Text('This can\'t be reverted. Continue?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<SettingsPlantBloc>(context).add(SettingsPlantBlocEventArchive());
    }
  }

  void _login(BuildContext context) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Archive plant'),
            content: Text('Plant archiving requires a sgl account.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('CANCEL'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('LOGIN / CREATE ACCOUNT'),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth());
    }
  }

  Widget _renderError(BuildContext context, SettingsPlantBlocStateError state) {
    return Fullscreen(title: state.message, child: Icon(Icons.error, color: Colors.red, size: 100));
  }
}
