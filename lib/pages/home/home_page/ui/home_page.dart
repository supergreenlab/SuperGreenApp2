import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/device/storage/devices.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/home/home_control_page/bloc/home_control_page.dart';
import 'package:super_green_app/pages/home/home_control_page/ui/home_control_page.dart';
import 'package:super_green_app/pages/home/home_monitoring_page/bloc/home_monitoring_bloc.dart';
import 'package:super_green_app/pages/home/home_monitoring_page/ui/home_monitoring_page.dart';
import 'package:super_green_app/pages/home/home_page/bloc/home_bloc.dart';
import 'package:super_green_app/pages/home/home_page/bloc/home_navigator_bloc.dart';
import 'package:super_green_app/pages/home/home_social_page/bloc/home_social_bloc.dart';
import 'package:super_green_app/pages/home/home_social_page/ui/home_social_page.dart';
import 'package:super_green_app/pages/home/no_device/ui/no_device_page.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeNavigatorBloc>(
        create: (context) => HomeNavigatorBloc(_navigatorKey),
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

  Widget _deviceList(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeBlocState>(
      bloc: Provider.of<HomeBloc>(context),
      condition: (previousState, state) =>
          state is HomeBlocStateLoadingDeviceList ||
          state is HomeBlocStateDeviceListUpdated,
      builder: (BuildContext context, HomeBlocState state) {
        List<Device> devices = List();
        if (state is HomeBlocStateDeviceListUpdated) {
          devices = state.devices;
        }
        return ListView(
          children: devices
              .map((d) => ListTile(
                  onTap: () => _selectDevice(context, d),
                  title: Text('${d.name}'),
                  subtitle: Text('online'),))
              .toList(),
        );
      },
    );
  }

  void _selectDevice(BuildContext context, Device device) {
    //ignore: close_sinks
    HomeNavigatorBloc navigatorBloc = BlocProvider.of<HomeNavigatorBloc>(context);
    Navigator.pop(context);
    Timer(Duration(milliseconds: 250), () => navigatorBloc.add(HomeNavigateToMonitoringEvent(device)));
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
          child: _deviceList(context),
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
                  create: (context) => HomeMonitoringBloc(settings.arguments),
                  child: HomeMonitoringPage(),
                ));
      case '/control':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => HomeControlBloc(settings.arguments),
                  child: HomeControlPage(),
                ));
      case '/social':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => HomeSocialBloc(settings.arguments),
                  child: HomeSocialPage(),
                ));
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => NoDevicePage(),
            settings: settings);
    }
  }
}
