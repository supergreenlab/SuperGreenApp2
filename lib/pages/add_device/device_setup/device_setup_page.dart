import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_setup/device_setup_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class DeviceSetupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<DeviceSetupBloc>(context),
      listener: (BuildContext context, DeviceSetupBlocState state) {
        if (state is DeviceSetupBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToDeviceNameEvent(state.box, state.device));
        }
      },
      child: BlocBuilder<DeviceSetupBloc, DeviceSetupBlocState>(
          bloc: Provider.of<DeviceSetupBloc>(context),
          builder: (context, state) {
            return Scaffold(
              appBar: SGLAppBar('Add device'),
              body: Text('DeviceSetupPage'),
            );
          }),
    );
  }
}
