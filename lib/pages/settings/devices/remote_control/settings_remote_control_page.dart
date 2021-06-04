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
import 'package:super_green_app/pages/settings/devices/remote_control/settings_remote_control_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SettingsRemoteControlPage extends StatefulWidget {
  static String settingsRemoteControlPageControllerDone(String name) {
    return Intl.message(
      'Controller $name paired for remote control!',
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

  @override
  _SettingsRemoteControlPageState createState() => _SettingsRemoteControlPageState();
}

class _SettingsRemoteControlPageState extends State<SettingsRemoteControlPage> {
  Device device;
  bool done = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<SettingsRemoteControlBloc>(context),
      listener: (BuildContext context, SettingsRemoteControlBlocState state) async {
        if (state is SettingsRemoteControlBlocStateLoaded) {
          this.device = state.device;
        } else if (state is SettingsRemoteControlBlocStateDonePairing) {
          setState(() {
            this.done = true;
          });
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            this.done = false;
          });
        }
      },
      child: BlocBuilder<SettingsRemoteControlBloc, SettingsRemoteControlBlocState>(
          cubit: BlocProvider.of<SettingsRemoteControlBloc>(context),
          builder: (BuildContext context, SettingsRemoteControlBlocState state) {
            Widget body;
            if (this.done) {
              body = _renderDonePairing();
            } else if (state is SettingsRemoteControlBlocStateLoading) {
              body = FullscreenLoading(
                title: CommonL10N.loading,
              );
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

  Widget _renderDonePairing() {
    String subtitle = SettingsRemoteControlPage.settingsRemoteControlPageControllerDone(device.name);
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
              title: state.signingSetup ? 'RE-PAIR CONTROLLER' : 'PAIR CONTROLLER',
            ),
          ),
        ],
      ),
    ]);
  }
}
