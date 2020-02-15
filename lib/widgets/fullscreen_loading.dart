import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/fullscreen.dart';

class FullscreenLoading extends StatelessWidget {
  final String title;
  final double percent;

  const FullscreenLoading({this.title, this.percent});

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      title: title,
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          value: percent,
          strokeWidth: 4.0,
        ),
      ),
    );
  }
}
