import 'package:flutter/material.dart';
import 'package:super_green_app/pages/device/new/bloc/new_device_bloc.dart';

class NewDevicePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => NewDevicePageState();
}

class NewDevicePageState extends State<NewDevicePage> {

  NewDevice _newDevice = NewDevice("supergreencontroller.local");

  @override
  Widget build(BuildContext context) {
    _newDevice.startSearch();
    return StreamBuilder<NewDeviceState>(
        stream: _newDevice.state,
        initialData: _newDevice.data,
        builder: (BuildContext context, AsyncSnapshot<NewDeviceState> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('New Device'),
            ),
            body: Column(
              children: this.body(context, snapshot),
            ),
          );
        }
    );
  }

  List<Widget> body(BuildContext context, AsyncSnapshot<NewDeviceState> snapshot) {
    return <Widget>[
      Text(
        '${snapshot.data}',
      )
    ];
  }

  @override
  void dispose() {
    _newDevice.dispose();
    super.dispose();
  }

}