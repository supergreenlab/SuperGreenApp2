import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/pin_screen/constant/constant.dart';
import 'package:super_green_app/widgets/pin_screen/keyboard/keyboard.dart';
import 'package:super_green_app/widgets/pin_screen/pinview/code_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PinCode extends StatefulWidget {
  final SvgPicture titleImage;
  final String error, correctPin;
  final Function onCodeSuccess, onCodeFail;
  final int codeLength;
  final TextStyle keyTextStyle, codeTextStyle, errorTextStyle;
  final bool obscurePin;
  final Color backgroundColor;
  final bool showLetters;

  PinCode({
    this.titleImage,
    this.correctPin = "****", // Default Value, use onCodeFail as onEnteredPin
    this.error = '',
    this.codeLength = 4,
    this.obscurePin = false, // Replaces by * if true
    this.onCodeSuccess,
    this.onCodeFail,
    this.errorTextStyle = const TextStyle(color: Colors.red, fontSize: 15),
    this.keyTextStyle = const TextStyle(color: pinKeyTextColor, fontSize: 18.0),
    this.codeTextStyle = const TextStyle(
        color: pinCodeColor, fontSize: 18.0, fontWeight: FontWeight.bold),
    this.backgroundColor,
    this.showLetters = false,
  });

  PinCodeState createState() => PinCodeState();
}

class PinCodeState extends State<PinCode> {
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? Theme.of(context).primaryColor,
      child: Column(children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: widget.titleImage),
                Stack(clipBehavior: Clip.none, children: [
                  CodeView(
                    codeTextStyle: widget.codeTextStyle,
                    code: smsCode,
                    obscurePin: widget.obscurePin,
                    length: widget.codeLength,
                  ),
                  Positioned(
                    child: SvgPicture.asset("assets/lock.svg"),
                    top: 10,
                    right: -40,
                  )
                ]),
              ],
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: CustomKeyboard(
              textStyle: widget.keyTextStyle,
              onPressedKey: (key) {
                if (smsCode.length < widget.codeLength) {
                  setState(() {
                    smsCode = smsCode + key;
                  });
                }
                if (smsCode.length == widget.codeLength) {
                  if (smsCode == widget.correctPin) {
                    widget.onCodeSuccess(smsCode);
                  } else {
                    widget.onCodeFail(smsCode);
                    smsCode = "";
                  }
                }
              },
              onBackPressed: () {
                int codeLength = smsCode.length;
                if (codeLength > 0)
                  setState(() {
                    smsCode = smsCode.substring(0, codeLength - 1);
                  });
              },
              showLetters: widget.showLetters,
            )),
      ]),
    );
  }
}
