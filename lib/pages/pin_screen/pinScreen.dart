import 'package:flutter/material.dart';
import 'package:fluttertoastalert/FlutterToastAlert.dart';
import 'package:super_green_app/widgets/pin_screen/constant/constant.dart';
import 'package:super_green_app/widgets/pin_screen/pincode.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:vibration/vibration.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  int chances = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text("Wrong Pass. Are you high right now?",
                        style: wrongPassTextStyle1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Let's try again in ", style: wrongPassTextStyle1),
                        CountdownTimer(
                            textStyle: wrongPassTextStyle2,
                            endTime: DateTime.now().millisecondsSinceEpoch +
                                1000 * 20 * 13) // <=> 4min20sec
                      ],
                    )
                  ])),
            ),
          );
        }
      },
    ));
  }
}
