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
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/slider_form_param.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedVentilationFormPage extends StatefulWidget {
  @override
  _FeedVentilationFormPageState createState() =>
      _FeedVentilationFormPageState();
}

class _FeedVentilationFormPageState extends State<FeedVentilationFormPage> {
  int _blowerDay = 0;
  int _blowerNight = 0;
  bool _reachable = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<FeedVentilationFormBloc>(context),
      listener: (BuildContext context, FeedVentilationFormBlocState state) {
        if (state is FeedVentilationFormBlocStateLoaded) {
          if (state.box.device != null) {
            BlocProvider.of<DeviceDaemonBloc>(context)
                .add(DeviceDaemonBlocEventLoadDevice(state.box.device));
          }
          setState(() {
            _blowerDay = state.blowerDay;
            _blowerNight = state.blowerNight;
          });
        } else if (state is FeedVentilationFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(mustPop: true));
        }
      },
      child: BlocBuilder<FeedVentilationFormBloc, FeedVentilationFormBlocState>(
          bloc: BlocProvider.of<FeedVentilationFormBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is FeedVentilationFormBlocStateLoading) {
              body = FullscreenLoading(title: state.text);
            } else if (state is FeedVentilationFormBlocStateNoDevice) {
              body = Stack(
                children: <Widget>[
                  _renderParams(context, state),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white60),
                    child: Fullscreen(
                      title: 'Ventilation control\nrequires an SGL controller',
                      child: Column(
                        children: <Widget>[
                          GreenButton(
                            title: 'SHOP NOW',
                            onPressed: () {
                              launch('https://www.supergreenlab.com');
                            },
                          ),
                          Text('or'),
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
                ],
              );
            } else if (state is FeedVentilationFormBlocStateLoaded) {
              Widget content = _renderParams(context, state);
              if (_reachable == false) {
                content = Stack(
                  children: <Widget>[
                    content,
                    Fullscreen(
                        title: 'Device unreachable!',
                        backgroundColor: Colors.white54,
                        child: Icon(Icons.error, color: Colors.red, size: 100)),
                  ],
                );
              }
              body = BlocListener<DeviceDaemonBloc, DeviceDaemonBlocState>(
                  listener: (BuildContext context,
                      DeviceDaemonBlocState daemonState) {
                    if (daemonState is DeviceDaemonBlocStateDeviceReachable &&
                        daemonState.device.id == state.box.device) {
                      if (_reachable == daemonState.reachable) return;
                      setState(() {
                        _reachable = daemonState.reachable;
                      });
                    }
                  },
                  child: content);
            }
            bool changed = state is FeedVentilationFormBlocStateLoaded &&
                (state.blowerDay != state.initialBlowerDay ||
                    state.blowerNight != state.initialBlowerNight);
            return FeedFormLayout(
                title: '💨',
                fontSize: 35,
                changed: changed,
                valid: changed && _reachable,
                hideBackButton: (_reachable == false ||
                    state is FeedVentilationFormBlocStateLoading),
                onOK: () {
                  BlocProvider.of<FeedVentilationFormBloc>(context).add(
                      FeedVentilationFormBlocEventCreate(
                          _blowerDay, _blowerNight));
                },
                body: WillPopScope(
                  onWillPop: () async {
                    if (_reachable == false) {
                      return false;
                    }
                    if (state is FeedVentilationFormBlocStateNoDevice) {
                      return true;
                    }
                    if (changed) {
                      BlocProvider.of<FeedVentilationFormBloc>(context)
                          .add(FeedVentilationFormBlocEventCancelEvent());
                      return false;
                    }
                    return true;
                  },
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200), child: body),
                ));
          }),
    );
  }

  Widget _renderParams(
      BuildContext context, FeedVentilationFormBlocState state) {
    return ListView(
      children: [
        SliderFormParam(
          key: Key('day'),
          title: 'Blower day',
          icon: 'assets/feed_form/icon_blower.svg',
          value: _blowerDay.toDouble(),
          min: 0,
          max: 100,
          color: Colors.yellow,
          onChanged: (double newValue) {
            setState(() {
              _blowerDay = newValue.toInt();
            });
          },
          onChangeEnd: (double newValue) {
            BlocProvider.of<FeedVentilationFormBloc>(context).add(
                FeedVentilationFormBlocBlowerDayChangedEvent(newValue.toInt()));
          },
        ),
        SliderFormParam(
          key: Key('night'),
          title: 'Blower night',
          icon: 'assets/feed_form/icon_blower.svg',
          value: _blowerNight.toDouble(),
          min: 0,
          max: 60,
          color: Colors.blue,
          onChanged: (double newValue) {
            setState(() {
              _blowerNight = newValue.toInt();
            });
          },
          onChangeEnd: (double newValue) {
            BlocProvider.of<FeedVentilationFormBloc>(context).add(
                FeedVentilationFormBlocBlowerNightChangedEvent(
                    newValue.toInt()));
          },
        ),
      ],
    );
  }
}
