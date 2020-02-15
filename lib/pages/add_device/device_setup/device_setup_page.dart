import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/device_name/device_name_bloc.dart';
import 'package:super_green_app/pages/add_device/device_setup/device_setup_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
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
            bool canGoBack = state is DeviceSetupBlocStateAlreadyExists || state is DeviceSetupBlocStateLoadingError;
            Widget body;
            if (state is DeviceSetupBlocStateAlreadyExists) {
              body = _renderAlreadyAdded(context);
            } else if (state is DeviceSetupBlocStateLoadingError) {
              body = _renderLoadingError(context);
            } else {
              body = _renderLoading(context, state);
            }
            return WillPopScope(
              onWillPop: () async => canGoBack,
              child: Scaffold(
                appBar: SGLAppBar(
                  'Add device',
                  hideBackButton: !canGoBack,
                ),
                body: body,
              ),
            );
          }),
    );
  }

  Widget _renderLoadingError(BuildContext context) {
    return Fullscreen(
        title: 'Oops looks like the device is unreachable!',
        child: Icon(Icons.warning, color: Color(0xff3bb30b), size: 100));
  }

  Widget _renderAlreadyAdded(BuildContext context) {
    return Fullscreen(
        title: 'This device is already added!',
        child: Icon(Icons.warning, color: Color(0xff3bb30b), size: 100));
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
            child: FullscreenLoading(
                title: 'Loading please wait..', percent: state.percent)),
      ],
    );
  }
}
