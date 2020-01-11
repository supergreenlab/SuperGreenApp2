import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/bloc/box_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/box_feed/ui/box_feed_page.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/bloc/sgl_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/ui/sgl_feed_page.dart';
import 'package:super_green_app/pages/home/bloc/home_navigator_bloc.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeNavigatorBloc>(
        create: (context) => HomeNavigatorBloc(_navigatorKey),
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) =>
              this._onGenerateRoute(context, settings),
        ));
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    if (settings.arguments == null) {
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => SGLFeedBloc(),
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
      case '/feed/sgl':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(),
                  child: SGLFeedPage(),
                ));
      default:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(),
                  child: SGLFeedPage(),
                ));
    }
  }
}
