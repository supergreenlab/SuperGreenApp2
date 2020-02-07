import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_done/device_done_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class DeviceDonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<DeviceDoneBloc, DeviceDoneBlocState>(
        listener: (context, DeviceDoneBlocState state) {
          if (state is DeviceDoneBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(param: state.device, mustPop: true));
          }
        },
        child: BlocBuilder<DeviceDoneBloc, DeviceDoneBlocState>(
            bloc: Provider.of<DeviceDoneBloc>(context),
            builder: (context, state) => Scaffold(
                appBar: SGLAppBar(
                  'Add device',
                  hideBackButton: true,
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                        child: Column(
                      children: <Widget>[
                        Icon(Icons.check, color: Color(0xff3bb30b), size: 100),
                        Text('Done!',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500)),
                      ],
                    )),
                  ],
                ))),
      ),
    );
  }
}
