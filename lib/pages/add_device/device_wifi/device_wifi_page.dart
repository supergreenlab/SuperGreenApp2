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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_wifi/device_wifi_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class DeviceWifiPage extends StatefulWidget {
  @override
  _DeviceWifiPageState createState() => _DeviceWifiPageState();
}

class _DeviceWifiPageState extends State<DeviceWifiPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _ssidFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

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
      bloc: BlocProvider.of<DeviceWifiBloc>(context),
      listener: (BuildContext context, DeviceWifiBlocState state) {
        if (state is DeviceWifiBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(param: state.device));
        }
      },
      child: BlocBuilder<DeviceWifiBloc, DeviceWifiBlocState>(
          bloc: BlocProvider.of<DeviceWifiBloc>(context),
          builder: (context, state) {
            bool canGoBack = !(state is DeviceWifiBlocStateSearching ||
                state is DeviceWifiBlocStateLoading);
            Widget body;
            if (state is DeviceWifiBlocStateNotFound) {
              body = _renderNotfound();
            } else if (state is DeviceWifiBlocStateSearching) {
              body = _renderSearching();
            } else {
              body = _renderForm(context);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  'Device Wifi setup',
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                  hideBackButton: !canGoBack,
                ),
                body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderNotfound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Icon(Icons.warning, color: Color(0xff3bb30b), size: 100),
            Text(
              'This device is already added!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        )),
      ],
    );
  }

  Widget _renderForm(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: _keyboardVisible ? 0 : 100,
                color: Color(0xff0b6ab3),
              ),
              _renderInput(
                  context, 'Enter your home wifi SSID', '...', _ssidController,
                  onFieldSubmitted: (term) {
                _ssidFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_passFocusNode);
              }, focusNode: _ssidFocusNode),
              _renderInput(context, 'Enter your home wifi password', '...',
                  _passController, onFieldSubmitted: (term) {
                _handleInput(context);
              }, focusNode: _passFocusNode),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GreenButton(
              onPressed: _ssidController.text.length != 0 &&
                      _passController.text.length != 0
                  ? () => _handleInput(context)
                  : null,
              title: 'OK',
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderSearching() {
    return FullscreenLoading(
        title: 'Searching device on network\nplease wait..');
  }

  Widget _renderInput(BuildContext context, String title, String hint,
      TextEditingController controller,
      {Function(String) onFieldSubmitted, FocusNode focusNode}) {
    return Column(children: [
      SectionTitle(
        title: title,
        icon: 'assets/box_setup/icon_controller.svg',
        backgroundColor: Color(0xff0b6ab3),
        titleColor: Colors.white,
      ),
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SGLTextField(
              hintText: hint,
              focusNode: focusNode,
              controller: controller,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: onFieldSubmitted,
              onChanged: (_) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    ]);
  }

  void _handleInput(BuildContext context) {
    BlocProvider.of<DeviceWifiBloc>(context).add(DeviceWifiBlocEventSetup(
      _ssidController.text,
      _passController.text,
    ));
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _ssidController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
