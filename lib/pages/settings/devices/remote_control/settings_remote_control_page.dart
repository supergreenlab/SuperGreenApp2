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
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/pages/settings/devices/remote_control/settings_remote_control_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class SettingsRemoteControlPage extends StatelessWidget {
  static String settingsRemoteControlPageControllerDone(String name) {
    return Intl.message(
      'Controller $name setup!',
      args: [name],
      name: 'settingsRemoteControlPageControllerDone',
      desc: 'Controller remote control setup confirmation text',
      locale: SGLLocalizations.current.localeName,
    );
  }

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
            } else if (state is SettingsRemoteControlBlocStateDone) {
              body = _renderDone(state);
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
                  hideBackButton: state is SettingsRemoteControlBlocStateDone,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderDone(SettingsRemoteControlBlocStateDone state) {
    String subtitle = SettingsRemoteControlPage.settingsRemoteControlPageControllerDone(state.device.name);
    return Fullscreen(
        title: CommonL10N.done, subtitle: subtitle, child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm(BuildContext context, SettingsRemoteControlBlocStateLoaded state) {
    return Column(children: <Widget>[]);
  }
}
