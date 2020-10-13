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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/box_app_bar_metrics_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/box_app_bar_metrics_page.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EnvironmentsPage extends StatelessWidget {
  final Box box;
  final Function(Future<dynamic>) futureFn;

  const EnvironmentsPage(this.box, {Key key, this.futureFn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget graphBody;
    if (box.device != null) {
      graphBody = _renderGraphs(context);
    } else {
      graphBody = Stack(children: [
        _renderGraphs(context),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white.withAlpha(190)),
          child: Fullscreen(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            title: 'Monitoring feature\nrequires an SGL controller',
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GreenButton(
                      title: 'SHOP NOW',
                      onPressed: () {
                        launch('https://www.supergreenlab.com');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('or',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    GreenButton(
                      title: 'DIY NOW',
                      onPressed: () {
                        launch('https://github.com/supergreenlab');
                      },
                    ),
                  ],
                ),
                Text('already got one?'),
                GreenButton(
                  title: 'SETUP CONTROLLER',
                  onPressed: () {
                    BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToSettingsBox(box));
                  },
                ),
              ],
            ),
            childFirst: false,
          ),
        ),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200), child: graphBody),
          ),
        ),
        Container(height: 115, child: _renderEnvironmentControls(context)),
      ],
    );
  }

  Widget _renderEnvironmentControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4, bottom: 8),
          child: Text('Environment control',
              style: TextStyle(color: Colors.white)),
        ),
        Row(
          children: <Widget>[
            _renderEnvironmentControl(
                context,
                'Light',
                'assets/feed_card/icon_dimming.svg',
                _onEnvironmentControlTapped(
                    context,
                    ({pushAsReplacement = false}) =>
                        MainNavigateToFeedLightFormEvent(box,
                            pushAsReplacement: pushAsReplacement,
                            futureFn: futureFn),
                    tipID: 'TIP_STRETCH',
                    tipPaths: [
                      't/supergreenlab/SuperGreenTips/master/s/when_to_control_stretch_in_seedling/l/en',
                      't/supergreenlab/SuperGreenTips/master/s/how_to_control_stretch_in_seedling/l/en'
                    ])),
            _renderEnvironmentControl(
                context,
                'Ventil',
                'assets/feed_card/icon_blower.svg',
                _onEnvironmentControlTapped(
                    context,
                    ({pushAsReplacement = false}) =>
                        MainNavigateToFeedVentilationFormEvent(box,
                            pushAsReplacement: pushAsReplacement,
                            futureFn: futureFn))),
            _renderEnvironmentControl(
                context,
                'Schedule',
                'assets/feed_card/icon_schedule.svg',
                _onEnvironmentControlTapped(
                    context,
                    ({pushAsReplacement = false}) =>
                        MainNavigateToFeedScheduleFormEvent(box,
                            pushAsReplacement: pushAsReplacement,
                            futureFn: futureFn),
                    tipID: 'TIP_BLOOM',
                    tipPaths: [
                      't/supergreenlab/SuperGreenTips/master/s/when_to_switch_to_bloom/l/en'
                    ])),
          ],
        ),
      ],
    );
  }

  Widget _renderEnvironmentControl(BuildContext context, String name,
      String icon, void Function() navigateTo) {
    return InkWell(
      onTap: navigateTo,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 3.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: SvgPicture.asset(icon,
                    width: 40, height: 40, fit: BoxFit.contain)),
          ),
          Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void Function() _onEnvironmentControlTapped(BuildContext context,
      MainNavigatorEvent Function({bool pushAsReplacement}) navigatorEvent,
      {String tipID, List<String> tipPaths}) {
    return () {
      if (tipPaths != null && !AppDB().isTipDone(tipID)) {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToTipEvent(
            tipID, tipPaths, navigatorEvent(pushAsReplacement: true)));
      } else {
        BlocProvider.of<MainNavigatorBloc>(context).add(navigatorEvent());
      }
    };
  }

  Widget _renderGraphs(BuildContext context) {
    return BlocProvider<BoxAppBarMetricsBloc>(
      create: (context) => BoxAppBarMetricsBloc(box: box),
      child: BoxAppBarMetricsPage(),
    );
  }
}
