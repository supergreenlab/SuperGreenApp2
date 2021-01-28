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
import 'package:super_green_app/deep_link/deep_link.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/notifications/local_notification.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/notifications/remote_notification.dart';
import 'package:super_green_app/pages/app_init/app_init_bloc.dart';
import 'package:super_green_app/pages/app_init/welcome_page.dart';
import 'package:super_green_app/syncer/syncer_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class AppInitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppInitBloc, AppInitBlocState>(
      cubit: BlocProvider.of<AppInitBloc>(context),
      listener: (BuildContext context, AppInitBlocState state) {
        if (state is AppInitBlocStateReady) {
          BlocProvider.of<LocalNotificationBloc>(context)
              .add(LocalNotificationBlocEventInit());
          BlocProvider.of<RemoteNotificationBloc>(context)
              .add(RemoteNotificationBlocEventInit());
          BlocProvider.of<DeviceDaemonBloc>(
              context); // force-instanciate DeviceDaemonBloc
          BlocProvider.of<SyncerBloc>(context); // force-instanciate SyncerBloc
          BlocProvider.of<DeepLinkBloc>(
              context); // force-instanciate DeepLinkBloc
          if (state.firstStart == false) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToHomeEvent());
          } else {
            BlocProvider.of<TowelieBloc>(context)
                .add(TowelieBlocEventAppInit());
          }
        }
      },
      child: BlocBuilder<AppInitBloc, AppInitBlocState>(
        cubit: BlocProvider.of<AppInitBloc>(context),
        builder: (BuildContext context, AppInitBlocState state) {
          if (state is AppInitBlocStateReady) {
            return WelcomePage(!state.firstStart);
          }
          return WelcomePage(true);
        },
      ),
    );
  }
}
