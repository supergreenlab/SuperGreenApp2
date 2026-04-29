import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:super_green_app/theme.dart';

ScreenLockConfig get screenLockConfig {
  return ScreenLockConfig(
      backgroundColor: SglColor.green,
      textStyle: TextStyle(fontSize: 16),
      titleTextStyle: TextStyle(fontSize: 18),
      buttonStyle: ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return SglColor.inactive;
          }
          return Colors.white;
        }),
        shadowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return SglColor.inactive;
          }
          return Colors.white;
        }),
      ));
}

KeyPadConfig get screenLockKeyPadConfig {
  return KeyPadConfig(
    buttonConfig: KeyPadButtonConfig(
      backgroundColor: Colors.white.withValues(alpha: 0.2),
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
