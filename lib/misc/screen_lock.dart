import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:super_green_app/theme.dart';

ScreenLockConfig get screenLockConfig {
  return ScreenLockConfig(
    backgroundColor: SglColor.green,
    textStyle: TextStyle(fontSize: 16),
    titleTextStyle: TextStyle(fontSize: 18),
    buttonStyle: ButtonStyle(
      shape: MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(40))),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return SglColor.inactive;
        }
        return Colors.white;
      }),
      shadowColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return SglColor.inactive;
        }
        return Colors.white;
      }),
    )
  );
}

KeyPadConfig get screenLockKeyPadConfig {
  return KeyPadConfig(
    buttonConfig: KeyPadButtonConfig(
      backgroundColor: Colors.white.withOpacity(0.2),
      buttonStyle: OutlinedButton.styleFrom(
        side: BorderSide(width: 0, color: Colors.transparent),
      ),
    ),
    actionButtonConfig: KeyPadButtonConfig(
      backgroundColor: Colors.transparent,
      buttonStyle: TextButton.styleFrom(
        side: BorderSide(width: 0, color: Colors.transparent),
      ),
    ),
  );
}