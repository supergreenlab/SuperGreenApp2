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
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/add_device/add_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class AddDevicePage extends TraceableStatelessWidget {
  static String get addDevicePagePleaseLoginDialogTitle {
    return Intl.message(
      'Optional Login',
      name: 'addDevicePagePleaseLoginDialogTitle',
      desc: 'Please login dialog title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get addDevicePagePleaseLoginDialogBody {
    return Intl.message(
      'Optionnal login or account creation is preferable at this step.\nIt will allow to enable the remote control of your box for easier setup.\n\nNo personal infos required, not even an email address.',
      name: 'addDevicePagePleaseLoginDialogBody',
      desc: 'Please login dialog title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get addDevicePagePleaseLoginDialogSkip {
    return Intl.message(
      'Continue without',
      name: 'addDevicePagePleaseLoginDialogSkip',
      desc: 'Please login dialog title',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDeviceBloc, AddDeviceBlocState>(
        cubit: BlocProvider.of<AddDeviceBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: SGLAppBar(
              'Add new controller',
              backgroundColor: Color(0xff0b6ab3),
              titleColor: Colors.white,
              iconColor: Colors.white,
            ),
            body: Column(
              children: <Widget>[
                _renderChoice(
                    context,
                    'Brand new',
                    'assets/box_setup/icon_controller.svg',
                    'Choose this option if the controller is brand new or using it\'s own wifi (ie. if you can see a 🤖🍁 wifi).',
                    'CONNECT CONTROLLER',
                    () => _login(context, state, () {
                          BlocProvider.of<MainNavigatorBloc>(context)
                              .add(MainNavigateToNewDeviceEvent(false, futureFn: (future) async {
                            Device device = await future;
                            if (device != null) {
                              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: device));
                            }
                          }));
                        })),
                _renderChoice(
                    context,
                    'Already running',
                    'assets/box_setup/icon_controller.svg',
                    'Choose this option if the controller is already running and connected to your home wifi.',
                    'SEARCH CONTROLLER', () {
                  BlocProvider.of<MainNavigatorBloc>(context)
                      .add(MainNavigateToExistingDeviceEvent(futureFn: (future) async {
                    Device device = await future;
                    if (device != null) {
                      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: device));
                    }
                  }));
                }),
              ],
            )));
  }

  Widget _renderChoice(
      BuildContext context, String title, String icon, String description, String buttonTitle, Function onPressed) {
    return Column(children: [
      SectionTitle(
        title: title,
        icon: icon,
        backgroundColor: Color(0xff0b6ab3),
        titleColor: Colors.white,
        elevation: 5,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(description),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: GreenButton(
            title: buttonTitle,
            onPressed: onPressed,
          ),
        ),
      )
    ]);
  }

  void _login(BuildContext context, AddDeviceBlocState state, Function doneFn) async {
    if (state.loggedIn) {
      doneFn();
      return;
    }
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AddDevicePage.addDevicePagePleaseLoginDialogTitle),
            content: Text(AddDevicePage.addDevicePagePleaseLoginDialogBody),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(AddDevicePage.addDevicePagePleaseLoginDialogSkip),
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
          doneFn();
        }
      }));
    } else {
      doneFn();
    }
  }
}
