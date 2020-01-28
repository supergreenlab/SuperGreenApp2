import 'package:flutter/material.dart';

class GreenButton extends RaisedButton {
  GreenButton({title, onPressed, color=0xff3bb30b})
      : super(
          color: Color(color),
          child: Text(title, style: TextStyle(color: Colors.white)),
          onPressed: onPressed,
        );
}
