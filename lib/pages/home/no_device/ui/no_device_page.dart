import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

class NoDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: Text('Welcome to SuperGreenLab',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Text('Looks like you haven\'t added a device yet!'),
            Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text('Add a new device:',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
                child: MaterialButton(
                    onPressed: () => _onAddNewDevice(context),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Image.asset('assets/home/plug_driver.png'),
                            ),
                            Text('Plug in your new device and'),
                            Text('click here'),
                          ]),
                    ))),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text('OR',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            MaterialButton(
              child: Text('Add an existing device'),
              onPressed: () => _onAddExistingDevice(context),
            ),
          ]),
    );
  }

  _onAddNewDevice(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToNewDeviceEvent());
  }

  _onAddExistingDevice(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToExistingDeviceEvent());
  }

}
