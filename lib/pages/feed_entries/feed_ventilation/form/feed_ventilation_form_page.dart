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
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/device_daemon/device_reachable_listener_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_humidity_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_manual_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_legacy_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_temperature_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_timer_form_page.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedVentilationFormPage extends TraceableStatefulWidget {
  @override
  _FeedVentilationFormPageState createState() =>
      _FeedVentilationFormPageState();
}

class _FeedVentilationFormPageState extends State<FeedVentilationFormPage> {
  bool _reachable = true;
  bool _usingWifi = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<FeedVentilationFormBloc>(context),
      listener: (BuildContext context, FeedVentilationFormBlocState state) {
        if (state is FeedVentilationFormBlocStateLoaded) {
          if (state.box.device != null) {
            Timer(Duration(milliseconds: 100), () {
              BlocProvider.of<DeviceReachableListenerBloc>(context).add(
                  DeviceReachableListenerBlocEventLoadDevice(state.box.device));
            });
          }
        } else if (state is FeedVentilationFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(mustPop: true));
        }
      },
      child: BlocBuilder<FeedVentilationFormBloc, FeedVentilationFormBlocState>(
          bloc: BlocProvider.of<FeedVentilationFormBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is FeedVentilationFormBlocStateInit) {
              body = FullscreenLoading(title: 'Loading..');
            } else if (state is FeedVentilationFormBlocStateLoading) {
              body = FullscreenLoading(title: state.text);
            } else if (state is FeedVentilationFormBlocStateLoaded &&
                state.noDevice == true) {
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
                String title = 'Looking for device..';
                if (_usingWifi == false) {
                  title =
                      'Device unreachable!\n(You\'re not connected to any wifi)';
                }
                content = Stack(
                  children: <Widget>[
                    content,
                    Fullscreen(
                        title: title,
                        backgroundColor: Colors.white54,
                        child: _usingWifi == false
                            ? Icon(Icons.error, color: Colors.red, size: 100)
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator()),
                              )),
                  ],
                );
              }
              body = BlocListener<DeviceReachableListenerBloc,
                      DeviceReachableListenerBlocState>(
                  listener: (BuildContext context,
                      DeviceReachableListenerBlocState reachableState) {
                    if (reachableState
                            is DeviceReachableListenerBlocStateDeviceReachable &&
                        reachableState.device.id == state.box.device) {
                      if (_reachable == reachableState.reachable &&
                          _usingWifi == reachableState.usingWifi) return;
                      setState(() {
                        _reachable = reachableState.reachable;
                        _usingWifi = reachableState.usingWifi;
                      });
                    }
                  },
                  child: content);
            }
            bool changed = state is FeedVentilationFormBlocStateLoaded &&
                (state.blowerMin?.isChanged == true ||
                    state.blowerMax?.isChanged == true ||
                    state.blowerRefMin?.isChanged == true ||
                    state.blowerRefMax?.isChanged == true ||
                    state.blowerRefSource?.isChanged == true ||
                    state.blowerDay?.isChanged == true ||
                    state.blowerNight?.isChanged == true);
            return FeedFormLayout(
                title: '💨',
                fontSize: 35,
                changed: changed,
                valid: changed && _reachable,
                hideBackButton: ((_reachable == false && changed) ||
                    state is FeedVentilationFormBlocStateLoading),
                onOK: () {
                  BlocProvider.of<FeedVentilationFormBloc>(context)
                      .add(FeedVentilationFormBlocEventCreate());
                },
                body: WillPopScope(
                  onWillPop: () async {
                    if (_reachable == false && changed) {
                      return false;
                    }
                    if (state is FeedVentilationFormBlocStateLoaded &&
                        state.noDevice == true) {
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
      BuildContext context, FeedVentilationFormBlocStateLoaded state) {
    if (state.isLegacy) {
      return FeedVentilationLegacyFormPage(state);
    }
    return _renderV3Params(context, state);
  }

  Widget _renderV3Params(
      BuildContext context, FeedVentilationFormBlocStateLoaded state) {
    Widget body;
    if (isTimerSource(state.blowerRefSource.value)) {
      body = FeedVentilationTimerFormPage(state);
    } else if (isTempSource(state.blowerRefSource.value)) {
      body = FeedVentilationTemperatureFormPage(state);
    } else if (isHumiSource(state.blowerRefSource.value)) {
      body = FeedVentilationHumidityFormPage(state);
    } else if (state.blowerRefSource.value == 0) {
      body = FeedVentilationManualFormPage(state);
    } else {
      body = Fullscreen(
        child: Icon(Icons.upgrade),
        title:
            'Unknown blower reference source, you might need to upgrade the app.',
      );
    }
    List<bool> selection = [
      isTimerSource(state.blowerRefSource.value),
      state.blowerRefSource.value == 0,
      isTempSource(state.blowerRefSource.value),
      isHumiSource(state.blowerRefSource.value),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: ToggleButtons(
          children: <Widget>[
            Icon(Icons.timer),
            Icon(Icons.touch_app),
            Icon(Icons.device_thermostat),
            Icon(Icons.cloud),
          ],
          onPressed: (int index) {
            _changeRefSource(context, state, index);
          },
          isSelected: selection,
        ),
      )),
      Expanded(
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200), child: body))
    ]);
  }

  void _changeRefSource(BuildContext context,
      FeedVentilationFormBlocStateLoaded state, int index) async {
    List<String> modeNames = [
      'Timer mode',
      'Manual mode',
      'Temperature mode',
      'Humidity mode',
    ];
    List<FeedVentilationFormBlocParamsChangedEvent Function()> eventFactory = [
      () => FeedVentilationFormBlocParamsChangedEvent(
            blowerRefMin: state.blowerRefMin.copyWith(value: 0),
            blowerRefMax: state.blowerRefMax.copyWith(value: 100),
            blowerRefSource: state.blowerRefSource
                .copyWith(value: TIMER_REF_OFFSET + state.box.deviceBox),
          ),
      () => FeedVentilationFormBlocParamsChangedEvent(
            blowerRefMin: state.blowerRefMin.copyWith(value: 0),
            blowerRefMax: state.blowerRefMax.copyWith(value: 100),
            blowerRefSource: state.blowerRefSource.copyWith(value: 0),
          ),
      () => FeedVentilationFormBlocParamsChangedEvent(
            blowerRefMin: state.blowerRefMin.copyWith(value: 21),
            blowerRefMax: state.blowerRefMax.copyWith(value: 30),
            blowerRefSource: state.blowerRefSource
                .copyWith(value: TEMP_REF_OFFSET + state.box.deviceBox),
          ),
      () => FeedVentilationFormBlocParamsChangedEvent(
            blowerRefMin: state.blowerRefMin.copyWith(value: 35),
            blowerRefMax: state.blowerRefMax.copyWith(value: 70),
            blowerRefSource: state.blowerRefSource
                .copyWith(value: HUMI_REF_OFFSET + state.box.deviceBox),
          ),
    ];
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Change to ${modeNames[index]}?'),
            content: Text(
                'This might override some values, but you can always cancel the changes with the arrow top left, continue?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<FeedVentilationFormBloc>(context)
          .add(eventFactory[index]());
    }
  }
}
