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
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/settings_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsBlocState>(
        bloc: BlocProvider.of<SettingsBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: SGLAppBar(
              'Settings',
              backgroundColor: Colors.deepOrange,
              titleColor: Colors.white,
              iconColor: Colors.white,
              elevation: 10,
            ),
            body: ListView(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    BlocProvider.of<SettingsBloc>(context).add(
                        SettingsBlocEventSetFreedomUnit(!state.freedomUnits));
                  },
                  leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: SvgPicture.asset(state.freedomUnits
                          ? 'assets/settings/icon_imperial.svg'
                          : 'assets/settings/icon_metric.svg')),
                  title: Text(
                      state.freedomUnits
                          ? 'Imperial unit system'
                          : 'Metric unit system',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Tap to change to ${state.freedomUnits ? 'metric' : 'imperial'}'),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToSettingsAuth());
                  },
                  leading: SizedBox(
                      width: 40,
                      height: 40,
                      child:
                          SvgPicture.asset('assets/settings/icon_account.svg')),
                  title: Text('SGL Account',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle:
                      Text('Enable backups, remote control, sharing, etc..'),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToSettingsPlants());
                  },
                  leading: SizedBox(
                      width: 40,
                      height: 40,
                      child:
                          SvgPicture.asset('assets/settings/icon_plants.svg')),
                  title: Text('Plants',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Move to new box & delete plants.'),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToSettingsBoxes());
                  },
                  leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: SvgPicture.asset('assets/settings/icon_lab.svg')),
                  title: Text('Labs',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Change controller & delete labs.'),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToSettingsDevices());
                  },
                  leading: SizedBox(
                      width: 40,
                      height: 40,
                      child: SvgPicture.asset('assets/settings/icon_controller.svg')),
                  title: Text('Controllers',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Delete controllers.'),
                )
              ],
            )));
  }
}
