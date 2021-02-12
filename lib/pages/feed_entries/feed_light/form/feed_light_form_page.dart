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
import 'package:intl/intl.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
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
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLightFormPageCancelling {
    return Intl.message(
      'Cancelling..',
      name: 'feedLightFormPageCancelling',
      desc: 'Fullscreen message when resetting all parameters',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLightFormPageControllerRequired {
    return Intl.message(
      'Dimming control\nrequires an SGL controller',
      name: 'feedLightFormPageControllerRequired',
      desc: 'Fullscreen message displayed with no controller is available for light control',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLightFormPageShopNow {
    return Intl.message(
      'SHOP NOW',
      name: 'feedLightFormPageShopNow',
      desc: 'Shop now button',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLightFormPageDIYNow {
    return Intl.message(
      'DIY NOW',
      name: 'feedLightFormPageDIYNow',
      desc: 'DIY now button',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get feedLightFormPageOr {
    return Intl.message(
      'or',
      name: 'feedLightFormPageOr',
      desc: 'The "or" in "Shop now or diy"',
      locale: SGLLocalizations.current.localeName,
    );
  }

  @override
  _FeedLightFormPageState createState() => _FeedLightFormPageState();
}

class _FeedLightFormPageState extends State<FeedLightFormPage> {
  List<int> values = List();
  bool _reachable = true;
  bool _usingWifi = false;

  bool changed = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: BlocProvider.of<FeedLightFormBloc>(context),
      listener: (BuildContext context, FeedLightFormBlocState state) {
        if (state is FeedLightFormBlocStateLightsLoaded) {
          Timer(Duration(milliseconds: 100), () {
            BlocProvider.of<DeviceDaemonBloc>(context).add(DeviceDaemonBlocEventLoadDevice(state.box.device));
          });
          setState(() => values = List.from(state.values));
        } else if (state is FeedLightFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(mustPop: true, param: state.feedEntry));
        }
      },
      child: BlocBuilder<FeedLightFormBloc, FeedLightFormBlocState>(
          cubit: BlocProvider.of<FeedLightFormBloc>(context),
          builder: (context, state) {
            Widget body;
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
                              launch('https://www.supergreenlab.com');
                            },
                          ),
                          Text(FeedLightFormPage.feedLightFormPageOr),
                          GreenButton(
                            title: FeedLightFormPage.feedLightFormPageDIYNow,
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
            } else if (state is FeedLightFormBlocStateLightsLoaded) {
              Widget content = ListView.builder(
                itemCount: values.length,
                itemBuilder: _renderLightParam,
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
              body = BlocListener<DeviceDaemonBloc, DeviceDaemonBlocState>(
                  listener: (BuildContext context, DeviceDaemonBlocState daemonState) {
                    if (state is FeedLightFormBlocStateLightsLoaded) {
                      if (daemonState is DeviceDaemonBlocStateDeviceReachable &&
                          daemonState.device.id == state.box.device) {
                        if (_reachable == daemonState.reachable && _usingWifi == daemonState.usingWifi) return;
                        setState(() {
                          _reachable = daemonState.reachable;
                          _usingWifi = daemonState.usingWifi;
                        });
                      }
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

  Widget _renderLightParam(BuildContext context, int i) {
    return SliderFormParam(
      key: Key('$i'),
      title: 'Light ${i + 1}',
      icon: 'assets/feed_form/icon_${values[i] > 30 ? "sun" : "moon"}.svg',
      value: values[i].toDouble(),
      color: _color(values[i]),
      onChanged: (double newValue) {
        setState(() {
          values[i] = newValue.round();
          changed = true;
        });
      },
      onChangeEnd: (double value) {
        BlocProvider.of<FeedLightFormBloc>(context).add(FeedLightFormBlocValueChangedEvent(i, value.round()));
      },
    );
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
