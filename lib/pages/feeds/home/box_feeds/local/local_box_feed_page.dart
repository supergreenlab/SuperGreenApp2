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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/device_daemon/device_reachable_listener_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/feed_entry_assets.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/feeds/home/box_feeds/local/local_box_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/home/box_feeds/local/local_box_feed_delegate.dart';
import 'package:super_green_app/pages/feeds/home/common/drawer/plant_drawer_page.dart';
import 'package:super_green_app/pages/feeds/home/common/app_bar/environment/environments_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/sunglasses_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/local/widgets/plant_dial_button.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

enum SpeedDialType {
  general,
  trainings,
  lifeevents,
}

class LocalBoxFeedPage extends StatefulWidget {
  @override
  _LocalBoxFeedPageState createState() => _LocalBoxFeedPageState();
}

class _LocalBoxFeedPageState extends State<LocalBoxFeedPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _openCloseDial = ValueNotifier<int>(0);
  SpeedDialType _speedDialType = SpeedDialType.general;

  bool _speedDialOpen = false;
  bool _showIP = false;
  bool _reachable = false;
  bool _remote = false;
  String _deviceIP = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalBoxFeedBloc, LocalBoxFeedBlocState>(
      listener: (BuildContext context, LocalBoxFeedBlocState state) {
        if (state is LocalBoxFeedBlocStateLoaded) {
          if (state.box?.device != null) {
            // TODO find something better than this
            Timer(Duration(milliseconds: 100), () {
              BlocProvider.of<DeviceReachableListenerBloc>(context)
                  .add(DeviceReachableListenerBlocEventLoadDevice(state.box!.device!));
            });
          }
        }
      },
      child: BlocBuilder<LocalBoxFeedBloc, LocalBoxFeedBlocState>(
        bloc: BlocProvider.of<LocalBoxFeedBloc>(context),
        builder: (BuildContext context, LocalBoxFeedBlocState state) {
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
              if (state is LocalBoxFeedBlocStateLoaded) {
                if (reachableState is DeviceReachableListenerBlocStateDeviceReachable &&
                    reachableState.device.id == state.box!.device) {
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
                appBar: state is LocalBoxFeedBlocStateBoxRemoved
                    ? SGLAppBar(
                        'Box feed',
                        fontSize: 20,
                        backgroundColor: Color(0xff063047),
                        titleColor: Colors.white,
                        iconColor: Colors.white,
                      )
                    : null,
                drawer: Drawer(
                    child: PlantDrawerPage(
                  selectedBox: state is LocalBoxFeedBlocStateLoaded ? state.box : null,
                )),
                body: AnimatedSwitcher(child: body, duration: Duration(milliseconds: 200)),
                floatingActionButton: state is LocalBoxFeedBlocStateLoaded ? _renderSpeedDial(context, state) : null),
          );
        },
      ),
    );
  }

  SpeedDial _renderSpeedDial(BuildContext context, LocalBoxFeedBlocStateLoaded state) {
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
          _renderGeneralSpeedDials(context, state),
        ][_speedDialType.index]);
  }

  List<SpeedDialChild> _renderGeneralSpeedDials(BuildContext context, LocalBoxFeedBlocStateLoaded state) {
    return [
      _renderSpeedDialChild(
          'Build log',
          FeedEntryIcons[FE_MEDIA]!,
          _onSpeedDialSelected(
              context,
              ({pushAsReplacement = false}) =>
                  MainNavigateToFeedMediaFormEvent(box: state.box, pushAsReplacement: pushAsReplacement))),
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

  Widget _renderFeed(BuildContext context, LocalBoxFeedBlocState state) {
    if (state is LocalBoxFeedBlocStateLoaded) {
      if (state.box!.feed == null) {
        return _renderBoxNotCreated(context);
      }
      List<Widget> actions = [];
      if (state.box!.device != null && _reachable) {
        actions.insert(
            0,
            BlocProvider<SunglassesBloc>(
              create: (BuildContext context) => SunglassesBloc(state.box!.device!, state.box!.deviceBox!),
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
      return BlocProvider(
        key: Key('feed'),
        create: (context) => FeedBloc(LocalBoxFeedBlocDelegate(state.box!.feed!)),
        child: FeedPage(
          automaticallyImplyLeading: true,
          color: Color(0xff063047),
          actions: actions,
          bottomPadding: true,
          title: '',
          appBarHeight: 350,
          appBar: _renderAppBar(context, state),
        ),
      );
    } else if (state is LocalBoxFeedBlocStateBoxRemoved) {
      return _renderBoxRemoved(context);
    }
    return FullscreenLoading(title: 'Loading box..');
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

  Widget _renderBoxNotCreated(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Center(
          child: Column(children: [
        Icon(Icons.add, color: Colors.grey, size: 100),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child:
              Text('You can now create a box diary too!', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
        ),
        GreenButton(
          title: 'CREATE DIARY',
          onPressed: () {
            BlocProvider.of<LocalBoxFeedBloc>(context).add(LocalBoxFeedBlocEventCreateFeed());
          },
        ),
      ]))
    ]);
  }

  Widget _renderBoxRemoved(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Center(
          child: Column(children: [
        Icon(Icons.delete, color: Colors.grey, size: 100),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Box was removed or archived.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
        ),
        GreenButton(
          title: 'OPEN PLANT LIST',
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ]))
    ]);
  }

  Widget _renderAppBar(BuildContext context, LocalBoxFeedBlocStateLoaded state) {
    String name = state.box!.name;

    Widget nameText;
    if (_showIP) {
      nameText = Column(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),
          ),
          Text(_remote ? 'Remote controled!' : _deviceIP,
              style: TextStyle(
                fontSize: 10,
                color: _remote ? Color(0xff3bb30b) : Colors.grey,
              ))
        ],
      );
    } else {
      nameText = Text(
        name,
        style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w200),
      );
    }
    if (state.box?.device != null) {
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

    List<Widget Function()> tabs = [
      () => EnvironmentsPage(state.box!),
    ];
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 64.0, top: 12.0),
            child: InkWell(
              onTap: () {
                if (state.box?.device == null) {
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
                return tabs[index]();
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
}
