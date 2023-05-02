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
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/motor_ports/motor_ports_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class MotorPortPage extends TraceableStatefulWidget {
  @override
  _MotorPortPageState createState() => _MotorPortPageState();
}

class _MotorPortPageState extends State<MotorPortPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MotorPortBloc, MotorPortBlocState>(
      listener: (BuildContext context, state) {
        if (state is MotorPortBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
      child: BlocBuilder<MotorPortBloc, MotorPortBlocState>(
          bloc: BlocProvider.of<MotorPortBloc>(context),
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is MotorPortBlocStateLoaded) {
              body = _renderLoaded(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  '🤖',
                  fontSize: 40,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                body: body);
          }),
    );
  }

  Widget _renderLoaded(BuildContext context, MotorPortBlocStateLoaded state) {
    if (state.device.config == null) {
      return Column(
        children: [
          Text('Looks like you just upgraded the app, you need to refresh you controller\' parameters:'),
          InkWell(
            child: Text('Refresh parameters'),
            onTap: () {
              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToRefreshParameters(state.device));
            },
          )
        ],
      );
    }
    return Text('Not loaded');
  }
}
