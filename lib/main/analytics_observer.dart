// /*
//  * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
//  * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
//  *
//  * This program is free software: you can redistribute it and/or modify
//  * it under the terms of the GNU General Public License as published by
//  * the Free Software Foundation, either version 3 of the License, or
//  * (at your option) any later version.
//  *
//  * This program is distributed in the hope that it will be useful,
//  * but WITHOUT ANY WARRANTY; without even the implied warranty of
//  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  * GNU General Public License for more details.
//  *
//  * You should have received a copy of the GNU General Public License
//  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
//  */

// import 'package:flutter/material.dart';
// import 'package:flutter_matomo/flutter_matomo.dart';
// import 'package:super_green_app/data/kv/app_db.dart';
// import 'package:super_green_app/data/kv/models/app_data.dart';

// class AnalyticsObserver extends RouteObserver<PageRoute> {
//   @override
//   void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
//     this.trackNewRoute(route);
//     super.didPush(route, previousRoute);
//   }

//   @override
//   void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
//     this.trackNewRoute(newRoute);
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//   }

//   void trackNewRoute(Route<dynamic> route) async {
//     if (route.settings.name != null && route.settings.name == '/') {
//       return;
//     }
//     AppDB _db = AppDB();
//     AppData appData = _db.getAppData();

//     if (appData.allowAnalytics == true) {
//       await FlutterMatomo.trackScreenWithName(route.settings.name, "Route view");
//     }
//   }
// }
