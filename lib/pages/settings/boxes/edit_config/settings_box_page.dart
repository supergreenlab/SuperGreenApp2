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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device/select_device_page.dart';
import 'package:super_green_app/pages/settings/boxes/edit_config/settings_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class SettingsBoxPage extends StatefulWidget {
  @override
  _SettingsBoxPageState createState() => _SettingsBoxPageState();
}

class _SettingsBoxPageState extends State<SettingsBoxPage> {
  late TextEditingController _nameController;
  late Device? _device;
  late int? _deviceBox;
  late Device? _screenDevice;

  final KeyboardVisibilityController _keyboardVisibility =
      KeyboardVisibilityController();
  late StreamSubscription<bool> _listener;
  bool _keyboardVisible = false;

  @protected
  void initState() {
    super.initState();
    _listener = _keyboardVisibility.onChange.listen(
      (bool visible) {
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
      bloc: BlocProvider.of<SettingsBoxBloc>(context),
      listener: (BuildContext context, SettingsBoxBlocState state) async {
        if (state is SettingsBoxBlocStateLoaded) {
          _nameController = TextEditingController(text: state.box.name);
          _device = state.device;
          _deviceBox = state.deviceBox;
          _screenDevice = state.screenDevice;
        } else if (state is SettingsBoxBlocStateDone) {
          Timer(const Duration(milliseconds: 2000), () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(mustPop: true));
          });
        }
      },
      child: BlocBuilder<SettingsBoxBloc, SettingsBoxBlocState>(
          bloc: BlocProvider.of<SettingsBoxBloc>(context),
          builder: (BuildContext context, SettingsBoxBlocState state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is SettingsBoxBlocStateLoading) {
              body = FullscreenLoading(
                title: 'Loading..',
              );
            } else if (state is SettingsBoxBlocStateDone) {
              body = _renderDone(state);
            } else if (state is SettingsBoxBlocStateLoaded) {
              body = _renderForm(context, state);
            }
            return WillPopScope(
              onWillPop: () async {
                return (await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog.adaptive(
                            title: Text('Unsaved changes'),
                            content:
                                Text('Changes will not be saved. Continue?'),
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
                        })) ??
                    false;
              },
              child: Scaffold(
                  appBar: SGLAppBar(
                    '⚗️',
                    fontSize: 35,
                    backgroundColor: Colors.yellow,
                    titleColor: Colors.green,
                    iconColor: Colors.green,
                    hideBackButton: state is SettingsBoxBlocStateDone,
                  ),
                  backgroundColor: Colors.white,
                  body: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200), child: body)),
            );
          }),
    );
  }

  Widget _renderDone(SettingsBoxBlocStateDone state) {
    String subtitle = _device != null
        ? 'Lab ${_nameController.value.text} on controller ${_device!.name} updated:)'
        : 'Lab ${_nameController.value.text}';
    return Fullscreen(
        title: 'Done!',
        subtitle: subtitle,
        child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm(BuildContext context, SettingsBoxBlocStateLoaded state) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              SectionTitle(
                title: 'Lab name',
                icon: 'assets/settings/icon_lab.svg',
                backgroundColor: Colors.yellow,
                titleColor: Colors.green,
                elevation: 5,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                child: SGLTextField(
                    hintText: 'Ex: Gorilla Kush',
                    controller: _nameController,
                    onChanged: (_) {
                      setState(() {});
                    }),
              ),
              SectionTitle(
                title: 'Lab controller',
                icon: 'assets/box_setup/icon_controller.svg',
                backgroundColor: Color(0xff0b6ab3),
                titleColor: Colors.white,
                elevation: 5,
              ),
              _device != null
                  ? ListTile(
                      leading: SvgPicture.asset(
                          'assets/box_setup/icon_controller.svg'),
                      title: Text('${_device!.name} box #${_deviceBox! + 1}'),
                      subtitle: Text('Tap to change'),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        _handleChangeController(context);
                      },
                    )
                  : ListTile(
                      leading: SvgPicture.asset(
                          'assets/settings/icon_nocontroller.svg'),
                      title: Text('Lab isn\'t linked to any controller'),
                      subtitle: Text('Tap to link one'),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        _handleChangeController(context);
                      },
                    ),
              SectionTitle(
                title: 'Lab screen',
                icon: 'assets/box_setup/icon_controller.svg',
                backgroundColor: Color(0xff0b6ab3),
                titleColor: Colors.white,
                elevation: 5,
              ),
              _screenDevice != null
                  ? ListTile(
                      leading: SvgPicture.asset(
                          'assets/box_setup/icon_controller.svg'),
                      title: Text('${_screenDevice!.name}'),
                      subtitle: Text('Tap to change'),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        _handleChangeScreen(context);
                      },
                    )
                  : ListTile(
                      leading: SvgPicture.asset(
                          'assets/settings/icon_nocontroller.svg'),
                      title: Text('Lab isn\'t linked to any screen'),
                      subtitle: Text('Tap to link one'),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        _handleChangeScreen(context);
                      },
                    ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: SafeArea(
              child: GreenButton(
                title: 'UPDATE LAB',
                onPressed: _nameController.value.text != ''
                    ? () => _handleInput(context)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleChangeController(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToSelectDeviceEvent(
            isController: true,
            futureFn: (future) async {
              dynamic res = await future;
              if (res is SelectBoxDeviceData) {
                setState(() {
                  _device = res.device;
                  _deviceBox = res.deviceBox;
                  if (_screenDevice == null && _device!.isScreen == true) {
                    _screenDevice = _device;
                  }
                });
              } else if (res is bool && res == false) {
                setState(() {
                  if (_device != null &&
                      _screenDevice != null &&
                      _device!.id == _screenDevice!.id) {
                    _screenDevice = null;
                  }
                  _device = null;
                  _deviceBox = null;
                });
              }
            }));
  }

  void _handleChangeScreen(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToSelectDeviceEvent(
            isScreen: true,
            futureFn: (future) async {
              dynamic res = await future;
              if (res is SelectBoxDeviceData) {
                setState(() {
                  _screenDevice = res.device;
                });
              } else if (res is bool && res == false) {
                setState(() {
                  _screenDevice = null;
                });
              }
            }));
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<SettingsBoxBloc>(context).add(SettingsBoxBlocEventUpdate(
      _nameController.text,
      _device,
      _deviceBox,
      _screenDevice,
    ));
  }

  @override
  void dispose() {
    _listener.cancel();
    _nameController.dispose();
    super.dispose();
  }
}
