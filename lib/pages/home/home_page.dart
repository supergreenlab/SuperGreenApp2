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
import 'package:super_green_app/pages/explorer/explorer_bloc.dart';
import 'package:super_green_app/pages/explorer/explorer_page.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/local/plant_drawer_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/local/plant_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/local/plant_feed_page.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_page.dart';
import 'package:super_green_app/pages/home/home_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/settings_bloc.dart';
import 'package:super_green_app/pages/settings/settings_page.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_helper.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  HomePage(this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    return BlocListener<TowelieBloc, TowelieBlocState>(
      listener: (BuildContext context, state) {
        if (state is TowelieBlocStateHomeNavigation) {
          BlocProvider.of<HomeNavigatorBloc>(context)
              .add(state.homeNavigatorEvent);
        }
      },
      child: BlocBuilder<HomeNavigatorBloc, HomeNavigatorState>(
        builder: (context, navigatorState) =>
            BlocBuilder<HomeBloc, HomeBlocState>(builder: (context, state) {
          Widget body;
          Widget navbar;
          if (state is HomeBlocStateInit) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is HomeBlocStateLoaded) {
            body = Navigator(
              //observers: [_analyticsObserver],
              initialRoute: navigatorState.index == 0 ? "/" : "/feed/plant",
              key: _navigatorKey,
              onGenerateRoute: (settings) =>
                  this._onGenerateRoute(context, settings),
            );

            Widget sglIcon = Icon(Icons.feedback);
            try {
              int nSgl = state.hasPending
                  .where((e) => e.id == 1)
                  .map<int>((e) => int.parse(e.nNew))
                  .reduce((a, e) => a + e);
              if (nSgl != null && nSgl > 0) {
                sglIcon = Stack(
                  children: [
                    sglIcon,
                    _renderBadge(nSgl),
                  ],
                );
              }
            } catch (e) {}
            Widget homeIcon = Icon(Icons.event_note);
            try {
              int nOthers = state.hasPending
                  .where((e) => e.id != 1)
                  .map<int>((e) => int.parse(e.nNew))
                  .reduce((a, e) => a + e);
              if (nOthers != null && nOthers > 0) {
                homeIcon = Stack(
                  children: [
                    homeIcon,
                    _renderBadge(nOthers),
                  ],
                );
              }
            } catch (e) {}
            navbar = BottomNavigationBar(
              unselectedItemColor: Colors.black38,
              selectedItemColor: Colors.green,
              onTap: (i) =>
                  this._onNavigationBarItemSelect(context, i, navigatorState),
              elevation: 10,
              currentIndex: navigatorState.index,
              items: [
                BottomNavigationBarItem(
                  icon: sglIcon,
                  title: Text('Towelie'),
                ),
                BottomNavigationBarItem(
                  icon: homeIcon,
                  title: Text('Lab'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  title: Text('Explore'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ],
            );
          }

          return Scaffold(
            bottomNavigationBar: navbar,
            body: AnimatedSwitcher(
                duration: Duration(milliseconds: 200), child: body),
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
          style: TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _onNavigationBarItemSelect(
      BuildContext context, int i, HomeNavigatorState state) {
    if (i == state.index) return;
    if (i == 0) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToSGLFeedEvent());
    } else if (i == 1) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToPlantFeedEvent(null));
    } else if (i == 2) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToExplorerEvent());
    } else if (i == 3) {
      BlocProvider.of<HomeNavigatorBloc>(context)
          .add(HomeNavigateToSettingsEvent());
    }
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    Timer(Duration(milliseconds: 100), () {
      BlocProvider.of<TowelieBloc>(context)
          .add(TowelieBlocEventRoute(settings));
    });
    switch (settings.name) {
      case '/feed/sgl':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider(
                  create: (context) => SGLFeedBloc(),
                  child: TowelieHelper.wrapWidget(
                      settings, context, SGLFeedPage()),
                ));
      case '/feed/plant':
        return _plantFeedRoute(context, settings, settings.arguments);
      case '/explorer':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider(
                  create: (context) => ExplorerBloc(),
                  child: TowelieHelper.wrapWidget(
                      settings, context, ExplorerPage()),
                ));
      case '/settings':
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider(
                  create: (context) => SettingsBloc(),
                  child: TowelieHelper.wrapWidget(
                      settings, context, SettingsPage()),
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

  MaterialPageRoute _plantFeedRoute(BuildContext context,
      RouteSettings settings, HomeNavigateToPlantFeedEvent event) {
    return MaterialPageRoute(
        settings: settings,
        builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<PlantDrawerBloc>(
                    create: (context) => PlantDrawerBloc()),
                BlocProvider<PlantFeedBloc>(
                    create: (context) => PlantFeedBloc(event)),
              ],
              child:
                  TowelieHelper.wrapWidget(settings, context, PlantFeedPage()),
            ));
  }
}
