import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_name/bloc/device_name_bloc.dart';

class DeviceNamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DeviceNamePageState();
}

class DeviceNamePageState extends State<DeviceNamePage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
          bloc: Provider.of<DeviceNameBloc>(context),
      listener: (BuildContext context, DeviceNameBlocState state) {
        if (state is DeviceNameBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToDeviceNameEvent(state.deviceData));
        }
      },
          child: BlocBuilder<DeviceNameBloc, DeviceNameBlocState>(
          bloc: Provider.of<DeviceNameBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: AppBar(title: Text('Add device')),
              body: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                    controller: _nameController,
                  )),
                  RaisedButton(
                    onPressed: () => _handleInput(context),
                    child: Text('OK'),
                  ),
                ],
              ))
          ),
    );
  }

  void _handleInput(BuildContext context) {
    Provider.of<DeviceNameBloc>(context).add(DeviceNameBlocEventSetName(_nameController.text));
  }
}
