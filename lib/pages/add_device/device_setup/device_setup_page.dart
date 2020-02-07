import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_setup/device_setup_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/section_title.dart';

class DeviceSetupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener(
        bloc: Provider.of<DeviceSetupBloc>(context),
        listener: (BuildContext context, DeviceSetupBlocState state) {
          if (state is DeviceSetupBlocStateDone) {
            BlocProvider.of<MainNavigatorBloc>(context).add(
                MainNavigateToDeviceNameEvent(state.device,
                    futureFn: (future) async {
              Device device = await future;
              if (device != null) {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigatorActionPop(param: device, mustPop: true));
              }
            }));
          }
        },
        child: BlocBuilder<DeviceSetupBloc, DeviceSetupBlocState>(
            bloc: Provider.of<DeviceSetupBloc>(context),
            builder: (context, state) {
              return Scaffold(
                appBar: SGLAppBar(
                  'Add device',
                  hideBackButton: true,
                ),
                body: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SectionTitle(
                          title: 'Loading device params',
                          icon: 'assets/box_setup/icon_controller.svg'),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    value: state.percent,
                                    strokeWidth: 4.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Loading please wait..'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
