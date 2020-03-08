import 'package:flutter/material.dart';
import 'package:flutter_matomo/flutter_matomo.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';

class AnalyticsObserver extends RouteObserver<PageRoute> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    this.trackNewRoute(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    this.trackNewRoute(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void trackNewRoute(Route<dynamic> route) async {
    if (route.settings.name == '/') {
      return;
    }
    AppDB _db = AppDB();
    AppData appData = _db.getAppData();

    if (appData.allowAnalytics) {
      await FlutterMatomo.trackScreenWithName(route.settings.name, "Route view");
    }
  }
}
