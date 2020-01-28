import 'package:flutter/material.dart';

class GreenButton extends RaisedButton {
  GreenButton({title, onPressed})
      : super(
          color: Color(0xff3bb30b),
          child: Text(title, style: TextStyle(color: Colors.white)),
          onPressed: onPressed,
        );
}
