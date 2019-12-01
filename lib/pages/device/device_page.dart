import 'package:flutter/material.dart';
import 'package:super_green_app/blocs/device/device.dart';
import 'package:super_green_app/models/device/device_data.dart';

class DevicePage extends StatelessWidget {

  final Device _device;

  DevicePage(this._device);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DeviceData>(
      stream: _device.device,
      initialData: _device.data,
      builder: (BuildContext context, AsyncSnapshot<DeviceData> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('SuperGreenLab'),
          ),
          body: Column(
            children: this.body(context, snapshot),
          ),
        );
      }
    );
  }

  List<Widget> body(BuildContext context, AsyncSnapshot<DeviceData> snapshot) {
    return <Widget>[
      Text(
        '${snapshot.data.name}',
      ),
      Expanded(
        child: ListView.builder(
          itemCount: snapshot.data.modules.length,
          itemBuilder: (BuildContext context, int i) {
            return Text('${snapshot.data.modules[i]}');
          }
        )
      ),
    ];
  }
}