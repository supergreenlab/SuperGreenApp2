import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/new_device/bloc/new_device_bloc.dart';

class NewDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewDeviceBloc, NewDeviceBlocState>(
        bloc: Provider.of<NewDeviceBloc>(context),
        builder: (context, state) {
          if (state is NewDeviceBlocStateConnectionToSSIDSuccess) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToDeviceSetupEvent('192.168.4.1'));
            Provider.of<NewDeviceBloc>(context).add(NewDeviceBlocEventReset());
          }
          return Scaffold(
            appBar: AppBar(title: Text('Add device')),
            body: Text(state.toString()),
          );
        });
  }
}
