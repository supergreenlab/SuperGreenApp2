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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/pages/settings/devices/auth/settings_device_auth_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class SettingsDeviceAuthPage extends StatefulWidget {
  static String settingsDeviceAuthPageControllerDone(String name) {
    return Intl.message(
      'Controller $name setup!',
      args: [name],
      name: 'settingsDeviceAuthPageControllerDone',
      desc: 'Controller remote control setup confirmation text',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String settingsDeviceAuthPagePasswordInstructions() {
    return Intl.message(
      'You can **setup a password** to prevent unauthorized parameter changes on your controller.\n\n*Please keep in mind that this is by no mean top-notch security. Mostly an anti-curious roommate/brother feature. Local network communication is not using https so subject to mitm.*',
      name: 'settingsDeviceAuthPageInstructions',
      desc: 'Password protection instructions',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String settingsDeviceAuthPagePasswordWarning() {
    return Intl.message(
      'Don\'t use your important password here.',
      name: 'settingsDeviceAuthPagePasswordWarning',
      desc: 'Password warning',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _SettingsDeviceAuthPageState createState() => _SettingsDeviceAuthPageState();
}

class _SettingsDeviceAuthPageState extends State<SettingsDeviceAuthPage> {
  Device device;
  bool done = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  TextEditingController _oldusernameController = TextEditingController();
  TextEditingController _oldpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<SettingsDeviceAuthBloc>(context),
      listener: (BuildContext context, SettingsDeviceAuthBlocState state) async {
        if (state is SettingsDeviceAuthBlocStateLoaded) {
          this.device = state.device;
        } else if (state is SettingsDeviceAuthBlocStateDonePairing) {
          setState(() {
            this.done = true;
          });
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            this.done = false;
          });
        }
      },
      child: BlocBuilder<SettingsDeviceAuthBloc, SettingsDeviceAuthBlocState>(
          cubit: BlocProvider.of<SettingsDeviceAuthBloc>(context),
          builder: (BuildContext context, SettingsDeviceAuthBlocState state) {
            Widget body;
            if (done) {
              body = _renderDoneAuth(state);
            } else if (state is SettingsDeviceAuthBlocStateLoading) {
              body = FullscreenLoading(
                title: CommonL10N.loading,
              );
            } else if (state is SettingsDeviceAuthBlocStateLoaded) {
              body = _renderForm(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  '🤖',
                  fontSize: 40,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                  hideBackButton:
                      state is SettingsDeviceAuthBlocStateDonePairing || state is SettingsDeviceAuthBlocStateDoneAuth,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderDoneAuth(SettingsDeviceAuthBlocStateDoneAuth state) {
    String subtitle = SettingsDeviceAuthPage.settingsDeviceAuthPageControllerDone(state.device.name);
    return Fullscreen(
        title: CommonL10N.done, subtitle: subtitle, child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm(BuildContext context, SettingsDeviceAuthBlocStateLoaded state) {
    return ListView(children: <Widget>[
      SectionTitle(
        title: 'Controller access control',
        icon: 'assets/settings/icon_lock.svg',
        backgroundColor: Color(0xff0b6ab3),
        titleColor: Colors.white,
        elevation: 5,
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                fitContent: true,
                data: SettingsDeviceAuthPage.settingsDeviceAuthPagePasswordInstructions(),
                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('Username',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SGLTextField(
            hintText: 'Ex: stant',
            controller: _usernameController,
            textCapitalization: TextCapitalization.none,
            onChanged: (_) {
              setState(() {});
            }),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
        child: Text('Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SGLTextField(
            hintText: '***',
            controller: _passwordController,
            obscureText: true,
            onChanged: (_) {
              setState(() {});
            }),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Text(SettingsDeviceAuthPage.settingsDeviceAuthPagePasswordWarning(),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              fontSize: 13,
              color: Colors.red,
            )),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GreenButton(
              onPressed: isValid(state)
                  ? () {
                      BlocProvider.of<SettingsDeviceAuthBloc>(context).add(SettingsDeviceAuthBlocEventSetAuth(
                        username: _usernameController.text,
                        password: _passwordController.text,
                        oldUsername: _oldusernameController.text,
                        oldPassword: _oldpasswordController.text,
                      ));
                    }
                  : null,
              title: 'SET CREDENTIALS',
            ),
          ),
        ],
      ),
    ]);
  }

  bool isValid(SettingsDeviceAuthBlocStateLoaded state) {
    if (state.authSetup) {
      return _oldusernameController.text.length >= 4 && _oldpasswordController.text.length >= 4;
    }
    return _usernameController.text.length >= 4 && _passwordController.text.length >= 4;
  }
}