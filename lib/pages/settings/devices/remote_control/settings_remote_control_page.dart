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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/devices/remote_control/settings_remote_control_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/red_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SettingsRemoteControlPage extends StatefulWidget {
  static String settingsRemoteControlPageControllerDone(String name) {
    return Intl.message(
      'Controller $name paired for remote control!',
      args: [name],
      name: 'settingsRemoteControlPageControllerDone',
      desc: 'Controller remote control setup confirmation text',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get settingsRemoteControlPageInstructionsNeedUpgrade {
    return Intl.message(
      '**Please upgrade your controller** to enable remote control.\n\n**Go back to the previous screen** and tap the **"Firmware upgrade"** button.',
      name: 'settingsRemoteControlPageInstructionsNeedUpgrade',
      desc: 'Explanation for remote control when needing to upgrade controller',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get settingsRemoteControlPageInstructions {
    return Intl.message(
      '**Remote control requires to pair your mobile phone**. Please keep in mind: for now only **one** mobile phone can be paired at a time.',
      name: 'settingsRemoteControlPageInstructions',
      desc: 'Explanation for remote control',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get settingsRemoteControlPagePleaseLoginDialogTitle {
    return Intl.message(
      'Login required',
      name: 'settingsRemoteControlPagePleaseLoginDialogTitle',
      desc: 'Login/create account dialog title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get settingsRemoteControlPagePleaseLoginDialogBody {
    return Intl.message(
      'Login is required to enable remote control.',
      name: 'settingsRemoteControlPagePleaseLoginDialogBody',
      desc: 'Login/create account dialog body',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  _SettingsRemoteControlPageState createState() => _SettingsRemoteControlPageState();
}

class _SettingsRemoteControlPageState extends State<SettingsRemoteControlPage> {
  Device device;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<SettingsRemoteControlBloc>(context),
      listener: (BuildContext context, SettingsRemoteControlBlocState state) async {
        if (state is SettingsRemoteControlBlocStateLoaded) {
          this.device = state.device;
        } else if (state is SettingsRemoteControlBlocStateDonePairing) {
          await Future.delayed(Duration(seconds: 2));
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true));
        }
      },
      child: BlocBuilder<SettingsRemoteControlBloc, SettingsRemoteControlBlocState>(
          cubit: BlocProvider.of<SettingsRemoteControlBloc>(context),
          builder: (BuildContext context, SettingsRemoteControlBlocState state) {
            Widget body;
            if (state is SettingsRemoteControlBlocStateDonePairing) {
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
                  hideBackButton: state is SettingsRemoteControlBlocStateDonePairing,
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
      Expanded(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                fitContent: true,
                data: state.needsUpgrade
                    ? SettingsRemoteControlPage.settingsRemoteControlPageInstructionsNeedUpgrade
                    : SettingsRemoteControlPage.settingsRemoteControlPageInstructions,
                styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: state.needsUpgrade
                ? RedButton(
                    title: 'GO BACK',
                    onPressed: () {
                      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true));
                    },
                  )
                : GreenButton(
                    onPressed: () {
                      if (state.loggedIn) {
                        BlocProvider.of<SettingsRemoteControlBloc>(context).add(SettingsRemoteControlBlocEventPair());
                      } else {
                        _login(context);
                      }
                    },
                    title: state.signingSetup ? 'RE-PAIR CONTROLLER' : 'PAIR CONTROLLER',
                  ),
          ),
        ],
      ),
    ]);
  }

  void _login(BuildContext context) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(SettingsRemoteControlPage.settingsRemoteControlPagePleaseLoginDialogTitle),
            content: Text(SettingsRemoteControlPage.settingsRemoteControlPagePleaseLoginDialogBody),
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
      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth(futureFn: (future) async {
        bool done = await future;
        if (done == true) {
          BlocProvider.of<SettingsRemoteControlBloc>(context).add(SettingsRemoteControlBlocEventPair());
        }
      }));
    }
  }
}
