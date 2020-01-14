import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/add_box/box_infos/bloc/box_infos_bloc.dart';
import 'package:super_green_app/pages/add_box/box_infos/ui/box_infos_page.dart';
import 'package:super_green_app/pages/add_box/select_device/bloc/select_device_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device/ui/select_device_page.dart';
import 'package:super_green_app/pages/add_device/device_done/bloc/device_done_bloc.dart';
import 'package:super_green_app/pages/add_device/device_done/ui/device_done_page.dart';
import 'package:super_green_app/pages/add_device/device_name/bloc/device_name_bloc.dart';
import 'package:super_green_app/pages/add_device/device_name/ui/device_name_page.dart';
import 'package:super_green_app/pages/add_device/device_setup/bloc/device_setup_bloc.dart';
import 'package:super_green_app/pages/add_device/device_setup/ui/device_setup_page.dart';
import 'package:super_green_app/pages/add_device/existing_device/bloc/existing_device_bloc.dart';
import 'package:super_green_app/pages/add_device/existing_device/ui/existing_device_page.dart';
import 'package:super_green_app/pages/add_device/new_device/bloc/new_device_bloc.dart';
import 'package:super_green_app/pages/add_device/new_device/ui/new_device_page.dart';
import 'package:super_green_app/pages/app_init/bloc/app_init_bloc.dart';
import 'package:super_green_app/pages/app_init/ui/app_init_page.dart';
import 'package:super_green_app/pages/home/bloc/home_bloc.dart';
import 'package:super_green_app/pages/home/bloc/home_navigator_bloc.dart';
import 'package:super_green_app/pages/home/ui/home_page.dart';

final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey();

class MainPage extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  MainPage(this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'SuperGreenLab',
      onGenerateRoute: (settings) => this._onGenerateRoute(context, settings),
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: BlocProvider<AppInitBloc>(
        create: (context) => AppInitBloc(),
        child: AppInitPage(),
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeNavigatorBloc>(
                        create: (context) =>
                            HomeNavigatorBloc(_homeNavigatorKey)),
                    BlocProvider<HomeBloc>(
                      create: (context) => HomeBloc(),
                    )
                  ],
                  child: _wrapBg(context, HomePage(_homeNavigatorKey)),
                ));
      case '/box/new':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => BoxInfosBloc(),
                  child: _wrapBg(context, BoxInfosPage()),
                ));
      case '/box/device':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SelectDeviceBloc(settings.arguments),
                  child: _wrapBg(context, SelectDevicePage()),
                ));
      case '/device/new':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => NewDeviceBloc(settings.arguments),
                  child: _wrapBg(context, NewDevicePage()),
                ));
      case '/device/add':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ExistingDeviceBloc(settings.arguments),
                  child: _wrapBg(context, ExistingDevicePage()),
                ));
      case '/device/load':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => DeviceSetupBloc(settings.arguments),
                  child: _wrapBg(context, DeviceSetupPage()),
                ));
      case '/device/name':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => DeviceNameBloc(settings.arguments),
                  child: _wrapBg(context, DeviceNamePage()),
                ));
      case '/device/done':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => DeviceDoneBloc(settings.arguments),
                  child: _wrapBg(context, DeviceDonePage()),
                ));
    }
    return MaterialPageRoute(builder: (context) => Text('Unknown route'));
  }

  Widget _wrapBg(BuildContext context, Widget w) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xFF103A3A), Color(0xFF022C22), Color(0xFF298D9B)],
        begin: Alignment(-0.25, 1),
        end: Alignment(0.25, -1),
      )),
      child: w,
    );
  }
}
