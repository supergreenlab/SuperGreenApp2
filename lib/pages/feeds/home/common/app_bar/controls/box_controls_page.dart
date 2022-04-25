/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/date_renderer.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_title.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/controls/box_controls_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_action.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/metrics/app_bar_metrics_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_tab.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class BoxControlsPage extends StatelessWidget {
  static String get plantQuickViewPageLoadingPlantData {
    return Intl.message(
      'Loading plant data',
      name: 'productsPageLoadingPlantData',
      desc: 'Products page loading plant data',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final void Function(Future<dynamic>?)? futureFn;

  const BoxControlsPage({Key? key, this.futureFn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoxControlsBloc, BoxControlsBlocState>(
      listener: (BuildContext context, BoxControlsBlocState state) {
        if (state is BoxControlsBlocStateLoaded) {}
      },
      child: BlocBuilder<BoxControlsBloc, BoxControlsBlocState>(
          bloc: BlocProvider.of<BoxControlsBloc>(context),
          builder: (BuildContext context, BoxControlsBlocState state) {
            if (state is BoxControlsBlocStateInit) {
              return AppBarTab(child: _renderLoading(context, state));
            }
            return AppBarTab(child: _renderLoaded(context, state as BoxControlsBlocStateLoaded));
          }),
    );
  }

  Widget _renderLoading(BuildContext context, BoxControlsBlocStateInit state) {
    return FullscreenLoading(
      title: BoxControlsPage.plantQuickViewPageLoadingPlantData,
    );
  }

  Widget _renderLoaded(BuildContext context, BoxControlsBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _renderStatus(context, state),
        _renderActions(context, state),
      ],
    );
  }

  Widget _renderStatus(BuildContext context, BoxControlsBlocStateLoaded state) {
    return AppBarTitle(
      title: 'Controls',
      plant: state.plant,
      body: AppBarBoxMetricsPage(),
    );
  }

  Widget _renderActions(BuildContext context, BoxControlsBlocStateLoaded state) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AppBarAction(
                    center: true,
                    icon: 'assets/app_bar/icon_ventilation.svg',
                    color: Color(0xFF8EB5FF),
                    title: 'VENTILATION',
                    content: Text(
                      '${state.metrics.blower.param.ivalue}%',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF454545)),
                    ),
                    action: _onEnvironmentControlTapped(
                        context,
                        ({pushAsReplacement = false}) => MainNavigateToFeedVentilationFormEvent(state.box,
                            pushAsReplacement: pushAsReplacement, futureFn: futureFn)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AppBarAction(
                      center: true,
                      icon: 'assets/app_bar/icon_schedule.svg',
                      color: Color(0xFF61A649),
                      title: 'SCHEDULE',
                      content: Text(
                        DateRenderer.renderSchedule(state.metrics.onHour.param, state.metrics.onMin.param,
                            state.metrics.offHour.param, state.metrics.offMin.param),
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF454545)),
                      ),
                      action: _onEnvironmentControlTapped(
                          context,
                          ({pushAsReplacement = false}) => MainNavigateToFeedScheduleFormEvent(state.box,
                              pushAsReplacement: pushAsReplacement, futureFn: futureFn),
                          tipID: 'TIP_BLOOM',
                          tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/when_to_switch_to_bloom/l/en']),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AppBarAction(
                        center: true,
                        icon: 'assets/app_bar/icon_light.svg',
                        color: Color(0xFFDABA48),
                        title: 'LIGHT',
                        content: AutoSizeText(
                          '${state.metrics.light.param.ivalue}%',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF454545)),
                        ),
                        action: _onEnvironmentControlTapped(
                            context,
                            ({pushAsReplacement = false}) => MainNavigateToFeedLightFormEvent(state.box,
                                pushAsReplacement: pushAsReplacement, futureFn: futureFn),
                            tipID: 'TIP_STRETCH',
                            tipPaths: [
                              't/supergreenlab/SuperGreenTips/master/s/when_to_control_stretch_in_seedling/l/en',
                              't/supergreenlab/SuperGreenTips/master/s/how_to_control_stretch_in_seedling/l/en'
                            ]))),
                state.plant != null
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AppBarAction(
                          center: true,
                          icon: 'assets/app_bar/icon_alerts.svg',
                          color: Color(0xFF8848DA),
                          title: 'ALERTS',
                          content: AutoSizeText(
                            '${state.plant!.alerts ? "ON" : "OFF"}',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: state.plant!.alerts ? Color(0xFF3BB28B) : Color(0xFFD7352B)),
                          ),
                          action: () => BlocProvider.of<MainNavigatorBloc>(context).add(
                            MainNavigateToSettingsPlantAlerts(state.plant!, futureFn: futureFn),
                          ),
                        ))
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TODO DRY this with plant_feed_page
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
}
