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
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_wifi/device_wifi_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class DeviceWifiPage extends TraceableStatefulWidget {
  static String get deviceWifiPageTitle {
    return Intl.message(
      'Controller Wifi setup',
      name: 'deviceWifiPageTitle',
      desc: 'Device wifi configuration page title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get deviceWifiPageNoControllerFound {
    return Intl.message(
      'Couldn\'t find the controller\non your network.',
      name: 'deviceWifiPageNoControllerFound',
      desc: 'Device wifi page controller not found on network after setting wifi credentials.',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get deviceWifiPageNotFoundRetry {
    return Intl.message(
      'Sometime it just takes a bit more time,\nretry search:',
      name: 'deviceWifiPageNotFoundRetry',
      desc: 'Device wifi page controller not found on network after setting wifi credentials.',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get deviceWifiPageRetrySearch {
    return Intl.message(
      'RETRY SEARCH',
      name: 'deviceWifiPageRetrySearch',
      desc: 'Retry search button',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get deviceWifiPageNotFoundInstructions {
    return Intl.message(
      'Is the emoji wifi back?\nThen the entered credentials were wrong.\nConnect to it, then tap this button:',
      name: 'deviceWifiPageNotFoundInstructions',
      desc: 'Instruction message to check wether connection failed or not',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get deviceWifiPageRetryCredentials {
    return Intl.message(
      'RETRY CREDENTIALS',
      name: 'deviceWifiPageRetryCredentials',
      desc: 'Retry credentials button',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get deviceWifiPageWifiInputLabel {
    return Intl.message(
      'Enter your home wifi SSID',
      name: 'deviceWifiPageWifiInputLabel',
      desc: 'Label for the wifi ssid input field',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get deviceWifiPageWifiPasswordLabel {
    return Intl.message(
      'Enter your home wifi password',
      name: 'deviceWifiPageWifiPasswordLabel',
      desc: 'Label for the wifi password input field',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get deviceWifiPageErrorConnectionEmoji {
    return Intl.message(
      'Make sure you are connected to the emoji wifi!',
      name: 'deviceWifiPageErrorConnectionEmoji',
      desc: 'Error message when the controller is unreachable',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get deviceWifiPageSearchingController {
    return Intl.message(
      'Searching controller on network\nplease wait..',
      name: 'deviceWifiPageSearchingController',
      desc: 'Loading message displayed when searching for controller on network',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String deviceWifiPageSearchingControllerTries(tries, totalTries) {
    return Intl.message(
      'Try\n$tries/$totalTries',
      args: [tries, totalTries],
      name: 'deviceWifiPageSearchingControllerTries',
      desc: 'Loading message displayed when searching for controller on network',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _DeviceWifiPageState createState() => _DeviceWifiPageState();
}

class _DeviceWifiPageState extends State<DeviceWifiPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _ssidFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

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
      cubit: BlocProvider.of<DeviceWifiBloc>(context),
      listener: (BuildContext context, DeviceWifiBlocState state) {
        if (state is DeviceWifiBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: state.device));
        }
      },
      child: BlocBuilder<DeviceWifiBloc, DeviceWifiBlocState>(
          cubit: BlocProvider.of<DeviceWifiBloc>(context),
          builder: (context, state) {
            bool canGoBack = !(state is DeviceWifiBlocStateSearching ||
                state is DeviceWifiBlocStateLoading ||
                state is DeviceWifiBlocStateNotFound);
            Widget body;
            if (state is DeviceWifiBlocStateLoading) {
              body = FullscreenLoading(title: CommonL10N.settingParameters);
            } else if (state is DeviceWifiBlocStateNotFound) {
              body = _renderNotfound();
            } else if (state is DeviceWifiBlocStateSearching) {
              body = _renderSearching(state);
            } else {
              body = _renderForm(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  DeviceWifiPage.deviceWifiPageTitle,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                  hideBackButton: !canGoBack,
                ),
                body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
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
              DeviceWifiPage.deviceWifiPageNoControllerFound,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
              child: Text(
                DeviceWifiPage.deviceWifiPageNotFoundRetry,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            GreenButton(
              title: DeviceWifiPage.deviceWifiPageRetrySearch,
              onPressed: () {
                BlocProvider.of<DeviceWifiBloc>(context).add(DeviceWifiBlocEventRetrySearch());
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
              child: Text(
                DeviceWifiPage.deviceWifiPageNotFoundInstructions,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            GreenButton(
              title: DeviceWifiPage.deviceWifiPageRetryCredentials,
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToNewDeviceEvent(true, futureFn: (future) async {
                  await future;
                  BlocProvider.of<DeviceWifiBloc>(context).add(DeviceWifiBlocEventRetypeCredentials());
                }));
              },
            )
          ],
        )),
      ],
    );
  }

  Widget _renderForm(BuildContext context, DeviceWifiBlocState state) {
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
              _renderInput(context, DeviceWifiPage.deviceWifiPageWifiInputLabel, '...', _ssidController,
                  onFieldSubmitted: (term) {
                _ssidFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_passFocusNode);
              },
                  focusNode: _ssidFocusNode,
                  error: state.error == true ? DeviceWifiPage.deviceWifiPageErrorConnectionEmoji : ''),
              _renderInput(context, DeviceWifiPage.deviceWifiPageWifiPasswordLabel, '...', _passController,
                  onFieldSubmitted: (term) {
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
              onPressed: _ssidController.text.length != 0 && _passController.text.length != 0
                  ? () => _handleInput(context)
                  : null,
              title: 'OK',
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderSearching(DeviceWifiBlocStateSearching state) {
    return FullscreenLoading(
      title: DeviceWifiPage.deviceWifiPageSearchingController,
      percent: state.tries / state.totalTries,
      circleText: DeviceWifiPage.deviceWifiPageSearchingControllerTries(state.tries, state.totalTries),
    );
  }

  Widget _renderInput(BuildContext context, String title, String hint, TextEditingController controller,
      {Function(String) onFieldSubmitted, FocusNode focusNode, String error}) {
    return Column(children: [
      SectionTitle(
        title: title,
        icon: 'assets/box_setup/icon_controller.svg',
        backgroundColor: Color(0xff0b6ab3),
        titleColor: Colors.white,
        elevation: 5,
      ),
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SGLTextField(
              textCapitalization: TextCapitalization.none,
              hintText: hint,
              focusNode: focusNode,
              controller: controller,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: onFieldSubmitted,
              error: error,
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
    _ssidFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }
}
