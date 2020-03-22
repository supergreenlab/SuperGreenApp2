import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_test/device_test_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class DeviceTestPage extends StatefulWidget {
  @override
  _DeviceTestPageState createState() => _DeviceTestPageState();
}

class _DeviceTestPageState extends State<DeviceTestPage> {
  Timer timer;
  int millis;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<DeviceTestBloc>(context),
      listener: (BuildContext context, DeviceTestBlocState state) async {
        if (state is DeviceTestBlocStateDone) {
          Timer(const Duration(milliseconds: 1500), () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(param: true));
          });
        } else if (state is DeviceTestBlocStateTestingLed) {
          millis = 2000;
          timer = Timer.periodic(new Duration(milliseconds: 100), (timer) {
            setState(() {
              millis -= 100;
            });
          });
        } else if (state is DeviceTestBlocState && timer != null) {
          timer.cancel();
          timer = null;
        }
      },
      child: BlocBuilder<DeviceTestBloc, DeviceTestBlocState>(
          bloc: BlocProvider.of<DeviceTestBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is DeviceTestBlocStateLoading) {
              body = FullscreenLoading(
                title: 'Loading..',
              );
            } else if (state is DeviceTestBlocStateTestingLed) {
              body = Fullscreen(
                childFirst: false,
                title: 'Testing LED',
                subtitle: '(100% power for ${max(0, (millis / 1000)).toStringAsFixed(1)}s)',
                child: Text('${state.ledID + 1}',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff3bb30b))),
              );
            } else if (state is DeviceTestBlocStateDone) {
              body = Fullscreen(
                title: 'Testing done',
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
                        title: 'Press a led channel\nto switch it on/off:',
                        icon: 'assets/feed_card/icon_light.svg',
                        backgroundColor: Color(0xff0b6ab3),
                        titleColor: Colors.white,
                        elevation: 5,
                      ),
                      Expanded(
                        child: _renderChannels(context, state.nLedChannels,
                            'Light', 'assets/feed_card/icon_light.svg'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GreenButton(
                            title: 'OK, ALL GOOD',
                            onPressed: () {
                              BlocProvider.of<DeviceTestBloc>(context)
                                  .add(DeviceTestBlocEventDone());
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
                  'NEW BOX SETUP',
                  hideBackButton: state is DeviceTestBlocStateDone ||
                      state is DeviceTestBlocStateTestingLed,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body));
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
                    BlocProvider.of<DeviceTestBloc>(context)
                        .add(DeviceTestBlocEventTestLed(i));
                  })(i - 1)))
          .toList(),
    );
  }

  Widget _renderChannel(
      BuildContext context, String text, String icon, Function onPressed) {
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
