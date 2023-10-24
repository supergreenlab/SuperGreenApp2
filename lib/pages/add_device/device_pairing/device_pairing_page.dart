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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_pairing/device_pairing_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/red_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class DevicePairingPage extends StatefulWidget {
  static String get devicePairingPageTitle {
    return Intl.message(
      'Pair controller',
      name: 'devicePairingPageTitle',
      desc: 'Device pairing page title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get devicePairingPageLoading {
    return Intl.message(
      'Pairing controller..',
      name: 'devicePairingPageLoading',
      desc: 'Loading text when setting controller name',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get devicePairingPagePairControllerSectionTitle {
    return Intl.message(
      'Pair controller for remote control',
      name: 'devicePairingPagePairControllerSectionTitle',
      desc: 'Section title for the controller pairing setup',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get devicePairingPageInstructions {
    return Intl.message(
      '**You can now enable remote control**\n\n**Keep control** of your box, even when you\'re away! If you skip this step, you will still be able to monitor your box sensors remotely.\n\n**Pairing also allows to remotely change your controller parameters**, like adjusting blower settings from work.',
      name: 'devicePairingPageInstructions',
      desc: 'Explanation for remote control',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get devicePairingPageInstructionsNeedUpgrade {
    return Intl.message(
      '**Controller needs upgrade to enable remote control.** Once your controller is added to the app, head to the controllers settings to upgrade to the latest version.\n\n**Keep control** of your box, even when you\'re away! If you skip this step, you will still be able to monitor your box sensors remotely.\n\n**Pairing also allows to remotely change your controller parameters**, like adjusting blower settings from work.',
      name: 'devicePairingPageInstructionsNeedUpgrade',
      desc: 'Explanation for remote control',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get devicePairingPagePleaseLoginDialogTitle {
    return Intl.message(
      'Please login',
      name: 'devicePairingPagePleaseLoginDialogTitle',
      desc: 'Please login dialog title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get devicePairingPagePleaseLoginDialogBody {
    return Intl.message(
      'Remote control requires a sgl account, please create one or login.',
      name: 'devicePairingPagePleaseLoginDialogBody',
      desc: 'Please login dialog body',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  State<StatefulWidget> createState() => DevicePairingPageState();
}

class DevicePairingPageState extends State<DevicePairingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DevicePairingBloc, DevicePairingBlocState>(
      bloc: BlocProvider.of<DevicePairingBloc>(context),
      listener: (BuildContext context, DevicePairingBlocState state) async {
        if (state is DevicePairingBlocStateDone) {
          await Future.delayed(Duration(seconds: 2));
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true, param: state.device));
        }
      },
      child: BlocBuilder<DevicePairingBloc, DevicePairingBlocState>(
          bloc: BlocProvider.of<DevicePairingBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is DevicePairingBlocStateLoading || state is DevicePairingBlocStateInit) {
              body = _renderLoading();
            } else if (state is DevicePairingBlocStateDone) {
              body = Fullscreen(
                title: CommonL10N.done,
                child: Icon(
                  Icons.check,
                  color: Color(0xff3bb30b),
                  size: 100,
                ),
              );
            } else {
              body = _renderForm(context, state as DevicePairingBlocStateLoaded);
            }
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  appBar: SGLAppBar(
                    DevicePairingPage.devicePairingPageTitle,
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
    return FullscreenLoading(title: DevicePairingPage.devicePairingPageLoading);
  }

  Widget _renderForm(BuildContext context, DevicePairingBlocStateLoaded state) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          color: Color(0xff0b6ab3),
        ),
        SectionTitle(
          title: DevicePairingPage.devicePairingPagePairControllerSectionTitle,
          icon: 'assets/settings/icon_remotecontrol.svg',
          backgroundColor: Color(0xff0b6ab3),
          titleColor: Colors.white,
          large: true,
          elevation: 5,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MarkdownBody(
                    fitContent: true,
                    data: state.needsUpgrade
                        ? DevicePairingPage.devicePairingPageInstructionsNeedUpgrade
                        : DevicePairingPage.devicePairingPageInstructions,
                    styleSheet: MarkdownStyleSheet(p: TextStyle(color: Color(0xff454545), fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16.0),
              child: RedButton(
                onPressed: () {
                  BlocProvider.of<MainNavigatorBloc>(context)
                      .add(MainNavigatorActionPop(mustPop: true, param: state.device));
                },
                title: state.needsUpgrade ? 'I\'LL UPGRADE LATER' : 'SKIP',
              ),
            ),
            state.needsUpgrade
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GreenButton(
                      onPressed: () {
                        if (state.loggedIn) {
                          BlocProvider.of<DevicePairingBloc>(context).add(DevicePairingBlocEventPair());
                        } else {
                          _login(context);
                        }
                      },
                      title: 'PAIR CONTROLLER',
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  void _login(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(DevicePairingPage.devicePairingPagePleaseLoginDialogTitle),
            content: Text(DevicePairingPage.devicePairingPagePleaseLoginDialogBody),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(CommonL10N.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(CommonL10N.loginCreateAccount),
              ),
            ],
          );
        });
    if (confirm ?? false) {
      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsAuth(futureFn: (future) async {
        bool done = await future;
        if (done == true) {
          BlocProvider.of<DevicePairingBloc>(context).add(DevicePairingBlocEventPair());
        }
      }));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
