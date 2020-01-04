import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/add_box/bloc/add_box_bloc.dart';
import 'package:super_green_app/pages/add_box/ui/add_box_page.dart';
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
import 'package:super_green_app/pages/home/ui/home_page.dart';

Map<int, Color> primaryColor = {
  50: Color.fromRGBO(69, 69, 69, .1),
  100: Color.fromRGBO(69, 69, 69, .2),
  200: Color.fromRGBO(69, 69, 69, .3),
  300: Color.fromRGBO(69, 69, 69, .4),
  400: Color.fromRGBO(69, 69, 69, .5),
  500: Color.fromRGBO(69, 69, 69, .6),
  600: Color.fromRGBO(69, 69, 69, .7),
  700: Color.fromRGBO(69, 69, 69, .8),
  800: Color.fromRGBO(69, 69, 69, .9),
  900: Color.fromRGBO(69, 69, 69, 1),
};

Map<int, Color> secondaryColor = {
  50: Color.fromRGBO(59, 179, 11, .1),
  100: Color.fromRGBO(59, 179, 11, .2),
  200: Color.fromRGBO(59, 179, 11, .3),
  300: Color.fromRGBO(59, 179, 11, .4),
  400: Color.fromRGBO(59, 179, 11, .5),
  500: Color.fromRGBO(59, 179, 11, .6),
  600: Color.fromRGBO(59, 179, 11, .7),
  700: Color.fromRGBO(59, 179, 11, .8),
  800: Color.fromRGBO(59, 179, 11, .9),
  900: Color.fromRGBO(59, 179, 11, 1),
};

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
          primaryColor: Color(0XFF212845),
          scaffoldBackgroundColor: Color(0XFFEFEFEF),
          primarySwatch: MaterialColor(0xFF454545, primaryColor),
          buttonColor: Color(0xff3bb30b),
          accentColor: Colors.green,
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(),
            textTheme: ButtonTextTheme.accent,
          )),
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
            builder: (context) => BlocProvider(
                  create: (context) => HomeBloc(),
                  child: HomePage(),
                ));
      case '/box/new':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => NewBoxBloc(),
                  child: NewBoxPage(),
                ));
      case '/device/new':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => NewDeviceBloc(),
                  child: NewDevicePage(),
                ));
      case '/device/add':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ExistingDeviceBloc(),
                  child: ExistingDevicePage(),
                ));
      case '/device/load':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => DeviceSetupBloc(settings.arguments),
                  child: DeviceSetupPage(),
                ));
      case '/device/name':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => DeviceNameBloc(settings.arguments),
                  child: DeviceNamePage(),
                ));
      case '/device/done':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => DeviceDoneBloc(settings.arguments),
                  child: DeviceDonePage(),
                ));
    }
    return MaterialPageRoute(builder: (context) => Text('Unknown route'));
  }
}