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
import 'package:provider/provider.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_setup/device_setup_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/section_title.dart';

class DeviceSetupPage extends TraceableStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<DeviceSetupBloc>(context),
      listener: (BuildContext context, DeviceSetupBlocState state) async {
        if (state is DeviceSetupBlocStateDone) {
          Device device = state.device;
          if (state.requiresInititalSetup) {
            FutureFn ff1 = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToDeviceNameEvent(device, futureFn: ff1.futureFn));
            device = await ff1.future;
          }
          if (state.requiresWifiSetup) {
            FutureFn ff2 = BlocProvider.of<MainNavigatorBloc>(context).futureFn();
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToDeviceWifiEvent(device, futureFn: ff2.futureFn));
            device = await ff2.future;
          }
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: device, mustPop: true));
        }
      },
      child: BlocBuilder<DeviceSetupBloc, DeviceSetupBlocState>(
          cubit: Provider.of<DeviceSetupBloc>(context),
          builder: (context, state) {
            bool canGoBack = state is DeviceSetupBlocStateAlreadyExists || state is DeviceSetupBlocStateLoadingError;
            Widget body;
            if (state is DeviceSetupBlocStateAlreadyExists) {
              body = _renderAlreadyAdded(context);
            } else if (state is DeviceSetupBlocStateLoadingError) {
              body = _renderLoadingError(context);
            } else {
              body = _renderLoading(context, state);
            }
            return WillPopScope(
              onWillPop: () async => canGoBack,
              child: Scaffold(
                appBar: SGLAppBar(
                  'Add controller',
                  hideBackButton: !canGoBack,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body),
              ),
            );
          }),
    );
  }

  Widget _renderLoadingError(BuildContext context) {
    return Fullscreen(
        title: 'Oops looks like the controller is unreachable!',
        child: Icon(Icons.warning, color: Color(0xff3bb30b), size: 100));
  }

  Widget _renderAlreadyAdded(BuildContext context) {
    return Fullscreen(
        title: 'This controller is already added!', child: Icon(Icons.warning, color: Color(0xff3bb30b), size: 100));
  }

  Widget _renderLoading(BuildContext context, DeviceSetupBlocState state) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 50,
          color: Color(0xff0b6ab3),
        ),
        SectionTitle(
          title: 'Loading controller params',
          icon: 'assets/box_setup/icon_controller.svg',
          backgroundColor: Color(0xff0b6ab3),
          titleColor: Colors.white,
          large: true,
          elevation: 5,
        ),
        Expanded(child: FullscreenLoading(title: 'Loading please wait..', percent: state.percent)),
      ],
    );
  }
}
