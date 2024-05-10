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

import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/device_daemon/device_reachable_listener_bloc.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/common/metrics/app_bar_metrics_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/controls/box_controls_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/controls/box_controls_page.dart';
import 'package:super_green_app/pages/feeds/home/common/drawer/plant_drawer_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/environment/environments_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/plant_infos_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/products/products_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/products/products_page.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/widgets/plant_feed_filter_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/widgets/single_feed_entry.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/status/plant_quick_view_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/app_bar/status/plant_quick_view_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/local_plant_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/local_products_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/plant_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/plant_infos_bloc_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/sunglasses_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/widgets/plant_dial_button.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/widgets/plant_public_link.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

enum SpeedDialType {
  general,
  trainings,
  lifeevents,
}

class PlantFeedPage extends StatefulWidget {
  static String get plantFeedPageTitle {
    return Intl.message(
      'Plant feed',
      name: 'plantFeedPageTitle',
      desc: 'Label for the button that shows the complete diary when looking at a single feed entry',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageSingleEntry {
    return Intl.message(
      'Viewing single log entry',
      name: 'plantFeedPageSingleEntry',
      desc: 'Label for the button that shows the complete diary when looking at a single feed entry',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageSingleEntryButton {
    return Intl.message(
      'View complete diary',
      name: 'plantFeedPageSingleEntryButton',
      desc: 'Button that shows the complete diary when looking at a single feed entry',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuDefoliation {
    return Intl.message(
      'Defoliation',
      name: 'plantFeedPageMenuDefoliation',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuTopping {
    return Intl.message(
      'Topping',
      name: 'plantFeedPageMenuTopping',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuCloning {
    return Intl.message(
      'Cloning',
      name: 'plantFeedPageMenuCloning',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuFimming {
    return Intl.message(
      'Fimming',
      name: 'plantFeedPageMenuFimming',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuBending {
    return Intl.message(
      'Bending',
      name: 'plantFeedPageMenuBending',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuTransplant {
    return Intl.message(
      'Transplant',
      name: 'plantFeedPageMenuTransplant',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuGerminating {
    return Intl.message(
      'Germinating',
      name: 'plantFeedPageMenuGerminating',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuVegging {
    return Intl.message(
      'Vegging',
      name: 'plantFeedPageMenuVegging',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuBlooming {
    return Intl.message(
      'Blooming',
      name: 'plantFeedPageMenuBlooming',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuDrying {
    return Intl.message(
      'Drying',
      name: 'plantFeedPageMenuDrying',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuCuring {
    return Intl.message(
      'Curing',
      name: 'plantFeedPageMenuCuring',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuGrowlog {
    return Intl.message(
      'Grow log',
      name: 'plantFeedPageMenuGrowlog',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuMeasure {
    return Intl.message(
      'Measure',
      name: 'plantFeedPageMenuMeasure',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuNutrientMix {
    return Intl.message(
      'Nutrient mix',
      name: 'plantFeedPageMenuNutrientMix',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuWatering {
    return Intl.message(
      'Watering',
      name: 'plantFeedPageMenuWatering',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuPlantTraining {
    return Intl.message(
      'Plant training',
      name: 'plantFeedPageMenuPlantTraining',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageMenuLifeEvents {
    return Intl.message(
      'Life events',
      name: 'plantFeedPageMenuLifeEvents',
      desc: 'Speed dial (lower right menu) button label',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageLoading {
    return Intl.message(
      'Loading plant..',
      name: 'plantFeedPageLoading',
      desc: 'Loading message while fetching plant from db',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageArchived {
    return Intl.message(
      'Plant was removed or archived.',
      name: 'plantFeedPageArchived',
      desc: 'Message displayed when the plant that was displayed has be removed or archived',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageOpenPlantMenu {
    return Intl.message(
      'OPEN PLANT LIST',
      name: 'plantFeedPageOpenPlantMenu',
      desc: 'Button displayed under plantFeedPageArchived, opens the plant menu',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageNoPlantYet {
    return Intl.message(
      'You have no plant yet.',
      name: 'plantFeedPageNoPlantYet',
      desc: 'Displayed when no plant has been added to the app yet',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageAddFirstPlantPart1 {
    return Intl.message(
      'Add your first',
      name: 'plantFeedPageAddFirstPlantPart1',
      desc: 'First part of the "Add your first PLANT" text when no plant yet',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageAddFirstPlantPart2 {
    return Intl.message(
      'PLANT',
      name: 'plantFeedPageAddFirstPlantPart2',
      desc: 'Second part of the "Add your first PLANT" text when no plant yet',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get plantFeedPageStart {
    return Intl.message(
      'START',
      name: 'plantFeedPageStart',
      desc: 'Button displayed under plantFeedPageAddFirstPlantPart2, opens the plant creation user flow',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  _PlantFeedPageState createState() => _PlantFeedPageState();
}

class _PlantFeedPageState extends State<PlantFeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _openCloseDial = ValueNotifier<int>(0);
  SpeedDialType _speedDialType = SpeedDialType.general;

  int tabIndex = 0;

  bool _speedDialOpen = false;
  bool _showIP = false;
  bool _reachable = false;
  bool _remote = false;
  String _deviceIP = '';

  List<String> filters = [];

  @override
  void initState() {
    filters = AppDB().getAppData().filters ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_speedDialOpen) {
          _openCloseDial.value = Random().nextInt(1 << 32);
          return false;
        }
        return true;
      },
      child: BlocListener<PlantFeedBloc, PlantFeedBlocState>(
        listener: (BuildContext context, PlantFeedBlocState state) {
          if (state is PlantFeedBlocStateLoaded) {
            if (state.box.device != null) {
              // TODO find something better than this
              Timer(Duration(milliseconds: 100), () {
                BlocProvider.of<DeviceReachableListenerBloc>(context)
                    .add(DeviceReachableListenerBlocEventLoadDevice(state.box.device!));
              });
            }
          }
        },
        child: BlocBuilder<PlantFeedBloc, PlantFeedBlocState>(
          bloc: BlocProvider.of<PlantFeedBloc>(context),
          builder: (BuildContext context, PlantFeedBlocState state) {
            Widget body;
            if (_speedDialOpen) {
              body = Stack(
                children: <Widget>[
                  _renderFeed(context, state),
                  _renderOverlay(context),
                ],
              );
            } else {
              body = Stack(
                children: <Widget>[
                  _renderFeed(context, state),
                ],
              );
            }

            return BlocListener<DeviceReachableListenerBloc, DeviceReachableListenerBlocState>(
              listener: (BuildContext context, DeviceReachableListenerBlocState reachableState) {
                if (state is PlantFeedBlocStateLoaded) {
                  if (reachableState is DeviceReachableListenerBlocStateDeviceReachable &&
                      reachableState.device.id == state.box.device) {
                    setState(() {
                      _reachable = reachableState.reachable;
                      _remote = reachableState.remote;
                      _deviceIP = reachableState.device.ip;
                    });
                  }
                }
              },
              child: Scaffold(
                  key: _scaffoldKey,
                  appBar: state is PlantFeedBlocStateNoPlant || state is PlantFeedBlocStatePlantRemoved
                      ? SGLAppBar(
                          PlantFeedPage.plantFeedPageTitle,
                          fontSize: 20,
                          backgroundColor: Color(0xff063047),
                          titleColor: Colors.white,
                          iconColor: Colors.white,
                        )
                      : null,
                  drawer: Drawer(
                      child: PlantDrawerPage(
                    selectedPlant: state is PlantFeedBlocStateLoaded ? state.plant : null,
                  )),
                  body: AnimatedSwitcher(child: body, duration: Duration(milliseconds: 200)),
                  floatingActionButton: state is PlantFeedBlocStateLoaded ? _renderSpeedDial(context, state) : null),
            );
          },
        ),
      ),
    );
  }

  SpeedDial _renderSpeedDial(BuildContext context, PlantFeedBlocStateLoaded state) {
    return SpeedDial(
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        animationSpeed: 50,
        curve: Curves.bounceIn,
        backgroundColor: Color(0xff3bb30b),
        child: PlantDialButton(
          openned: _speedDialOpen,
        ),
        overlayOpacity: 0.8,
        openCloseDial: _openCloseDial,
        closeManually: true,
        onOpen: () {
          setState(() {
            _speedDialType = SpeedDialType.general;
            _speedDialOpen = true;
          });
        },
        onClose: () {
          setState(() {
            _speedDialOpen = false;
          });
        },
        children: [
          () => _renderGeneralSpeedDials(context, state),
          () => _renderTrimSpeedDials(context, state),
          () => _renderLifeEvents(context, state),
        ][_speedDialType.index]());
  }

  List<SpeedDialChild> _renderTrimSpeedDials(BuildContext context, PlantFeedBlocStateLoaded state) {
    return [
      SpeedDialChild(
          child: SvgPicture.asset('assets/feed_card/icon_none.svg'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: Colors.white,
          onTap: () {
            setState(() {
              _speedDialType = SpeedDialType.general;
            });
          }),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuDefoliation,
          FeedEntryIcons[FE_DEFOLIATION]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedDefoliationFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_DEFOLIATION',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_defoliate/l/en'])),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuTopping,
          FeedEntryIcons[FE_TOPPING]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedToppingFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_TOPPING',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_top/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_top/l/en'
              ])),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuCloning,
          FeedEntryIcons[FE_CLONING]!,
          _onSpeedDialSelected(
            context,
            ({pushAsReplacement = false}) => MainNavigateToFeedCloningFormEvent(state.plant,
                pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
          )),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuFimming,
          FeedEntryIcons[FE_FIMMING]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedFimmingFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_FIMMING',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_top/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_top/l/en'
              ])),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuBending,
          FeedEntryIcons[FE_BENDING]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedBendingFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_BENDING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_low_stress_training_LST/l/en'])),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuTransplant,
          FeedEntryIcons[FE_TRANSPLANT]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedTransplantFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_TRANSPLANT',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_repot_your_seedling/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_transplant_your_seedling/l/en'
              ])),
    ];
  }

  List<SpeedDialChild> _renderLifeEvents(BuildContext context, PlantFeedBlocStateLoaded state) {
    return [
      SpeedDialChild(
          child: SvgPicture.asset('assets/feed_card/icon_none.svg'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: Colors.white,
          onTap: () {
            setState(() {
              _speedDialType = SpeedDialType.general;
            });
          }),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuCloning,
          FeedEntryIcons[FE_LIFE_EVENT_CLONING]!,
          _onSpeedDialSelected(
            context,
            ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(state.plant, PlantPhases.CLONING,
                pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
          )),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuGerminating,
          FeedEntryIcons[FE_LIFE_EVENT_GERMINATING]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(
                  state.plant, PlantPhases.GERMINATING,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_GERMINATING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_germinate_your_seed/l/en'])),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuVegging,
          'assets/plant_infos/icon_vegging_since.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(state.plant, PlantPhases.VEGGING,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_VEGGING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/when_does_vegetative_state_start/l/en'])),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuBlooming,
          'assets/plant_infos/icon_blooming_since.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(state.plant, PlantPhases.BLOOMING,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_BLOOMING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/when_does_flowering_start/l/en'])),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuDrying,
          'assets/plant_infos/icon_drying_since.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(state.plant, PlantPhases.DRYING,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_DRYING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_dry/l/en'])),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuCuring,
          'assets/plant_infos/icon_curing_since.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(state.plant, PlantPhases.CURING,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_CURING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/why_cure/l/en'])),
    ];
  }

  List<SpeedDialChild> _renderGeneralSpeedDials(BuildContext context, PlantFeedBlocStateLoaded state) {
    return [
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuGrowlog,
          FeedEntryIcons[FE_MEDIA]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedMediaFormEvent(
                  plant: state.plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)))),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuMeasure,
          FeedEntryIcons[FE_MEASURE]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedMeasureFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)))),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuNutrientMix,
          FeedEntryIcons[FE_NUTRIENT_MIX]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedNutrientMixFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_WATERING',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_start_adding_nutrients/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_prepare_nutrients/l/en'
              ])),
      _renderSpeedDialChild(
          PlantFeedPage.plantFeedPageMenuWatering,
          FeedEntryIcons[FE_WATER]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedWaterFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_WATERING',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_water_seedling/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_water/l/en'
              ])),
      SpeedDialChild(
          child: SvgPicture.asset('assets/feed_card/icon_training.svg'),
          label: PlantFeedPage.plantFeedPageMenuPlantTraining,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: Colors.white,
          onTap: () {
            setState(() {
              _speedDialType = SpeedDialType.trainings;
            });
          }),
      SpeedDialChild(
          child: SvgPicture.asset('assets/feed_card/icon_life_events.svg'),
          label: PlantFeedPage.plantFeedPageMenuLifeEvents,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: Colors.white,
          onTap: () {
            setState(() {
              _speedDialType = SpeedDialType.lifeevents;
            });
          }),
    ];
  }

  SpeedDialChild _renderSpeedDialChild(String label, String icon, void Function() navigateTo) {
    return SpeedDialChild(
      child: SvgPicture.asset(icon),
      label: label,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      onTap: navigateTo,
      backgroundColor: Colors.white,
    );
  }

  void Function() _onSpeedDialSelected(
      BuildContext context, MainNavigatorEvent Function({bool pushAsReplacement}) navigatorEvent,
      {String? tipID, List<String>? tipPaths}) {
    return () {
      _openCloseDial.value = Random().nextInt(1 << 32);
      if (tipPaths != null && !AppDB().isTipDone(tipID!)) {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToTipEvent(
            tipID, tipPaths, navigatorEvent(pushAsReplacement: true) as MainNavigateToFeedFormEvent));
      } else {
        BlocProvider.of<MainNavigatorBloc>(context).add(navigatorEvent());
      }
    };
  }

  Widget _renderFeed(BuildContext context, PlantFeedBlocState state) {
    if (state is PlantFeedBlocStateLoaded) {
      List<Widget> actions = [
        IconButton(
          icon: Icon(Icons.remove_red_eye),
          tooltip: 'View live cams',
          onPressed: () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToTimelapseViewer(state.plant));
          },
        ),
      ];
      if (state.box.device != null && _reachable) {
        actions.insert(
            0,
            BlocProvider<SunglassesBloc>(
              create: (BuildContext context) => SunglassesBloc(state.box.device!, state.box.deviceBox!),
              child: BlocBuilder<SunglassesBloc, SunglassesBlocState>(
                builder: (BuildContext context, SunglassesBlocState state) {
                  if (state is SunglassesBlocStateLoaded) {
                    return Opacity(
                      opacity: state.sunglassesOn ? 0.5 : 1,
                      child: IconButton(
                        icon: SvgPicture.asset('assets/home/icon_sunglasses.svg'),
                        tooltip: 'Sunglasses mode',
                        onPressed: () {
                          BlocProvider.of<SunglassesBloc>(context).add(SunglassesBlocEventOnOff());
                        },
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ));
      }
      if (state.plant.serverID != null) {
        actions.insert(
          0,
          IconButton(
            icon: SvgPicture.asset('assets/home/icon_share_link.svg'),
            tooltip: 'Share link',
            onPressed: () {
              _showSharingLink(context, state);
            },
          ),
        );
      }
      Widget? bottom;
      if (state.feedEntry != null) {
        bottom = SingleFeedEntry(
          title: PlantFeedPage.plantFeedPageSingleEntry,
          button: PlantFeedPage.plantFeedPageSingleEntryButton,
          onTap: () {
            BlocProvider.of<HomeNavigatorBloc>(context).add(HomeNavigateToPlantFeedEvent(state.plant));
          },
        );
      }

      return BlocProvider(
        key: Key('feed'),
        create: (context) => FeedBloc(
            LocalPlantFeedBlocDelegate(state.plant.feed,
                feedEntryID: state.feedEntry?.id, commentID: state.commentID, replyTo: state.replyTo),
            filters: filters),
        child: FeedPage(
          automaticallyImplyLeading: true,
          single: state.feedEntry != null,
          color: Color(0xff063047),
          actions: actions,
          bottomPadding: true,
          titleWidget: _renderName(context, state),
          appBarHeight: 410,
          appBar: _renderAppBar(context, state),
          firstItem: PlantFeedFilterPage(
            filters: filters,
            onSaveFilters: (f) {
              filters = f;
              AppDB().setFilters(filters);
            },
          ),
          bottom: bottom,
        ),
      );
    } else if (state is PlantFeedBlocStateNoPlant) {
      return _renderNoPlant(context);
    } else if (state is PlantFeedBlocStatePlantRemoved) {
      return _renderPlantRemoved(context);
    }
    return FullscreenLoading(title: PlantFeedPage.plantFeedPageLoading);
  }

  Widget _renderPlantRemoved(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Center(
          child: Column(children: [
        Icon(Icons.delete, color: Colors.grey, size: 100),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(PlantFeedPage.plantFeedPageArchived, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
        ),
        GreenButton(
          title: PlantFeedPage.plantFeedPageOpenPlantMenu,
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ]))
    ]);
  }

  Widget _renderNoPlant(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(PlantFeedPage.plantFeedPageNoPlantYet,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                  Text(PlantFeedPage.plantFeedPageAddFirstPlantPart1,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  Text(PlantFeedPage.plantFeedPageAddFirstPlantPart2,
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200, color: Color(0xff3bb30b))),
                ],
              ),
            ),
            GreenButton(
              title: PlantFeedPage.plantFeedPageStart,
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToCreatePlantEvent(futureFn: (future) async {
                  dynamic res = await future;
                  if (res == true) {
                    BlocProvider.of<PlantFeedBloc>(context).add(PlantFeedBlocEventLoad());
                  }
                }));
              },
            ),
          ],
        )),
      ],
    );
  }

  Widget _renderOverlay(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return InkWell(
          onTap: () {
            _openCloseDial.value = Random().nextInt(1 << 32);
          },
          child: Container(width: constraints.maxWidth, height: constraints.maxHeight, color: Colors.white60),
        );
      },
    );
  }

  Widget _renderName(BuildContext context, PlantFeedBlocStateLoaded state) {
    String name = state.plant.name;

    Widget nameText;
    if (_showIP) {
      nameText = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 145),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                name,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
              ),
              Text(_remote ? 'Remote controled!' : _deviceIP,
                  style: TextStyle(
                    fontSize: 10,
                    color: _remote ? Color(0xff3bb30b) : Colors.grey,
                  ))
            ],
          ));
    } else {
      nameText = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 145),
        child: AutoSizeText(
          name,
          maxLines: 2,
          overflow: TextOverflow.fade,
          softWrap: true,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w200,
          ),
        ),
      );
      if (state.box.device != null) {
        nameText = Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: nameText,
            ),
            Icon(Icons.offline_bolt, color: _reachable ? Colors.green : Colors.grey, size: 20),
          ],
        );
      }
    }

    nameText = InkWell(
      onTap: () {
        if (state.box.device == null) {
          return;
        }
        setState(() {
          _showIP = !_showIP;
        });
      },
      child: nameText,
    );

    return nameText;
  }

  Widget _renderAppBar(BuildContext context, PlantFeedBlocStateLoaded state) {
    List<Widget Function(BuildContext, PlantFeedBlocStateLoaded)> tabs = [
      _renderQuickView,
      _renderControls,
      (c, s) => EnvironmentsPage(s.box, plant: s.plant, futureFn: futureFn(c, s)),
      _renderPlantInfos,
      _renderProducts,
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 45.0),
        child: Swiper(
          onIndexChanged: (value) {
            setState(() {
              this.tabIndex = value;
            });
          },
          itemCount: tabs.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return tabs[index](context, state);
          },
          pagination: SwiperPagination(
            builder: new DotSwiperPaginationBuilder(color: Colors.white, activeColor: Color(0xff3bb30b)),
          ),
          loop: false,
        ),
      ),
    );
  }

  Widget _renderQuickView(BuildContext context, PlantFeedBlocStateLoaded state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlantQuickViewBloc>(create: (context) => PlantQuickViewBloc(state.plant, state.box)),
        BlocProvider<AppBarMetricsBloc>(create: (context) => AppBarMetricsBloc(state.box)),
      ],
      child: PlantQuickViewPage(),
    );
  }

  Widget _renderControls(BuildContext context, PlantFeedBlocStateLoaded state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoxControlsBloc>(create: (context) => BoxControlsBloc(state.plant, state.box)),
        BlocProvider<AppBarMetricsBloc>(create: (context) => AppBarMetricsBloc(state.box)),
      ],
      child: BoxControlsPage(
        futureFn: futureFn(context, state),
      ),
    );
  }

  Widget _renderPlantInfos(BuildContext context, PlantFeedBlocStateLoaded state) {
    return BlocProvider<PlantInfosBloc>(
      create: (context) => PlantInfosBloc(LocalPlantInfosBlocDelegate(state.plant)),
      child: PlantInfosPage(),
    );
  }

  Widget _renderProducts(BuildContext context, PlantFeedBlocStateLoaded state) {
    return BlocProvider(
      create: (context) => ProductsBloc(LocalProductsBlocDelegate(state.plant)),
      child: ProductsPage(),
    );
  }

  void _showSharingLink(BuildContext context, PlantFeedBlocStateLoaded state) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext c) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: PlantPublicLink(
                state: state,
                onMakePublic: () {
                  BlocProvider.of<PlantFeedBloc>(context).add(PlantFeedBlocEventMakePublic());
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

// TODO DRY this somewhere
  void Function(Future<dynamic>?) futureFn(BuildContext context, PlantFeedBlocStateLoaded state) {
    return (Future<dynamic>? future) async {
      dynamic feedEntry = await future;
      if (feedEntry != null && feedEntry is FeedEntry) {
        BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(state.plant, feedEntry));
      }
    };
  }
}
