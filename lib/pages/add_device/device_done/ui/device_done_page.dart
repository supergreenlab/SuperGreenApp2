import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_done/bloc/device_done_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class DeviceDonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceDoneBloc, DeviceDoneBlocState>(
      listener: (context, DeviceDoneBlocState state) {
        if (state is DeviceDoneBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToSelectBoxDeviceBoxEvent(state.box));
        }
      },
      child: BlocBuilder<DeviceDoneBloc, DeviceDoneBlocState>(
          bloc: Provider.of<DeviceDoneBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: SGLAppBar('Add device'),
              body: Text('DeviceDone'))),
    );
  }
}
