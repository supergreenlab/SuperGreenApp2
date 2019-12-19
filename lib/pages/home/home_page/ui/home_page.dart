import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/home/home_control_page/bloc/home_control_page.dart';
import 'package:super_green_app/pages/home/home_control_page/ui/home_control_page.dart';
import 'package:super_green_app/pages/home/home_monitoring_page/bloc/home_monitoring_bloc.dart';
import 'package:super_green_app/pages/home/home_monitoring_page/ui/home_monitoring_page.dart';
import 'package:super_green_app/pages/home/home_page/bloc/home_navigator_bloc.dart';
import 'package:super_green_app/pages/home/home_social_page/bloc/home_social_bloc.dart';
import 'package:super_green_app/pages/home/home_social_page/ui/home_social_page.dart';
import 'package:super_green_app/pages/home/no_device/ui/no_device_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
          drawer: Drawer(child: this._drawerContent(context)),
          body: Navigator(
            key: _navigatorKey,
            onGenerateRoute: (settings) =>
                this._onGenerateRoute(context, settings),
          ),
        ));
  }

  Widget _drawerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DrawerHeader(
            child: Column(children: <Widget>[
          Expanded(
            child: SizedBox(
              width: 100,
              height: 100,
              child: SvgPicture.asset("assets/super_green_lab_vertical.svg"),
            ),
          ),
        ])),
        Expanded(
          child: ListView(
            children: <Widget>[],
          ),
        ),
        Divider(),
        Container(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.add_circle),
                        title: Text('Add new device'),
                        onTap: () => _onAddDevice(context)),
                    ListTile(
                        leading: Icon(Icons.add_to_queue),
                        title: Text('Add existing device'),
                        onTap: () => _onAddExistingDevice(context)),
                    ListTile(
                        leading: Icon(Icons.add_shopping_cart),
                        title: Text('Shop new'),
                        onTap: () => _onShopNew(context)),
                    ListTile(
                        leading: Icon(Icons.settings), title: Text('Settings')),
                  ],
                ))))
      ],
    );
  }

  void _onAddExistingDevice(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToExistingDeviceEvent());
  }

  void _onAddDevice(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToNewDeviceEvent());
  }

  void _onShopNew(BuildContext context) {
    launch('https://www.supergreenlab.com');
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    if (settings.arguments == null) {
      return MaterialPageRoute(
          builder: (BuildContext context) => NoDevicePage(),
          settings: settings);
    }
    switch (settings.name) {
      case '/monitoring':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => HomeMonitoringBloc(),
                  child: HomeMonitoringPage(),
                ));
      case '/control':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => HomeControlBloc(),
                  child: HomeControlPage(),
                ));
      case '/social':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => HomeSocialBloc(),
                  child: HomeSocialPage(),
                ));
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => NoDevicePage(),
            settings: settings);
    }
  }
}
