import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_test/device_test_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/section_title.dart';

class DeviceTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<DeviceTestBloc>(context),
      listener: (BuildContext context, DeviceTestBlocState state) async {
        if (state is DeviceTestBlocStateDone) {
          Timer(const Duration(milliseconds: 1500), () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          });
        }
      },
      child: BlocBuilder<DeviceTestBloc, DeviceTestBlocState>(
          bloc: BlocProvider.of<DeviceTestBloc>(context),
          builder: (context, state) {
            return Scaffold(
                appBar: SGLAppBar(
                  'NEW BOX SETUP',
                  hideBackButton: state is DeviceTestBlocStateDone,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                backgroundColor: Colors.white,
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: <Widget>[
                        SectionTitle(
                          title: 'Press a led channel\nto switch it on/off:',
                          icon: 'assets/feed_card/icon_light.svg',
                          backgroundColor: Color(0xff0b6ab3),
                          titleColor: Colors.white,
                        ),
                        Container(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight / 2,
                            child:
                                _renderChannels(context, state.nLedChannels, 'Light', 'assets/feed_card/icon_light.svg')),
                        SectionTitle(
                          title: 'Press a motor channel\nto switch it on/off:',
                          icon: 'assets/feed_form/icon_blower.svg',
                          backgroundColor: Color(0xff0b6ab3),
                          titleColor: Colors.white,
                        ),
                        Container(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight / 4,
                            child:
                                _renderChannels(context, state.nMotorChannels, 'Motor', 'assets/feed_form/icon_blower.svg')),
                      ],
                    );
                  },
                ));
          }),
    );
  }

  Widget _renderChannels(context, int nChannels, String prefix, String icon) {
    int i = 0;
    return GridView.count(
      crossAxisCount: 3,
      children: List.filled(nChannels, 0)
          .map((e) => _renderChannel(context, '$prefix ${++i}', icon))
          .toList(),
    );
  }

  Widget _renderChannel(BuildContext context, String text, String icon) {
    return MaterialButton(
      onPressed: () {},
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
