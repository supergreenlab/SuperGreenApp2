import 'package:flutter/material.dart';
import 'package:super_green_app/widgets/appbar.dart';

class TimelapseHowtoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget body = Text('lol');
    return Scaffold(
        appBar: SGLAppBar(
          'Timelapse',
        ),
        backgroundColor: Colors.white,
        body: AnimatedSwitcher(
            duration: Duration(milliseconds: 200), child: body));
  }
}
