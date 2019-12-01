

import 'package:flutter/material.dart';
import 'package:super_green_app/apis/device/kv_device.dart';
import 'package:super_green_app/blocs/device/device.dart';
import 'package:super_green_app/models/device/device_data.dart';
import 'package:super_green_app/pages/device/device_page.dart';
import 'package:super_green_app/pages/device/new_device_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperGreenLab',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NewDevicePage(),
    );
  }
}
