import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/bloc/box_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/ui/box_feed_page.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/bloc/sgl_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/ui/sgl_feed_page.dart';
import 'package:super_green_app/pages/home/bloc/home_bloc.dart';
import 'package:super_green_app/pages/home/bloc/home_navigator_bloc.dart';
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
          state is HomeBlocStateLoadingBoxList ||
          state is HomeBlocStateBoxListUpdated,
      builder: (BuildContext context, HomeBlocState state) {
        List<Box> boxes = List();
        if (state is HomeBlocStateBoxListUpdated) {
          boxes = state.boxes;
        }
        return ListView(
          children: boxes
              .map((b) => ListTile(
                    onTap: () => _selectBox(context, b),
                    title: Text('${b.name}'),
                    subtitle: Text('online'),
                  ))
              .toList(),
        );
      },
    );
  }

  void _selectBox(BuildContext context, Box box) {
    //ignore: close_sinks
    // HomeNavigatorBloc navigatorBloc =
    //     BlocProvider.of<HomeNavigatorBloc>(context);
    Navigator.pop(context);
    // Timer(Duration(milliseconds: 250),
    //     () => navigatorBloc.add(HomeNavigateToBoxFeedEvent(device)));
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
                        title: Text('Add new box'),
                        onTap: () => _onAddBox(context)),
                    ListTile(
                        leading: Icon(Icons.settings), title: Text('Settings')),
                  ],
                ))))
      ],
    );
  }

  void _onAddBox(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToNewBoxEvent());
  }

  void _onShopNew(BuildContext context) {
    launch('https://www.supergreenlab.com');
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    if (!settings.arguments) {
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SGLFeedBloc(settings.arguments),
                child: SGLFeedPage(),
              ));
    }
    switch (settings.name) {
      case '/feed/box':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => BoxFeedBloc(settings.arguments),
                  child: BoxFeedPage(),
                ));
      default:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(settings.arguments),
                  child: SGLFeedPage(),
                ));
    }
  }
}
