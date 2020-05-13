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
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/feeds/plant_feed/app_bar/plant_feed_app_bar_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feed/app_bar/plant_feed_app_bar_page.dart';
import 'package:super_green_app/pages/feeds/plant_feed/plant_drawer_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feed/plant_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feed/sunglasses_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantFeedPage extends StatefulWidget {
  @override
  _PlantFeedPageState createState() => _PlantFeedPageState();
}

enum SpeedDialType {
  general,
  trainings,
  environment,
}

class _PlantFeedPageState extends State<PlantFeedPage> {
  final _openCloseDial = ValueNotifier<int>(0);
  SpeedDialType _speedDialType = SpeedDialType.general;
  double _onEnvironmentControlWidth = 50;
  bool _speedDialOpen = false;
  bool _showIP = false;
  bool _reachable = false;
  String _deviceIP = '';

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _onEnvironmentControlWidth = 0;
      });
    });
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
                BlocProvider.of<DeviceDaemonBloc>(context)
                    .add(DeviceDaemonBlocEventLoadDevice(state.box.device));
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

            return BlocListener<DeviceDaemonBloc, DeviceDaemonBlocState>(
              listener:
                  (BuildContext context, DeviceDaemonBlocState daemonState) {
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
                  appBar: state is PlantFeedBlocStateNoPlant
                      ? SGLAppBar(
                          'Add new controller',
                          fontSize: 20,
                          backgroundColor: Color(0xff063047),
                          titleColor: Colors.white,
                          iconColor: Colors.white,
                        )
                      : null,
                  drawer: Drawer(child: this._drawerContent(context, state)),
                  body: AnimatedSwitcher(
                      child: body, duration: Duration(milliseconds: 200)),
                  floatingActionButton: state is PlantFeedBlocStateLoaded
                      ? _renderSpeedDial(context, state)
                      : null),
            );
          },
        ),
      ),
    );
  }

  SpeedDial _renderSpeedDial(
      BuildContext context, PlantFeedBlocStateLoaded state) {
    return SpeedDial(
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        marginBottom: 10,
        animationSpeed: 50,
        curve: Curves.bounceIn,
        backgroundColor: Color(0xff3bb30b),
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
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
        ][_speedDialType.index]);
  }

  List<SpeedDialChild> _renderTrimSpeedDials(
      BuildContext context, PlantFeedBlocStateLoaded state) {
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
              ({pushAsReplacement = false}) =>
                  MainNavigateToFeedDefoliationFormEvent(state.plant,
                      pushAsReplacement: pushAsReplacement),
              tipID: 'TIP_DEFOLIATION',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/how_to_defoliate/l/en'
              ])),
      _renderSpeedDialChild(
          'Topping',
          'assets/feed_card/icon_topping.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) =>
                  MainNavigateToFeedToppingFormEvent(state.plant,
                      pushAsReplacement: pushAsReplacement),
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
              ({pushAsReplacement = false}) =>
                  MainNavigateToFeedFimmingFormEvent(state.plant,
                      pushAsReplacement: pushAsReplacement),
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
              ({pushAsReplacement = false}) =>
                  MainNavigateToFeedBendingFormEvent(state.plant,
                      pushAsReplacement: pushAsReplacement),
              tipID: 'TIP_BENDING',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/how_to_low_stress_training_LST/l/en'
              ])),
      _renderSpeedDialChild(
          'Transplant',
          'assets/feed_card/icon_transplant.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) =>
                  MainNavigateToFeedTransplantFormEvent(state.plant,
                      pushAsReplacement: pushAsReplacement),
              tipID: 'TIP_TRANSPLANT',
              tipPaths: [
                't/supergreenlab/SuperGreenTips/master/s/when_to_repot_your_seedling/l/en',
                't/supergreenlab/SuperGreenTips/master/s/how_to_transplant_your_seedling/l/en'
              ])),
    ];
  }

  List<SpeedDialChild> _renderGeneralSpeedDials(
      BuildContext context, PlantFeedBlocStateLoaded state) {
    return [
      _renderSpeedDialChild(
          'Grow log',
          'assets/feed_card/icon_media.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedMediaFormEvent(
                  state.plant,
                  pushAsReplacement: pushAsReplacement))),
      _renderSpeedDialChild(
          'Measure',
          'assets/feed_card/icon_measure.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) =>
                  MainNavigateToFeedMeasureFormEvent(state.plant,
                      pushAsReplacement: pushAsReplacement))),
      _renderSpeedDialChild(
          'Watering',
          'assets/feed_card/icon_watering.svg',
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) => MainNavigateToFeedWaterFormEvent(
                  state.plant,
                  pushAsReplacement: pushAsReplacement),
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
    ];
  }

  SpeedDialChild _renderSpeedDialChild(
      String label, String icon, void Function() navigateTo) {
    return SpeedDialChild(
      child: SvgPicture.asset(icon),
      label: label,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      onTap: navigateTo,
    );
  }

  void Function() _onSpeedDialSelected(BuildContext context,
      MainNavigatorEvent Function({bool pushAsReplacement}) navigatorEvent,
      {String tipID, List<String> tipPaths}) {
    return () {
      _openCloseDial.value = Random().nextInt(1 << 32);
      if (tipPaths != null && !AppDB().isTipDone(tipID)) {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToTipEvent(
            tipID, tipPaths, navigatorEvent(pushAsReplacement: true)));
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
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToTimelapseHowto(state.plant));
            } else {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigateToTimelapseViewer(state.plant));
            }
          },
        ),
      ];
      if (state.box.device != null && _reachable) {
        actions.insert(
            0,
            BlocProvider<SunglassesBloc>(
              create: (BuildContext context) =>
                  SunglassesBloc(state.box.device, state.box.deviceBox),
              child: BlocBuilder<SunglassesBloc, SunglassesBlocState>(
                builder: (BuildContext context, SunglassesBlocState state) {
                  if (state is SunglassesBlocStateLoaded) {
                    return Opacity(
                      opacity: state.sunglassesOn ? 0.5 : 1,
                      child: IconButton(
                        icon:
                            SvgPicture.asset('assets/home/icon_sunglasses.svg'),
                        tooltip: 'Sunglasses mode',
                        onPressed: () {
                          BlocProvider.of<SunglassesBloc>(context)
                              .add(SunglassesBlocEventOnOff());
                        },
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ));
      }
      return BlocProvider(
        key: Key('feed'),
        create: (context) => LocalFeedBloc(state.plant.feed),
        child: FeedPage(
          color: Color(0xff063047),
          actions: actions,
          bottomPadding: true,
          title: '',
          appBarHeight: 300,
          appBar: _renderAppBar(context, state),
        ),
      );
    } else if (state is PlantFeedBlocStateNoPlant) {
      return _renderNoPlant(context);
    }
    return FullscreenLoading(title: 'Loading plant..');
  }

  Widget _renderNoPlant(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text('You have no plant yet.',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                  Text('Add your first',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  Text('PLANT',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w200,
                          color: Color(0xff3bb30b))),
                ],
              ),
            ),
            GreenButton(
              title: 'START',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigateToCreatePlantEvent());
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
          child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: Colors.white60),
        );
      },
    );
  }

  Widget _drawerContent(BuildContext context, PlantFeedBlocState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: Color(0xff063047),
          height: 120,
          child: DrawerHeader(
              child: Row(children: <Widget>[
            SizedBox(
              width: 50,
              height: 50,
              child:
                  SvgPicture.asset("assets/super_green_lab_vertical_white.svg"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Plant list',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300)),
            ),
          ])),
        ),
        Expanded(
          child: _plantList(context, state),
        ),
        Divider(),
        Container(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.add_circle),
                        title: Text('Add new plant'),
                        onTap: () => _onAddPlant(context)),
                  ],
                ))))
      ],
    );
  }

  Widget _plantList(BuildContext context, PlantFeedBlocState plantFeedState) {
    return BlocBuilder<PlantDrawerBloc, PlantDrawerBlocState>(
      bloc: BlocProvider.of<PlantDrawerBloc>(context),
      condition: (previousState, state) =>
          state is PlantDrawerBlocStateLoadingPlantList ||
          state is PlantDrawerBlocStatePlantListUpdated,
      builder: (BuildContext context, PlantDrawerBlocState state) {
        Widget content;
        if (state is PlantDrawerBlocStateLoadingPlantList) {
          content = FullscreenLoading(title: 'Loading..');
        } else if (state is PlantDrawerBlocStatePlantListUpdated) {
          List<Plant> plants = state.plants.toList();
          List<Box> boxes = state.boxes;
          content = ListView(
              children: boxes.map((b) {
            List<Widget> content = [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                        offset: Offset(0, 2))
                  ],
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: SvgPicture.asset('assets/settings/icon_lab.svg'),
                  title: Text(b.name),
                ),
              ),
            ];
            content.addAll(plants.where((p) => p.box == b.id).map((p) {
              Widget item = Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: (plantFeedState is PlantFeedBlocStateLoaded &&
                            plantFeedState.plant.id == p.id)
                        ? Icon(
                            Icons.check_box,
                            color: Colors.green,
                          )
                        : Icon(Icons.crop_square),
                    title: Text(p.name),
                    onTap: () => _selectPlant(context, p),
                  ));
              try {
                int nOthers = state.hasPending
                    .where((e) => e.id == p.feed)
                    .map<int>((e) => int.parse(e.nNew))
                    .reduce((a, e) => a + e);
                if (nOthers != null && nOthers > 0) {
                  item = Stack(
                    children: [
                      item,
                      _renderBadge(nOthers),
                    ],
                  );
                }
              } catch (e) {}
              return item;
            }).toList());
            return Column(
              children: content,
            );
          }).toList());
        }
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: content,
        );
      },
    );
  }

  Widget _renderBadge(int n) {
    return Positioned(
      top: 12,
      right: 10,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        constraints: BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        child: Text(
          '$n',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _selectPlant(BuildContext context, Plant plant) {
    //ignore: close_sinks
    HomeNavigatorBloc navigatorBloc =
        BlocProvider.of<HomeNavigatorBloc>(context);
    Navigator.pop(context);
    Timer(Duration(milliseconds: 250),
        () => navigatorBloc.add(HomeNavigateToPlantFeedEvent(plant)));
  }

  void _onAddPlant(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToCreatePlantEvent());
  }

  Widget _renderAppBar(BuildContext context, PlantFeedBlocStateLoaded state) {
    String name = state.plant.name;

    Widget graphBody;
    if (state.box.device != null) {
      graphBody = _renderGraphs(context, state);
    } else {
      graphBody = Stack(children: [
        _renderGraphs(context, state),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white.withAlpha(190)),
          child: Fullscreen(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            title: 'Monitoring feature\nrequires an SGL controller',
            child: Row(
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
                  child:
                      Text('or', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                GreenButton(
                  title: 'DIY NOW',
                  onPressed: () {
                    launch('https://github.com/supergreenlab');
                  },
                ),
              ],
            ),
            childFirst: false,
          ),
        ),
      ]);
    }

    graphBody = GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          _onEnvironmentControlWidth =
              max(0, min(50, _onEnvironmentControlWidth - details.delta.dx));
        });
      },
      child: Row(
        children: <Widget>[
          Expanded(child: graphBody),
          AnimatedContainer(
            width: _onEnvironmentControlWidth,
            child:
                Stack(children: [_renderEnvironmentControls(context, state)]),
            duration: Duration(milliseconds: 200),
          ),
        ],
      ),
    );

    Widget nameText;
    if (_reachable && _showIP) {
      nameText = Column(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.normal),
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
        style: TextStyle(
            color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w200),
      );
    }
    if (state.box.device != null) {
      nameText = Row(
        children: <Widget>[
          nameText,
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.offline_bolt,
                color: _reachable ? Colors.green : Colors.grey, size: 20),
          ),
        ],
      );
    }
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
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: graphBody),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderGraphs(BuildContext context, PlantFeedBlocStateLoaded state) {
    return BlocProvider(
      create: (context) => PlantFeedAppBarBloc(state.plant),
      child: PlantFeedAppBarPage(),
    );
  }

  Widget _renderEnvironmentControls(
      BuildContext context, PlantFeedBlocStateLoaded state) {
    return Column(
      children: <Widget>[
        _renderEnvironmentControl(
            context,
            'assets/feed_card/icon_dimming.svg',
            _onEnvironmentControlTapped(
                context,
                ({pushAsReplacement = false}) =>
                    MainNavigateToFeedLightFormEvent(state.plant,
                        pushAsReplacement: pushAsReplacement),
                tipID: 'TIP_STRETCH',
                tipPaths: [
                  't/supergreenlab/SuperGreenTips/master/s/when_to_control_stretch_in_seedling/l/en',
                  't/supergreenlab/SuperGreenTips/master/s/how_to_control_stretch_in_seedling/l/en'
                ])),
        _renderEnvironmentControl(
            context,
            'assets/feed_card/icon_blower.svg',
            _onEnvironmentControlTapped(
                context,
                ({pushAsReplacement = false}) =>
                    MainNavigateToFeedVentilationFormEvent(state.plant,
                        pushAsReplacement: pushAsReplacement))),
        _renderEnvironmentControl(
            context,
            'assets/feed_card/icon_schedule.svg',
            _onEnvironmentControlTapped(
                context,
                ({pushAsReplacement = false}) =>
                    MainNavigateToFeedScheduleFormEvent(state.plant,
                        pushAsReplacement: pushAsReplacement),
                tipID: 'TIP_BLOOM',
                tipPaths: [
                  't/supergreenlab/SuperGreenTips/master/s/when_to_switch_to_bloom/l/en'
                ])),
      ],
    );
  }

  Widget _renderEnvironmentControl(
      BuildContext context, String icon, void Function() navigateTo) {
    return InkWell(
      onTap: navigateTo,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: SvgPicture.asset(icon,
                width: 40, height: 40, fit: BoxFit.contain)),
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
}
