import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/existing_device/existing_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class ExistingDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<ExistingDeviceBloc>(context),
      listener: (BuildContext context, ExistingDeviceBlocState state) {
        if (state is ExistingDeviceBlocStateFound) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToDeviceSetupEvent(state.box, state.ip));
        }
      },
      child: BlocBuilder<ExistingDeviceBloc, ExistingDeviceBlocState>(
          bloc: Provider.of<ExistingDeviceBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: SGLAppBar('Add device'),
              body: Text('ExistingDevicePage'),
            )
          ),
    );
  }
}
