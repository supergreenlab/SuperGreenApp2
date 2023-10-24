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
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_name/device_name_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class DeviceNamePage extends StatefulWidget {
  static String get deviceNamePageTitle {
    return Intl.message(
      'Add controller',
      name: 'deviceNamePageTitle',
      desc: 'Device name page title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get deviceNamePageLoading {
    return Intl.message(
      'Setting controller name..',
      name: 'deviceNamePageLoading',
      desc: 'Loading text when setting controller name',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get deviceNamePageSetNameSectionTitle {
    return Intl.message(
      'Set controller\'s name',
      name: 'deviceNamePageSetNameSectionTitle',
      desc: 'Section title for the controller name input',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get deviceNamePageSetNameHint {
    return Intl.message(
      'ex: controller',
      name: 'deviceNamePageSetNameHint',
      desc: 'Hint for the controller name input',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  State<StatefulWidget> createState() => DeviceNamePageState();
}

class DeviceNamePageState extends State<DeviceNamePage> {
  final _nameController = TextEditingController();

  final KeyboardVisibilityController _keyboardVisibility = KeyboardVisibilityController();
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
    return BlocListener<DeviceNameBloc, DeviceNameBlocState>(
      bloc: BlocProvider.of<DeviceNameBloc>(context),
      listener: (BuildContext context, DeviceNameBlocState state) async {
        if (state is DeviceNameBlocStateDone) {
          await Future.delayed(Duration(seconds: 1));
          FutureFn ff = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToDeviceTestEvent(state.device, futureFn: ff.futureFn));
          bool done = await ff.future;
          if (done == true) {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true, param: state.device));
          } else {
            BlocProvider.of<DeviceNameBloc>(context).add(DeviceNameBlocEventReset());
          }
        }
      },
      child: BlocBuilder<DeviceNameBloc, DeviceNameBlocState>(
          bloc: BlocProvider.of<DeviceNameBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is DeviceNameBlocStateLoading) {
              body = _renderLoading();
            } else if (state is DeviceNameBlocStateDone) {
              body = Fullscreen(
                title: CommonL10N.done,
                child: Icon(
                  Icons.check,
                  color: Color(0xff3bb30b),
                  size: 100,
                ),
              );
            } else {
              body = _renderForm();
            }
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  appBar: SGLAppBar(
                    DeviceNamePage.deviceNamePageTitle,
                    hideBackButton: true,
                    backgroundColor: Color(0xff0b6ab3),
                    titleColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                  body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body)),
            );
          }),
    );
  }

  Widget _renderLoading() {
    return FullscreenLoading(title: DeviceNamePage.deviceNamePageLoading);
  }

  Widget _renderForm() {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _keyboardVisible ? 0 : 100,
          color: Color(0xff0b6ab3),
        ),
        SectionTitle(
          title: DeviceNamePage.deviceNamePageSetNameSectionTitle,
          icon: 'assets/box_setup/icon_controller.svg',
          backgroundColor: Color(0xff0b6ab3),
          titleColor: Colors.white,
          large: true,
          elevation: 5,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                child: SGLTextField(
                  hintText: DeviceNamePage.deviceNamePageSetNameHint,
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
              onPressed: _nameController.text.length > 0 ? () => _handleInput(context) : null,
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
    _listener.cancel();
    _nameController.dispose();
    super.dispose();
  }
}
