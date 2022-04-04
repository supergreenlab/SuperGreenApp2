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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/environment/graphs/box_app_bar_metrics_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/environment/graphs/box_app_bar_metrics_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_tab.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EnvironmentsPage extends StatelessWidget {
  static String get environmentsPageControllerRequired {
    return Intl.message(
      'Monitoring feature\nrequires an SGL controller',
      name: 'environmentsPageControllerRequired',
      desc: 'Message over the graphs when controller is missing',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageShopNow {
    return Intl.message(
      'SHOP NOW',
      name: 'environmentsPageShopNow',
      desc: 'SHOW NOW button displayed when controller is missing',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageOr {
    return Intl.message(
      'or',
      name: 'environmentsPageOr',
      desc: 'SHOW NOW *or* DIY NOW displayed when controller is missing',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageDIYNow {
    return Intl.message(
      'DIY NOW',
      name: 'environmentsPageDIYNow',
      desc: 'DIY NOW button displayed when controller is missing',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageAlreadyGotOne {
    return Intl.message(
      'already got one?',
      name: 'environmentsPageAlreadyGotOne',
      desc:
          'label for the SETUP CONTROLLER button displayed when controller is missing, opens the select controller dialog',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageSetupController {
    return Intl.message(
      'SETUP CONTROLLER',
      name: 'environmentsPageSetupController',
      desc: 'SETUP CONTROLLER displayed when controller is missing, opens the select controller dialog',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageControlTitle {
    return Intl.message(
      'Environment control',
      name: 'environmentsPageControlTitle',
      desc: 'Title displayed above the environment control buttons',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageLight {
    return Intl.message(
      'Light',
      name: 'environmentsPageLight',
      desc: 'Label for the light dimming control page button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageVentilation {
    return Intl.message(
      'Ventil',
      name: 'environmentsPageVentilation',
      desc: 'Label for the ventilation control page button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageSchedule {
    return Intl.message(
      'Schedule',
      name: 'environmentsPageSchedule',
      desc: 'Label for the schedule control page button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get environmentsPageAlerts {
    return Intl.message(
      'Alerts',
      name: 'environmentsPageAlerts',
      desc: 'Label for the alert control page button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final Box box;
  final Plant? plant;
  final void Function(Future<dynamic>?)? futureFn;

  const EnvironmentsPage(this.box, {Key? key, this.futureFn, this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget graphBody;
    if (box.device != null) {
      graphBody = _renderGraphs(context);
    } else {
      graphBody = Stack(children: [
        _renderGraphs(context),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white.withAlpha(190)),
          child: Fullscreen(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            title: EnvironmentsPage.environmentsPageControllerRequired,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GreenButton(
                      title: EnvironmentsPage.environmentsPageShopNow,
                      onPressed: () {
                        launch('https://www.supergreenlab.com');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(EnvironmentsPage.environmentsPageOr, style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    GreenButton(
                      title: EnvironmentsPage.environmentsPageDIYNow,
                      onPressed: () {
                        launch('https://github.com/supergreenlab');
                      },
                    ),
                  ],
                ),
                Text(EnvironmentsPage.environmentsPageAlreadyGotOne),
                GreenButton(
                  title: EnvironmentsPage.environmentsPageSetupController,
                  onPressed: () {
                    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsBox(box));
                  },
                ),
              ],
            ),
            childFirst: false,
          ),
        ),
      ]);
    }

    return AppBarTab(child: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: graphBody));
  }

  Widget _renderEnvironmentControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4, bottom: 8),
          child: Text(EnvironmentsPage.environmentsPageControlTitle, style: TextStyle(color: Colors.white)),
        ),
        Row(
          children: <Widget>[
            _renderEnvironmentControl(
                context,
                EnvironmentsPage.environmentsPageLight,
                'assets/feed_card/icon_dimming.svg',
                _onEnvironmentControlTapped(
                    context,
                    ({pushAsReplacement = false}) =>
                        MainNavigateToFeedLightFormEvent(box, pushAsReplacement: pushAsReplacement, futureFn: futureFn),
                    tipID: 'TIP_STRETCH',
                    tipPaths: [
                      't/supergreenlab/SuperGreenTips/master/s/when_to_control_stretch_in_seedling/l/en',
                      't/supergreenlab/SuperGreenTips/master/s/how_to_control_stretch_in_seedling/l/en'
                    ])),
            _renderEnvironmentControl(
                context,
                EnvironmentsPage.environmentsPageVentilation,
                'assets/feed_card/icon_blower.svg',
                _onEnvironmentControlTapped(
                    context,
                    ({pushAsReplacement = false}) => MainNavigateToFeedVentilationFormEvent(box,
                        pushAsReplacement: pushAsReplacement, futureFn: futureFn))),
            _renderEnvironmentControl(
                context,
                EnvironmentsPage.environmentsPageSchedule,
                'assets/feed_card/icon_schedule.svg',
                _onEnvironmentControlTapped(
                    context,
                    ({pushAsReplacement = false}) => MainNavigateToFeedScheduleFormEvent(box,
                        pushAsReplacement: pushAsReplacement, futureFn: futureFn),
                    tipID: 'TIP_BLOOM',
                    tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/when_to_switch_to_bloom/l/en'])),
            this.plant != null
                ? _renderEnvironmentControl(
                    context,
                    EnvironmentsPage.environmentsPageAlerts,
                    'assets/home/icon_alerts.svg',
                    () => BlocProvider.of<MainNavigatorBloc>(context)
                        .add(MainNavigateToSettingsPlantAlerts(this.plant!, futureFn: futureFn)))
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget _renderEnvironmentControl(BuildContext context, String name, String icon, void Function() navigateTo) {
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
                child: SvgPicture.asset(icon, width: 40, height: 40, fit: BoxFit.contain)),
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

  void Function() _onEnvironmentControlTapped(
      BuildContext context, MainNavigatorEvent Function({bool pushAsReplacement}) navigatorEvent,
      {String? tipID, List<String>? tipPaths}) {
    return () {
      if (tipPaths != null && !AppDB().isTipDone(tipID!)) {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToTipEvent(
            tipID, tipPaths, navigatorEvent(pushAsReplacement: true) as MainNavigateToFeedFormEvent));
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
