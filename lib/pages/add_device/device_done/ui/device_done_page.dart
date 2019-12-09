import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/add_device/device_name/bloc/device_name_bloc.dart';

class DeviceDonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceNameBloc, DeviceNameBlocState>(
        bloc: Provider.of<DeviceNameBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: AppBar(title: Text('Add device')),
            body: Text('DeviceDone')));
  }
}
