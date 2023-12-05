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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/api/device/device_params.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/misc/date_renderer.dart';
import 'package:super_green_app/pages/add_device/select_device/select_device_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_missing_controller.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_title.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/controls/box_controls_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_action.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/metrics/app_bar_metrics_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/widgets/app_bar_tab.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class BoxControlsPage extends StatelessWidget {
  static String get boxControlPageLoadingPlantData {
    return Intl.message(
      'Loading plant data',
      name: 'boxControlPageLoadingPlantData',
      desc: 'Box control page loading plant data',
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
            } else if (state is BoxControlsBlocStateNoDevice) {
              return AppBarTab(child: _renderNoDevice(context, state));
            }
            return AppBarTab(child: _renderLoaded(context, state as BoxControlsBlocStateLoaded));
          }),
    );
  }

  Widget _renderNoDevice(BuildContext context, BoxControlsBlocStateNoDevice state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _renderStatus(
          context,
          state.plant,
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _renderButtons(
                context,
                state.box,
                state.plant,
                true,
                '12%',
                true,
                '18/6',
                true,
                '66%',
                'ON',
              ),
              AppBarMissingController(state.box),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderLoading(BuildContext context, BoxControlsBlocStateInit state) {
    return FullscreenLoading(
      title: BoxControlsPage.boxControlPageLoadingPlantData,
    );
  }

  Widget _renderLoaded(BuildContext context, BoxControlsBlocStateLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _renderStatus(context, state.plant),
        _renderActions(context, state),
      ],
    );
  }

  Widget _renderStatus(BuildContext context, Plant? plant) {
    return AppBarTitle(
      title: 'Controls',
      plant: plant,
      body: AppBarBoxMetricsPage(),
    );
  }

  Widget _renderActions(BuildContext context, BoxControlsBlocStateLoaded state) {
    double totalDimming = 0;
    List<ParamController> dimmings = state.metrics.lightsDimming;
    for (ParamController dimming in dimmings) {
      totalDimming += dimming.ivalue;
    }
    if (dimmings.length != 0) {
      totalDimming /= dimmings.length;
      totalDimming *= state.metrics.light.ivalue / 100.0;
    }
    Widget buttons = _renderButtons(
      context,
      state.box,
      state.plant,
      state.metrics.blower.available,
      state.metrics.blower.available ? '${state.metrics.blower.ivalue}%' : 'N/A%',
      state.metrics.onHour.available && state.metrics.offHour.available,
      state.metrics.onHour.available && state.metrics.offHour.available
          ? DateRenderer.renderSchedule(state.metrics.onHour.param!, state.metrics.onMin.param!,
              state.metrics.offHour.param!, state.metrics.offMin.param!)
          : 'N/A',
      state.metrics.nLights > 0,
      state.metrics.nLights > 0 ? '${totalDimming.floor()}%' : 'N/A%',
      '${state.plant!.alerts ? "ON" : "OFF"}',
    );
    if (state.box.screenDevice == null) {
      buttons = Column(
        children: [
          _renderScreenButton(context),
          Expanded(child: buttons),
        ],
      );
    }
    return Expanded(
      child: buttons,
    );
  }

  Widget _renderScreenButton(BuildContext context) {
    return InkWell(
        onTap: () {
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSelectDeviceEvent(
              isScreen: true,
              isController: false,
              futureFn: (future) async {
                dynamic res = await future;
                if (res is SelectBoxDeviceData) {
                  BlocProvider.of<BoxControlsBloc>(context)
                      .add(BoxControlsBlocEventSetDevice(res.device, res.deviceBox));
                }
              }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SvgPicture.asset('assets/checklist/icon_checklist.svg'),
          ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10.0, right: 8.0),
              child: Text('ADD A SCREEN!',
                  style: TextStyle(color: Color(0xff3bb30b), decoration: TextDecoration.underline)),
            ),
          ],
        ));
  }

  Widget _renderButtons(BuildContext context, Box box, Plant? plant, bool blowerAvailable, String blower,
      bool scheduleAvailable, String schedule, bool lightAvailable, String light, String alerts) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
                child: AppBarAction(
                  center: true,
                  disabled: !blowerAvailable,
                  icon: 'assets/app_bar/icon_ventilation.svg',
                  color: Color(0xFF8EB5FF),
                  title: 'VENTILATION',
                  content: AutoSizeText(
                    blower,
                    maxLines: 1,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF454545)),
                  ),
                  action: !blowerAvailable
                      ? null
                      : _onEnvironmentControlTapped(
                          context,
                          ({pushAsReplacement = false}) => MainNavigateToFeedVentilationFormEvent(box,
                              pushAsReplacement: pushAsReplacement, futureFn: futureFn)),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
                  child: AppBarAction(
                    center: true,
                    disabled: !scheduleAvailable,
                    icon: 'assets/app_bar/icon_schedule.svg',
                    color: Color(0xFF61A649),
                    title: 'SCHEDULE',
                    content: AutoSizeText(
                      schedule,
                      maxLines: 1,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF454545)),
                    ),
                    action: !scheduleAvailable
                        ? null
                        : _onEnvironmentControlTapped(
                            context,
                            ({pushAsReplacement = false}) => MainNavigateToFeedScheduleFormEvent(box,
                                pushAsReplacement: pushAsReplacement, futureFn: futureFn),
                            tipID: 'TIP_BLOOM',
                            tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/when_to_switch_to_bloom/l/en']),
                  )),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
                  child: AppBarAction(
                      center: true,
                      disabled: !lightAvailable,
                      icon: 'assets/app_bar/icon_light.svg',
                      color: Color(0xFFDABA48),
                      title: 'LIGHT',
                      content: AutoSizeText(
                        light,
                        maxLines: 1,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF454545)),
                      ),
                      action: !lightAvailable
                          ? null
                          : _onEnvironmentControlTapped(
                              context,
                              ({pushAsReplacement = false}) => MainNavigateToFeedLightFormEvent(box,
                                  pushAsReplacement: pushAsReplacement, futureFn: futureFn),
                              tipID: 'TIP_STRETCH',
                              tipPaths: [
                                  't/supergreenlab/SuperGreenTips/master/s/when_to_control_stretch_in_seedling/l/en',
                                  't/supergreenlab/SuperGreenTips/master/s/how_to_control_stretch_in_seedling/l/en'
                                ]))),
              plant != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
                      child: AppBarAction(
                        center: true,
                        icon: 'assets/app_bar/icon_alerts.svg',
                        color: Color(0xFF8848DA),
                        title: 'ALERTS',
                        content: AutoSizeText(
                          alerts,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: plant.alerts ? Color(0xFF3BB28B) : Color(0xFFD7352B)),
                        ),
                        action: () => BlocProvider.of<MainNavigatorBloc>(context).add(
                          MainNavigateToSettingsPlantAlerts(plant, futureFn: futureFn),
                        ),
                      ))
                  : Container(),
            ],
          ),
        ),
      ],
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
