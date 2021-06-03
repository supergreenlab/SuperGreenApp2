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
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/pages/settings/devices/remote_control/settings_remote_control_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class SettingsRemoteControlPage extends StatefulWidget {
  static String settingsRemoteControlPageControllerDone(String name) {
    return Intl.message(
      'Controller $name setup!',
      args: [name],
      name: 'settingsRemoteControlPageControllerDone',
      desc: 'Controller remote control setup confirmation text',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String settingsRemoteControlPageInstructions() {
    return Intl.message(
      '**Remote control requires to pair your mobile phone**. Please keep in mind: for now only **one** mobile phone can be paired at a time.',
      name: 'settingsRemoteControlPageInstructions',
      desc: 'Explanation for remote control',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String settingsRemoteControlPagePasswordInstructions() {
    return Intl.message(
      'You can now **setup a password** to prevent unauthorized parameter changes on your controller.\n\n*Please keep in mind that this is by no mean top-notch security. Mostly an anti-curious roommate/brother feature. Local network communication is not using https so subject to mitm.*',
      name: 'settingsRemoteControlPageInstructions',
      desc: 'Password protection instructions',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String settingsRemoteControlPagePasswordWarning() {
    return Intl.message(
      'Don\'t use your important password here.',
      name: 'settingsRemoteControlPagePasswordWarning',
      desc: 'Password warning',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _SettingsRemoteControlPageState createState() => _SettingsRemoteControlPageState();
}

class _SettingsRemoteControlPageState extends State<SettingsRemoteControlPage> {
  TextEditingController _usernameController;
  TextEditingController _passwordController;

  TextEditingController _oldusernameController;
  TextEditingController _oldpasswordController;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<SettingsRemoteControlBloc>(context),
      listener: (BuildContext context, SettingsRemoteControlBlocState state) async {},
      child: BlocBuilder<SettingsRemoteControlBloc, SettingsRemoteControlBlocState>(
          cubit: BlocProvider.of<SettingsRemoteControlBloc>(context),
          builder: (BuildContext context, SettingsRemoteControlBlocState state) {
            Widget body;
            if (state is SettingsRemoteControlBlocStateLoading) {
              body = FullscreenLoading(
                title: CommonL10N.loading,
              );
            } else if (state is SettingsRemoteControlBlocStateDonePairing) {
              body = _renderDonePairing(state);
            } else if (state is SettingsRemoteControlBlocStateDoneAuth) {
              body = _renderDoneAuth(state);
            } else if (state is SettingsRemoteControlBlocStateLoaded) {
              body = _renderForm(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  '🤖',
                  fontSize: 40,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                  hideBackButton: state is SettingsRemoteControlBlocStateDonePairing ||
                      state is SettingsRemoteControlBlocStateDoneAuth,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderDonePairing(SettingsRemoteControlBlocStateDonePairing state) {
    String subtitle = SettingsRemoteControlPage.settingsRemoteControlPageControllerDone(state.device.name);
    return Fullscreen(
        title: CommonL10N.done, subtitle: subtitle, child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderDoneAuth(SettingsRemoteControlBlocStateDoneAuth state) {
    String subtitle = SettingsRemoteControlPage.settingsRemoteControlPageControllerDone(state.device.name);
    return Fullscreen(
        title: CommonL10N.done, subtitle: subtitle, child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm(BuildContext context, SettingsRemoteControlBlocStateLoaded state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      SectionTitle(
        title: "Remote control setup",
        icon: 'assets/settings/icon_remotecontrol.svg',
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
                data: SettingsRemoteControlPage.settingsRemoteControlPageInstructions(),
                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GreenButton(
              onPressed: () {
                BlocProvider.of<SettingsRemoteControlBloc>(context).add(SettingsRemoteControlBlocEventPair());
              },
              title: 'PAIR CONTROLLER',
            ),
          ),
        ],
      ),
      SectionTitle(
        title: 'Controller access control',
        icon: 'assets/settings/icon_remotecontrol.svg',
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
                data: SettingsRemoteControlPage.settingsRemoteControlPagePasswordInstructions(),
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
        child: Text(SettingsRemoteControlPage.settingsRemoteControlPagePasswordWarning(),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              fontSize: 13,
              color: Colors.red,
            )),
      ),
    ]);
  }
}
