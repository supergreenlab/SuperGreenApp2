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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/devices/refresh_parameters/refresh_parameters_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class RefreshParametersPage extends StatefulWidget {
  static String get refreshParametersPageLoading {
    return Intl.message(
      'Refreshing..',
      name: 'refreshParametersPageLoading',
      desc: 'Loading screen while refreshing parameters',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String refreshParametersPageControllerRefreshed(String name) {
    return Intl.message(
      'Controller $name refreshed!',
      args: [name],
      name: 'refreshParametersPageControllerRefreshed',
      desc: 'Controller params refreshed confirmation text',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  _RefreshParametersPageState createState() => _RefreshParametersPageState();
}

class _RefreshParametersPageState extends State<RefreshParametersPage> {

  @protected
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<RefreshParametersBloc>(context),
      listener: (BuildContext context, RefreshParametersBlocState state) async {
        if (state is RefreshParametersBlocStateRefreshed) {
          Timer(const Duration(milliseconds: 2000), () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(mustPop: true));
          });
        }
      },
      child: BlocBuilder<RefreshParametersBloc, RefreshParametersBlocState>(
          bloc: BlocProvider.of<RefreshParametersBloc>(context),
          builder: (BuildContext context, RefreshParametersBlocState state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is RefreshParametersBlocStateLoading) {
              body = FullscreenLoading(
                title: CommonL10N.loading,
              );
            } else if (state is RefreshParametersBlocStateLoading) {
              body = Fullscreen(
                title: 'Error..',
                child: Icon(Icons.error),
              );
            } else if (state is RefreshParametersBlocStateRefreshing) {
              body = FullscreenLoading(
                percent: state.percent,
                title: RefreshParametersPage.refreshParametersPageLoading,
              );
            } else if (state is RefreshParametersBlocStateRefreshed) {
              body = _renderRefreshDone(state);
            }
            return WillPopScope(
              onWillPop: () async {
                return state is RefreshParametersBlocStateRefreshed || state is RefreshParametersBlocStateError;
              },
              child: Scaffold(
                  appBar: SGLAppBar(
                    '🤖',
                    fontSize: 40,
                    backgroundColor: Color(0xff0b6ab3),
                    titleColor: Colors.white,
                    iconColor: Colors.white,
                    hideBackButton: state is RefreshParametersBlocStateDone,
                  ),
                  backgroundColor: Colors.white,
                  body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body)),
            );
          }),
    );
  }

  Widget _renderRefreshDone(RefreshParametersBlocStateRefreshed state) {
    String subtitle = RefreshParametersPage.refreshParametersPageControllerRefreshed(state.device.name);
    return Fullscreen(
        title: CommonL10N.done, subtitle: subtitle, child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
