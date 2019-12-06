import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/add_device/device_setup/bloc/device_setup_bloc.dart';

class DeviceSetupPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceSetupBloc, DeviceSetupBlocState>(
      bloc: Provider.of<DeviceSetupBloc>(context),
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text('Add device')),
        body: Text('DeviceSetupPage'),
      )
    );
  }

}