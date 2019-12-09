import 'package:flutter/material.dart';

class ButtonOK extends RaisedButton {
  ButtonOK({
    @required String text,
    @required Function onPressed,
    @required ThemeData themeData,
    bool disabled = false,
  }) : super(
          child: Text(text),
          onPressed: disabled ? null : onPressed,
          color: themeData.primaryColor,
          textColor: themeData.primaryTextTheme.button.color,
          disabledColor: themeData.primaryColor.withOpacity(.5),
          disabledTextColor: themeData.primaryTextTheme.button.color,
          shape: themeData.buttonTheme.shape,
        );
}