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
    return BlocListener(
      bloc: BlocProvider.of<DeviceSetupBloc>(context),
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
            return WillPopScope(
              onWillPop: () async => state is DeviceSetupBlocStateAlreadyExists,
              child: Scaffold(
                appBar: SGLAppBar(
                  'Add device',
                  hideBackButton: !(state is DeviceSetupBlocStateAlreadyExists),
                ),
                body: state is DeviceSetupBlocStateAlreadyExists
                    ? _renderAlreadyAdded(context)
                    : _renderLoading(context, state),
              ),
            );
          }),
    );
  }

  Widget _renderAlreadyAdded(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
            child: Column(
          children: <Widget>[
            Icon(Icons.warning, color: Color(0xff3bb30b), size: 100),
            Text(
              'This device is already added!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        )),
      ],
    );
  }

  Widget _renderLoading(BuildContext context, DeviceSetupBlocState state) {
    return Column(
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
    );
  }
}
