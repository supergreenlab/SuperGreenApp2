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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_name/device_name_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class DeviceNamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DeviceNamePageState();
}

class DeviceNamePageState extends State<DeviceNamePage> {
  final _nameController = TextEditingController();

  KeyboardVisibilityNotification _keyboardVisibility =
      KeyboardVisibilityNotification();
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
      bloc: BlocProvider.of<DeviceNameBloc>(context),
      listener: (BuildContext context, DeviceNameBlocState state) {
        if (state is DeviceNameBlocStateDone) {
          if (!state.requiresWifiSetup) {
            BlocProvider.of<MainNavigatorBloc>(context).add(
                MainNavigatorActionPop(param: state.device, mustPop: true));
            return;
          }
          BlocProvider.of<MainNavigatorBloc>(context).add(
              MainNavigateToDeviceWifiEvent(state.device,
                  futureFn: (future) async {
            await future;
            BlocProvider.of<MainNavigatorBloc>(context).add(
                MainNavigatorActionPop(param: state.device, mustPop: true));
          }));
        }
      },
      child: BlocBuilder<DeviceNameBloc, DeviceNameBlocState>(
          bloc: BlocProvider.of<DeviceNameBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is DeviceNameBlocStateLoading) {
              body = _renderLoading();
            } else {
              body = _renderForm();
            }
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  appBar: SGLAppBar(
                    'Add device',
                    hideBackButton: true,
                    backgroundColor: Colors.orange,
                    titleColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  body: body),
            );
          }),
    );
  }

  Widget _renderLoading() {
    return FullscreenLoading(title: 'Setting device name..');
  }

  Widget _renderForm() {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _keyboardVisible ? 0 : 100,
          color: Colors.orange,
        ),
        SectionTitle(
          title: 'Set device\'s name',
          icon: 'assets/box_setup/icon_controller.svg',
          backgroundColor: Colors.orange,
          titleColor: Colors.white,
          large: true,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                child: SGLTextField(
                  hintText: 'ex: Bob',
                  controller: _nameController,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GreenButton(
              onPressed: () => _handleInput(context),
              title: 'OK',
            ),
          ),
        ),
      ],
    );
  }

  void _handleInput(BuildContext context) {
    BlocProvider.of<DeviceNameBloc>(context).add(DeviceNameBlocEventSetName(
      _nameController.text,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
