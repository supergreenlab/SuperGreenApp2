import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/add_device/add_device/add_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class AddDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDeviceBloc, AddDeviceBlocState>(
        bloc: Provider.of<AddDeviceBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: SGLAppBar('Add device'),
            body: Column(
              children: <Widget>[
                Text('AddDevice'),
              ],
            )));
  }
}
