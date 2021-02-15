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
import 'package:fluttertoastalert/FlutterToastAlert.dart';
import 'package:super_green_app/pages/settings/pin_screen/settings_pin_screen_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/pin_screen/constant/constant.dart';
import 'package:super_green_app/widgets/pin_screen/pincode.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:vibration/vibration.dart';

class SettingsPinScreenPage extends StatefulWidget {
  @override
  _SettingsPinScreenPageState createState() => _SettingsPinScreenPageState();
}

class _SettingsPinScreenPageState extends State<SettingsPinScreenPage> {
  int chances = 3;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsPinScreenBloc, SettingsPinScreenBlocState>(
      builder: (BuildContext context, SettingsPinScreenBlocState state) {
        if (state is SettingsPinScreenBlocStateInit) {
          return FullscreenLoading();
        }
        return Scaffold(
            appBar: SGLAppBar(
              'Create PIN code',
              backgroundColor: Color(0xff0bb354),
              titleColor: Colors.white,
              iconColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: PinCode(
              backgroundColor: Colors.white,
              titleImage: SvgPicture.asset("assets/super_green_lab_vertical_white.svg"),
              codeLength: 4,
              // you may skip correctPin and plugin will give you pin as
              // call back of [onCodeFail] before it clears pin
              correctPin: "1234",
              onCodeSuccess: (code) {
                print("Connected");
              },
              onCodeFail: (code) {
                // decreases chances by 1 if wrong pass till chances == 0
                chances -= 1;
                //vibrates for 340ms
                Vibration.vibrate(duration: 340);
                //Alerts the users with a dialog box
                FlutterToastAlert.showToastAndAlert(
                  type: Type.Normal,
                  iosSubtitle: 'Wrong pin',
                  androidToast: 'Wrong pin',
                  toastDuration: 3,
                  toastShowIcon: false,
                );

                if (chances == 0) {
                  // reassign 3 to chances then shows a dialog alert with countdowntimer
                  chances = 3;
                  showDialog(
                    context: context,
                    builder: (_) => Material(
                      type: MaterialType.transparency,
                      child: Center(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text("Wrong Pass. Are you high right now?", style: wrongPassTextStyle1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Let's try again in ", style: wrongPassTextStyle1),
                            CountdownTimer(
                                textStyle: wrongPassTextStyle2,
                                endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 20 * 13) // <=> 4min20sec
                          ],
                        )
                      ])),
                    ),
                  );
                }
              },
            ));
      },
    );
  }
}
