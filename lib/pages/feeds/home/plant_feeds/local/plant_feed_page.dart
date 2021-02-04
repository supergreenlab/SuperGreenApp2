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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/feeds/home/common/drawer/plant_drawer_page.dart';
import 'package:super_green_app/pages/feeds/home/common/environment/environments_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/plant_infos/plant_infos_page.dart';
import 'package:super_green_app/pages/feeds/home/common/products/products_bloc.dart';
import 'package:super_green_app/pages/feeds/home/common/products/products_page.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/widgets/single_feed_entry.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/local_plant_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/local_products_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/plant_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/plant_infos_bloc_delegate.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/sunglasses_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/widgets/plant_dial_button.dart';
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
  @override
  _PlantFeedPageState createState() => _PlantFeedPageState();
}

class _PlantFeedPageState extends State<PlantFeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _openCloseDial = ValueNotifier<int>(0);
  SpeedDialType _speedDialType = SpeedDialType.general;

  bool _speedDialOpen = false;
  bool _showIP = false;
  bool _reachable = false;
  String _deviceIP = '';

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
                BlocProvider.of<DeviceDaemonBloc>(context).add(DeviceDaemonBlocEventLoadDevice(state.box.device));
              });
            }
          }
        },
        child: BlocBuilder<PlantFeedBloc, PlantFeedBlocState>(
          cubit: BlocProvider.of<PlantFeedBloc>(context),
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

            return BlocListener<DeviceDaemonBloc, DeviceDaemonBlocState>(
              listener: (BuildContext context, DeviceDaemonBlocState daemonState) {
                if (state is PlantFeedBlocStateLoaded) {
                  if (daemonState is DeviceDaemonBlocStateDeviceReachable &&
                      daemonState.device.id == state.box.device) {
                    setState(() {
                      _reachable = daemonState.reachable;
                      _deviceIP = daemonState.device.ip;
                    });
                  }
                }
              },
              child: Scaffold(
                  key: _scaffoldKey,
                  appBar: state is PlantFeedBlocStateNoPlant || state is PlantFeedBlocStatePlantRemoved
                      ? SGLAppBar(
                          'Plant feed',
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
        marginBottom: 10,
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
          _renderGeneralSpeedDials(context, state),
          _renderTrimSpeedDials(context, state),
          _renderLifeEvents(context, state),
        ][_speedDialType.index]);
  }

  List<SpeedDialChild> _renderTrimSpeedDials(BuildContext context, PlantFeedBlocStateLoaded state) {
    return [
      SpeedDialChild(
          child: SvgPicture.asset('assets/feed_card/icon_none.svg'),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          onTap: () {
            setState(() {
              _speedDialType = SpeedDialType.general;
            });
          }),
      _renderSpeedDialChild(
          'Defoliation',
          'assets/feed_card/icon_defoliation.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedDefoliationFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_DEFOLIATION',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_defoliate/l/en'])),
      _renderSpeedDialChild(
          'Topping',
          'assets/feed_card/icon_topping.svg',
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
          'Fimming',
          'assets/feed_card/icon_fimming.svg',
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
          'Bending',
          'assets/feed_card/icon_bending.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedBendingFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_BENDING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_low_stress_training_LST/l/en'])),
      _renderSpeedDialChild(
          'Transplant',
          'assets/feed_card/icon_transplant.svg',
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
          onTap: () {
            setState(() {
              _speedDialType = SpeedDialType.general;
            });
          }),
      _renderSpeedDialChild(
          'Germinating',
          'assets/plant_infos/icon_germination_date.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(
                  state.plant, PlantPhases.GERMINATING,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_GERMINATING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_germinate_your_seed/l/en'])),
      _renderSpeedDialChild(
          'Vegging',
          'assets/plant_infos/icon_vegging_since.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(state.plant, PlantPhases.VEGGING,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_VEGGING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/when_does_vegetative_state_start/l/en'])),
      _renderSpeedDialChild(
          'Blooming',
          'assets/plant_infos/icon_blooming_since.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(state.plant, PlantPhases.BLOOMING,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_BLOOMING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/when_does_flowering_start/l/en'])),
      _renderSpeedDialChild(
          'Drying',
          'assets/plant_infos/icon_drying_since.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedLifeEventFormEvent(state.plant, PlantPhases.DRYING,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)),
              tipID: 'TIP_DRYING',
              tipPaths: ['t/supergreenlab/SuperGreenTips/master/s/how_to_dry/l/en'])),
      _renderSpeedDialChild(
          'Curing',
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
          'Grow log',
          'assets/feed_card/icon_media.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedMediaFormEvent(
                  plant: state.plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)))),
      _renderSpeedDialChild(
          'Measure',
          'assets/feed_card/icon_measure.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedMeasureFormEvent(state.plant,
                  pushAsReplacement: pushAsReplacement, futureFn: futureFn(context, state)))),
      _renderSpeedDialChild(
          'Nutrient mix',
          'assets/feed_card/icon_nutrient_mix.svg',
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
          'Watering',
          'assets/feed_card/icon_watering.svg',
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
          label: 'Plant training',
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          onTap: () {
            setState(() {
              _speedDialType = SpeedDialType.trainings;
            });
          }),
      SpeedDialChild(
          child: SvgPicture.asset('assets/feed_card/icon_life_events.svg'),
          label: 'Life events',
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  void Function() _onSpeedDialSelected(
      BuildContext context, MainNavigatorEvent Function({bool pushAsReplacement}) navigatorEvent,
      {String tipID, List<String> tipPaths}) {
    return () {
      _openCloseDial.value = Random().nextInt(1 << 32);
      if (tipPaths != null && !AppDB().isTipDone(tipID)) {
        BlocProvider.of<MainNavigatorBloc>(context)
            .add(MainNavigateToTipEvent(tipID, tipPaths, navigatorEvent(pushAsReplacement: true)));
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
            if (state.nTimelapses == 0) {
              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToTimelapseHowto(state.plant));
            } else {
              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToTimelapseViewer(state.plant));
            }
          },
        ),
      ];
      if (state.box.device != null && _reachable) {
        actions.insert(
            0,
            BlocProvider<SunglassesBloc>(
              create: (BuildContext context) => SunglassesBloc(state.box.device, state.box.deviceBox),
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
      Widget bottom;
      if (state.feedEntry != null) {
        bottom = SingleFeedEntry(
          title: 'Viewing single log entry',
          button: 'View complete diary',
          onTap: () {
            BlocProvider.of<HomeNavigatorBloc>(context).add(HomeNavigateToPlantFeedEvent(state.plant));
          },
        );
      }

      return BlocProvider(
        key: Key('feed'),
        create: (context) => FeedBloc(LocalPlantFeedBlocDelegate(state.plant.feed,
            feedEntryID: state.feedEntry?.id, commentID: state.commentID, replyTo: state.replyTo)),
        child: FeedPage(
          single: state.feedEntry != null,
          color: Color(0xff063047),
          actions: actions,
          bottomPadding: true,
          title: '',
          appBarHeight: 380,
          appBar: _renderAppBar(context, state),
          bottom: bottom,
        ),
      );
    } else if (state is PlantFeedBlocStateNoPlant) {
      return _renderNoPlant(context);
    } else if (state is PlantFeedBlocStatePlantRemoved) {
      return _renderPlantRemoved(context);
    }
    return FullscreenLoading(title: 'Loading plant..');
  }

  Widget _renderPlantRemoved(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Center(
          child: Column(children: [
        Icon(Icons.delete, color: Colors.grey, size: 100),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Plant was removed or archived.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
        ),
        GreenButton(
          title: 'OPEN PLANT LIST',
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
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
                    child: Text('You have no plant yet.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                  Text('Add your first', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  Text('PLANT', style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200, color: Color(0xff3bb30b))),
                ],
              ),
            ),
            GreenButton(
              title: 'START',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreatePlantEvent());
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

  Widget _renderAppBar(BuildContext context, PlantFeedBlocStateLoaded state) {
    String name = state.plant.name;

    Widget nameText;
    if (_showIP) {
      nameText = Column(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
          ),
          Text(_deviceIP,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ))
        ],
      );
    } else {
      nameText = Text(
        name,
        style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w200),
      );
    }
    if (state.box.device != null) {
      nameText = Row(
        children: <Widget>[
          nameText,
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.offline_bolt, color: _reachable ? Colors.green : Colors.grey, size: 20),
          ),
        ],
      );
    }

    List<Widget Function(BuildContext, PlantFeedBlocStateLoaded)> tabs = [
      (c, s) => EnvironmentsPage(s.box, futureFn: futureFn(c, s)),
      _renderPlantInfos,
      _renderProducts,
    ];
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 64.0, top: 12.0),
            child: InkWell(
              onTap: () {
                if (state.box.device == null) {
                  return;
                }
                setState(() {
                  _showIP = !_showIP;
                });
              },
              child: nameText,
            ),
          ),
          Expanded(
            child: Swiper(
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
        ],
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

  void Function(Future<dynamic>) futureFn(BuildContext context, PlantFeedBlocStateLoaded state) {
    return (Future<dynamic> future) async {
      dynamic feedEntry = await future;
      if (feedEntry != null && feedEntry is FeedEntry) {
        BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventFeedEntryCreated(state.plant, feedEntry));
      }
    };
  }
}
