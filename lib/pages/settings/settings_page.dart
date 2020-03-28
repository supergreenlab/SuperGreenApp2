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
                  subtitle: Text('Enable backups and sharing'),
                )
              ],
            )));
  }
}
