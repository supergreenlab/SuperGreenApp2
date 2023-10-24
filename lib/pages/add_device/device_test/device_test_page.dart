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
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_test/device_test_bloc.dart';
import 'package:super_green_app/data/assets/feed_entry.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class DeviceTestPage extends StatefulWidget {
  static String testLEDTiming(time) {
    return Intl.message(
      '(100% power for $time s)',
      args: [time],
      name: 'testLEDTiming',
      desc: 'Wait message when setting a led to 100% for a few seconds when setting up a new controller.',
      locale: SGLLocalizations.current?.localeName,
      examples: const {'time': 0.34},
    );
  }

  static String get testingLEDTitle {
    return Intl.message(
      'Testing LED',
      name: 'testingLEDTitle',
      desc: 'Title for the led testing page',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get testingLEDDone {
    return Intl.message(
      'Testing done',
      name: 'testingLEDDone',
      desc: 'Title for the led testing page',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get ledTestingInstructions {
    return Intl.message(
      'Press a led channel\nto switch it on/off:',
      name: 'ledTestingInstructions',
      desc: 'Intructions for the LED test page during new controller setup',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get ledTestingChannelTitle {
    return Intl.message(
      'Light',
      name: 'ledTestingChannelTitle',
      desc: 'The word displayed on each led channel widget',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get ledTestingValidate {
    return Intl.message(
      'OK, ALL GOOD',
      name: 'ledTestingValidate',
      desc: 'Confirmation button for the LED testing page',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get ledTestingPageTitle {
    return Intl.message(
      'NEW BOX SETUP',
      name: 'ledTestingPageTitle',
      desc: 'Led testing page title',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  _DeviceTestPageState createState() => _DeviceTestPageState();
}

class _DeviceTestPageState extends State<DeviceTestPage> {
  Timer? timer;
  late int millis;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<DeviceTestBloc>(context),
      listener: (BuildContext context, DeviceTestBlocState state) async {
        if (state is DeviceTestBlocStateDone) {
          Timer(const Duration(milliseconds: 1500), () {
            BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: true));
          });
        } else if (state is DeviceTestBlocStateTestingLed) {
          millis = 2000;
          timer = Timer.periodic(new Duration(milliseconds: 100), (timer) {
            setState(() {
              millis -= 100;
            });
          });
        } else if (timer != null) {
          timer?.cancel();
          timer = null;
        }
      },
      child: BlocBuilder<DeviceTestBloc, DeviceTestBlocState>(
          bloc: BlocProvider.of<DeviceTestBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is DeviceTestBlocStateLoading) {
              body = FullscreenLoading(
                title: CommonL10N.loading,
              );
            } else if (state is DeviceTestBlocStateTestingLed) {
              body = Fullscreen(
                childFirst: false,
                title: DeviceTestPage.testingLEDTitle,
                subtitle: DeviceTestPage.testLEDTiming(max(0, (millis / 1000)).toStringAsFixed(1)),
                child: Text('${state.ledID + 1}',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Color(0xff3bb30b))),
              );
            } else if (state is DeviceTestBlocStateDone) {
              body = Fullscreen(
                title: DeviceTestPage.testingLEDDone,
                child: Icon(
                  Icons.check,
                  color: Color(0xff3bb30b),
                  size: 100,
                ),
              );
            } else {
              body = LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: <Widget>[
                      SectionTitle(
                        title: DeviceTestPage.ledTestingInstructions,
                        icon: FeedEntryIcons[FE_LIGHT]!,
                        backgroundColor: Color(0xff0b6ab3),
                        titleColor: Colors.white,
                        elevation: 5,
                      ),
                      Expanded(
                        child: _renderChannels(context, state.nLedChannels, DeviceTestPage.ledTestingChannelTitle,
                            FeedEntryIcons[FE_LIGHT]!),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GreenButton(
                            title: DeviceTestPage.ledTestingValidate,
                            onPressed: () {
                              BlocProvider.of<DeviceTestBloc>(context).add(DeviceTestBlocEventDone());
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return Scaffold(
                appBar: SGLAppBar(
                  DeviceTestPage.ledTestingPageTitle,
                  hideBackButton: state is DeviceTestBlocStateDone || state is DeviceTestBlocStateTestingLed,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderChannels(context, int nChannels, String prefix, String icon) {
    int i = 0;
    return GridView.count(
      crossAxisCount: 3,
      children: List.filled(nChannels, 0)
          .map((e) => _renderChannel(
              context,
              '$prefix ${++i}',
              icon,
              ((int i) => () {
                    BlocProvider.of<DeviceTestBloc>(context).add(DeviceTestBlocEventTestLed(i));
                  })(i - 1)))
          .toList(),
    );
  }

  Widget _renderChannel(BuildContext context, String text, String icon, Function() onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(icon),
          ),
          Text(text),
        ],
      ),
    );
  }
}
