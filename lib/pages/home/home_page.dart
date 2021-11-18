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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/device_daemon/device_reachable_listener_bloc.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/pages/explorer/explorer_bloc.dart';
import 'package:super_green_app/pages/explorer/explorer_page.dart';
import 'package:super_green_app/pages/explorer/search/search_bloc.dart';
import 'package:super_green_app/pages/feeds/home/box_feeds/local/local_box_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/home/box_feeds/local/local_box_feed_page.dart';
import 'package:super_green_app/pages/feeds/home/common/drawer/plant_drawer_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/plant_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/plant_feed_page.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_page.dart';
import 'package:super_green_app/pages/home/home_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/settings_bloc.dart';
import 'package:super_green_app/pages/settings/settings_page.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_helper.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class HomePage extends TraceableStatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  HomePage(this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    return BlocListener<TowelieBloc, TowelieBlocState>(
      listener: (BuildContext context, state) {
        if (state is TowelieBlocStateHomeNavigation) {
          BlocProvider.of<HomeNavigatorBloc>(context).add(state.homeNavigatorEvent);
        }
      },
      child: BlocBuilder<HomeNavigatorBloc, HomeNavigatorState>(
        builder: (context, navigatorState) => BlocBuilder<HomeBloc, HomeBlocState>(builder: (context, state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );
          Widget? navbar;
          if (state is HomeBlocStateInit) {
            body = FullscreenLoading(
              title: CommonL10N.loading,
            );
          } else if (state is HomeBlocStateLoaded) {
            body = Navigator(
              //observers: [_analyticsObserver],
              initialRoute: navigatorState.index == 0 ? '/' : '/feed/plant',
              onGenerateInitialRoutes: (NavigatorState navigator, String initialRoute) {
                if (initialRoute == '/feed/plant') {
                  return [
                    _onGenerateRoute(
                        context, RouteSettings(name: initialRoute, arguments: HomeNavigateToPlantFeedEvent(null)))
                  ];
                }
                return [
                  _onGenerateRoute(context, RouteSettings(name: initialRoute)),
                ];
              },
              key: _navigatorKey,
              onGenerateRoute: (settings) => this._onGenerateRoute(context, settings),
            );

            Widget sglIcon = Icon(Icons.feedback);
            try {
              int nSgl = 0;
              try {
                nSgl = state.hasPending.where((e) => e.id == 1).map<int>((e) => e.nNew).reduce((a, e) => a + e);
              } catch (e) {}
              if (nSgl > 0) {
                sglIcon = Stack(
                  children: [
                    sglIcon,
                    _renderBadge(nSgl),
                  ],
                );
              }
            } catch (e, trace) {
              Logger.logError(e, trace);
            }
            Widget homeIcon = Icon(Icons.event_note);
            try {
              int nOthers = 0;
              try {
                nOthers = state.hasPending.where((e) => e.id != 1).map<int>((e) => e.nNew).reduce((a, e) => a + e);
              } catch (e) {}
              if (nOthers > 0) {
                homeIcon = Stack(
                  children: [
                    homeIcon,
                    _renderBadge(nOthers),
                  ],
                );
              }
            } catch (e, trace) {
              Logger.logError(e, trace);
            }
            navbar = BottomNavigationBar(
              unselectedItemColor: Colors.black38,
              selectedItemColor: Colors.green,
              onTap: (i) => this._onNavigationBarItemSelect(context, i, navigatorState),
              elevation: 10,
              currentIndex: navigatorState.index,
              items: [
                BottomNavigationBarItem(
                  icon: sglIcon,
                  label: 'Towelie',
                ),
                BottomNavigationBarItem(
                  icon: homeIcon,
                  label: 'Lab',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            );
          }

          return Scaffold(
            bottomNavigationBar: navbar,
            body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body),
          );
        }),
      ),
    );
  }

  Widget _renderBadge(int n) {
    return Positioned(
      right: 0,
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(7),
        ),
        constraints: BoxConstraints(
          minWidth: 14,
          minHeight: 14,
        ),
        child: Text(
          '$n',
          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _onNavigationBarItemSelect(BuildContext context, int i, HomeNavigatorState state) {
    if (i == state.index) return;
    if (i == 0) {
      BlocProvider.of<HomeNavigatorBloc>(context).add(HomeNavigateToSGLFeedEvent());
    } else if (i == 1) {
      BlocProvider.of<HomeNavigatorBloc>(context).add(HomeNavigateToPlantFeedEvent(null));
    } else if (i == 2) {
      BlocProvider.of<HomeNavigatorBloc>(context).add(HomeNavigateToExplorerEvent());
    } else if (i == 3) {
      BlocProvider.of<HomeNavigatorBloc>(context).add(HomeNavigateToSettingsEvent());
    }
  }

  Route<dynamic> _onGenerateRoute(BuildContext context, RouteSettings settings) {
    Timer(Duration(milliseconds: 100), () {
      BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventRoute(settings));
    });
    switch (settings.name) {
      case '/feed/sgl':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(),
                  child: TowelieHelper.wrapWidget(settings, context, SGLFeedPage()),
                ));
      case '/feed/plant':
        return _plantFeedRoute(context, settings, settings.arguments as HomeNavigateToPlantFeedEvent, providers: [
          BlocProvider<DeviceReachableListenerBloc>(
            create: (context) => DeviceReachableListenerBloc(settings.arguments as DeviceNavigationArgHolder),
          )
        ]);
      case '/feed/box':
        return _boxFeedRoute(context, settings, settings.arguments as HomeNavigateToBoxFeedEvent, providers: [
          BlocProvider<DeviceReachableListenerBloc>(
            create: (context) => DeviceReachableListenerBloc(settings.arguments as DeviceNavigationArgHolder),
          )
        ]);
      case '/explorer':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => ExplorerBloc()),
                    BlocProvider(create: (context) => SearchBloc()),
                  ],
                  child: TowelieHelper.wrapWidget(settings, context, ExplorerPage()),
                ));
      case '/settings':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider(
                  create: (context) => SettingsBloc(),
                  child: TowelieHelper.wrapWidget(settings, context, SettingsPage()),
                ));
      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(),
                  child: SGLFeedPage(),
                ));
    }
  }

  MaterialPageRoute _plantFeedRoute(BuildContext context, RouteSettings settings, HomeNavigateToPlantFeedEvent event,
      {required List<BlocProvider> providers}) {
    return MaterialPageRoute(
        settings: settings,
        builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<PlantDrawerBloc>(create: (context) => PlantDrawerBloc()),
                BlocProvider<PlantFeedBloc>(create: (context) => PlantFeedBloc(event)),
                ...providers,
              ],
              child: TowelieHelper.wrapWidget(settings, context, PlantFeedPage()),
            ));
  }

  MaterialPageRoute _boxFeedRoute(BuildContext context, RouteSettings settings, HomeNavigateToBoxFeedEvent event,
      {required List<BlocProvider> providers}) {
    return MaterialPageRoute(
        settings: settings,
        builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<PlantDrawerBloc>(create: (context) => PlantDrawerBloc()),
                BlocProvider<LocalBoxFeedBloc>(create: (context) => LocalBoxFeedBloc(event)),
                ...providers,
              ],
              child: TowelieHelper.wrapWidget(settings, context, LocalBoxFeedPage()),
            ));
  }
}
