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
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/new_device/new_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class NewDevicePage extends TraceableStatelessWidget {
  static String get newDevicePageTitle {
    return Intl.message(
      'Add controller',
      name: 'newDevicePageTitle',
      desc: 'New device page title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get newDevicePageEmojiWifiSectionTitle {
    return Intl.message(
      'Connecting to controller\'s wifi',
      name: 'newDevicePageEmojiWifiSectionTitle',
      desc: 'New device page emoji wifi section title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get instructionsNewDeviceWifiFailed {
    return Intl.message(
      '**Couldn\'t connect** to the 🤖🍁 wifi! Please go to your **mobile phone settings** to connect manually with the **following credentials**:',
      name: 'instructionsNewDeviceWifiFailed',
      desc: 'Instructions new device wifi failed',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get instructionsNewDeviceWifiFailed2 {
    return Intl.message(
      'SSID: 🤖🍁\nPassword: multipass',
      name: 'instructionsNewDeviceWifiFailed2',
      desc: 'Instructions new device wifi failed2',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get instructionsNewDeviceWifiFailed3 {
    return Intl.message(
      'Then press the **DONE** button below',
      name: 'instructionsNewDeviceWifiFailed3',
      desc: 'Instructions new device wifi failed3',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get newDeviceAutoConnect {
    return Intl.message(
      'Trying to connect\nautomatically',
      name: 'newDeviceAutoConnect',
      desc: 'Waiting wifi connection loading',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<NewDeviceBloc>(context),
      listener: (BuildContext context, NewDeviceBlocState state) {
        if (state is NewDeviceBlocStateConnectionToSSIDSuccess) {
          if (state.popOnComplete) {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop());
          } else {
            _startSetup(context);
          }
        }
      },
      child: BlocBuilder<NewDeviceBloc, NewDeviceBlocState>(
          cubit: BlocProvider.of<NewDeviceBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is NewDeviceBlocStateConnectingToSSID) {
              body = _renderLoading();
            } else if (state is NewDeviceBlocStateConnectionToSSIDFailed) {
              body = _renderFailed(context, state);
            } else {
              body = _renderLoading();
            }
            return Scaffold(
              appBar: SGLAppBar(
                NewDevicePage.newDevicePageTitle,
                backgroundColor: Color(0xff0b6ab3),
                titleColor: Colors.white,
                iconColor: Colors.white,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: 50,
                    color: Color(0xff0b6ab3),
                  ),
                  SectionTitle(
                    title: NewDevicePage.newDevicePageEmojiWifiSectionTitle,
                    icon: 'assets/box_setup/icon_search.svg',
                    backgroundColor: Color(0xff0b6ab3),
                    titleColor: Colors.white,
                    large: true,
                    elevation: 5,
                  ),
                  body,
                ],
              ),
            );
          }),
    );
  }

  Widget _renderFailed(BuildContext context, NewDeviceBlocStateConnectionToSSIDFailed state) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MarkdownBody(
              data: NewDevicePage.instructionsNewDeviceWifiFailed,
              styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    NewDevicePage.instructionsNewDeviceWifiFailed2,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MarkdownBody(
                    data: NewDevicePage.instructionsNewDeviceWifiFailed3,
                    styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: GreenButton(
                title: CommonL10N.doneButton,
                onPressed: () {
                  if (state.popOnComplete) {
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop());
                  } else {
                    _startSetup(context);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderLoading() {
    return Expanded(child: FullscreenLoading(title: NewDevicePage.newDeviceAutoConnect));
  }

  void _startSetup(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToDeviceSetupEvent('192.168.4.1', futureFn: (future) async {
      Device device = await future;
      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: device));
    }));
  }
}
