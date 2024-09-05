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

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/device_daemon/device_reachable_listener_bloc.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/form/feed_light_form_bloc.dart';
import 'package:super_green_app/widgets/feed_form/feed_form_layout.dart';
import 'package:super_green_app/widgets/feed_form/slider_form_param.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedLightFormPage extends StatefulWidget {
  static String get feedLightFormPageSaving {
    return Intl.message(
      'Saving..',
      name: 'feedLightFormPageSaving',
      desc: 'Fullscreen loading',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedLightFormPageCancelling {
    return Intl.message(
      'Cancelling..',
      name: 'feedLightFormPageCancelling',
      desc: 'Fullscreen message when resetting all parameters',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedLightFormPageControllerRequired {
    return Intl.message(
      'Dimming control\nrequires an SGL controller',
      name: 'feedLightFormPageControllerRequired',
      desc: 'Fullscreen message displayed with no controller is available for light control',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedLightFormPageShopNow {
    return Intl.message(
      'SHOP NOW',
      name: 'feedLightFormPageShopNow',
      desc: 'Shop now button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedLightFormPageDIYNow {
    return Intl.message(
      'DIY NOW',
      name: 'feedLightFormPageDIYNow',
      desc: 'DIY now button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get feedLightFormPageOr {
    return Intl.message(
      'or',
      name: 'feedLightFormPageOr',
      desc: 'The "or" in "Shop now or diy"',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  _FeedLightFormPageState createState() => _FeedLightFormPageState();
}

class _FeedLightFormPageState extends State<FeedLightFormPage> {
  List<BoxLight> initialValues = [];
  List<BoxLight> values = [];
  int loading = -1;
  bool _reachable = true;
  bool _usingWifi = false;
  bool changed = false;
  double masterValue = 0.0;
  double initialMasterValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<FeedLightFormBloc>(context),
      listener: (BuildContext context, FeedLightFormBlocState state) {
        if (state is FeedLightFormBlocStateLightsLoaded) {
          Timer(Duration(milliseconds: 100), () {
            BlocProvider.of<DeviceReachableListenerBloc>(context)
                .add(DeviceReachableListenerBlocEventLoadDevice(state.box.device!));
          });
          setState(() {
            values = List.from(state.values);
            _updateMasterValue();
          });
        } else if (state is FeedLightFormBlocStateLightsLoading) {
          setState(() {
            loading = state.index;
          });
        } else if (state is FeedLightFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(mustPop: true, param: state.feedEntry));
        }
      },
      child: BlocBuilder<FeedLightFormBloc, FeedLightFormBlocState>(
          bloc: BlocProvider.of<FeedLightFormBloc>(context),
          buildWhen: (FeedLightFormBlocState oldState, FeedLightFormBlocState newState) {
            return !(newState is FeedLightFormBlocStateLightsLoading);
          },
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is FeedLightFormBlocStateLoading) {
              body = FullscreenLoading(title: FeedLightFormPage.feedLightFormPageSaving);
            } else if (state is FeedLightFormBlocStateCancelling) {
              body = FullscreenLoading(title: FeedLightFormPage.feedLightFormPageCancelling);
            } else if (state is FeedLightFormBlocStateNoDevice) {
              body = Stack(
                children: <Widget>[
                  ListView.builder(
                    itemCount: values.length,
                    itemBuilder: _renderLightParam,
                  ),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white60),
                    child: Fullscreen(
                      title: FeedLightFormPage.feedLightFormPageControllerRequired,
                      child: Column(
                        children: <Widget>[
                          GreenButton(
                            title: FeedLightFormPage.feedLightFormPageShopNow,
                            onPressed: () {
                              launchUrl(Uri.parse('https://www.supergreenlab.com/bundle/micro-box-bundle'));
                            },
                          ),
                          Text(FeedLightFormPage.feedLightFormPageOr),
                          GreenButton(
                            title: FeedLightFormPage.feedLightFormPageDIYNow,
                            onPressed: () {
                              launchUrl(Uri.parse('https://picofarmled.com/guide/how-to-setup-pico-farm-os'));
                            },
                          ),
                        ],
                      ),
                      childFirst: false,
                    ),
                  ),
                ],
              );
            } else if (state is FeedLightFormBlocStateLightsLoaded) {
              Widget content = Column(
                children: [
                  if (values.length > 1) _renderMasterLightControl(context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: values.length,
                      itemBuilder: _renderLightParam,
                    ),
                  ),
                ],
              );
              if (_reachable == false) {
                String title = 'Looking for device..';
                if (_usingWifi == false) {
                  title = 'Device unreachable!\n(You\'re not connected to any wifi)';
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
                                child: Container(width: 50, height: 50, child: CircularProgressIndicator()),
                              )),
                  ],
                );
              }
              body = BlocListener<DeviceReachableListenerBloc, DeviceReachableListenerBlocState>(
                  listener: (BuildContext context, DeviceReachableListenerBlocState listenerState) {
                    if (listenerState is DeviceReachableListenerBlocStateDeviceReachable &&
                        listenerState.device.id == state.box.device) {
                      if (_reachable == listenerState.reachable && _usingWifi == listenerState.usingWifi) return;
                      setState(() {
                        _reachable = listenerState.reachable;
                        _usingWifi = listenerState.usingWifi;
                      });
                    }
                  },
                  child: content);
            }
            return FeedFormLayout(
              title: '⛅',
              fontSize: 35,
              changed: changed,
              valid: changed && _reachable,
              hideBackButton: ((_reachable == false && changed) ||
                  state is FeedLightFormBlocStateLoading ||
                  state is FeedLightFormBlocStateCancelling),
              onOK: () {
                BlocProvider.of<FeedLightFormBloc>(context).add(FeedLightFormBlocEventCreate(values));
              },
              body: WillPopScope(
                onWillPop: () async {
                  if (_reachable == false && changed) {
                    return false;
                  }
                  if (state is FeedLightFormBlocStateNoDevice) {
                    return true;
                  }
                  if (changed) {
                    BlocProvider.of<FeedLightFormBloc>(context).add(FeedLightFormBlocEventCancel());
                    return false;
                  }
                  return true;
                },
                child: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body),
              ),
            );
          }),
    );
  }

  Widget _renderMasterLightControl(BuildContext context) {
    return SliderFormParam(
      key: Key('master'),
      title: 'Master Light Control',
      boldTitle: true,
      icon: 'assets/feed_form/icon_sun.svg',
      value: masterValue.round().toDouble(),
      color: _color(masterValue.toInt()),
      loading: false,
      disable: loading != -1,
      onChangeStart: (double startValue) {
        initialMasterValue = masterValue;
        initialValues = List.from(values);
      },
      onChanged: (double newValue) {
        setState(() {
          if (initialMasterValue != 0) {
            double ratio = newValue / initialMasterValue;
            for (int i = 0; i < values.length; i++) {
              int newLightValue = min(100, max(0, (initialValues[i].value.ivalue! * ratio).round()));
              print(newValue);
              if (newValue >= 99) {
                newLightValue = newValue.round();
              }
              if (initialValues[i].value.ivalue! == 0) {
                newLightValue = newValue.round();
              }
              BoxLight newBoxLight = values[i].copyWith(
                value: values[i].value.copyWith(ivalue: drift.Value(newLightValue)),
              );
              values[i] = newBoxLight;
            }
          } else {
           for (int i = 0; i < values.length; i++) {
              BoxLight newBoxLight = values[i].copyWith(
                value: values[i].value.copyWith(ivalue: drift.Value(newValue.round())),
              );
              values[i] = newBoxLight;
            }
          }
          masterValue = newValue;
          changed = true;
        });
      },
      onChangeEnd: (double value) {
        for (int i = 0; i < values.length; i++) {
          BlocProvider.of<FeedLightFormBloc>(context).add(
            FeedLightFormBlocValueChangedEvent(i, values[i].value.ivalue!),
          );
        }
        this._updateMasterValue();
      },
    );
  }

  Widget _renderLightParam(BuildContext context, int i) {
    return SliderFormParam(
      key: Key('$i'),
      title: values[i].lightSettings.name ?? 'Light ${i + 1}',
      onTitleEdited: (String newTitle) {
        BoxLight newBoxLight = values[i].copyWith(lightSettings: values[i].lightSettings.copyWith(name: newTitle));
        setState(() {
          values[i] = newBoxLight;
        });
        BlocProvider.of<FeedLightFormBloc>(context)
            .add(FeedLightFormBlocLightSettingsChangedEvent(i, newBoxLight.lightSettings));
      },
      icon: 'assets/feed_form/icon_${values[i].value.ivalue! > 30 ? "sun" : "moon"}.svg',
      value: values[i].value.ivalue!.toDouble(),
      color: _color(values[i].value.ivalue!),
      loading: loading == i,
      disable: loading != -1 && loading != i,
      onChanged: (double newValue) {
        setState(() {
          BoxLight newBoxLight =
              values[i].copyWith(value: values[i].value.copyWith(ivalue: drift.Value(newValue.toInt())));
          values[i] = newBoxLight;
          changed = true;
          _updateMasterValue();
        });
      },
      onChangeEnd: (double value) {
        BlocProvider.of<FeedLightFormBloc>(context).add(FeedLightFormBlocValueChangedEvent(i, value.round()));
      },
    );
  }

  void _updateMasterValue() {
    double sum = values.fold(0, (sum, light) => sum + light.value.ivalue!);
    masterValue = sum / values.length;
  }

  Color _color(int value) {
    if (value > 60) {
      return Colors.yellow;
    } else if (value > 30) {
      return Colors.orange;
    }
    return Colors.blue;
  }
}
