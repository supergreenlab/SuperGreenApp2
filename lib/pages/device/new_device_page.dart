import 'package:flutter/material.dart';
import 'package:super_green_app/blocs/device/new_device.dart';

class NewDevicePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    NewDevice nd = NewDevice("supergreencontroller.local");
    nd.startSearch();
    return StreamBuilder<NewDeviceState>(
        stream: nd.state,
        initialData: nd.data,
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
}