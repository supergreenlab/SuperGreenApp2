import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/device/bloc/device_bloc.dart';
import 'package:super_green_app/pages/device/ui/device_page.dart';
import 'package:super_green_app/pages/home_page/bloc/home_navigator_bloc.dart';
import 'package:super_green_app/pages/no_device/ui/NoDevicePage.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeNavigatorBloc>(
        create: (context) => HomeNavigatorBloc(navigatorKey: _navigatorKey),
        child: Scaffold(
          appBar: AppBar(
            title: Text('SuperGreenLab'),
          ),
          body: Navigator(
            key: _navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              if (settings.name.startsWith('/device')) {
                return MaterialPageRoute(
                    builder: (BuildContext context) => BlocProvider(
                          create: (BuildContext context) => DeviceBloc(),
                          child: DevicePage(),
                        ),
                    settings: settings);
              }
              return MaterialPageRoute(
                  builder: (BuildContext context) => NoDevicePage(),
                  settings: settings);
            },
          ),
        ));
  }
}
