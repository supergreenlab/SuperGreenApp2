import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/existing_device/bloc/existing_device_bloc.dart';

class ExistingDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExistingDeviceBloc, ExistingDeviceBlocState>(
        bloc: Provider.of<ExistingDeviceBloc>(context),
        builder: (context, state) {
          if (state is ExistingDeviceBlocStateFound) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToDeviceSetupEvent(state.ip));
            Provider.of<ExistingDeviceBloc>(context)
                .add(ExistingDeviceBlocEventReset());
          }
          return Scaffold(
            appBar: AppBar(title: Text('Add device')),
            body: Text('ExistingDevicePage'),
          );
        });
  }
}
