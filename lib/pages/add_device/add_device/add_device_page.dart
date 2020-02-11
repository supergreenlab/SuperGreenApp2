import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/add_device/add_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class AddDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDeviceBloc, AddDeviceBlocState>(
        bloc: BlocProvider.of<AddDeviceBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: SGLAppBar('Add new device'),
            body: Column(
              children: <Widget>[
                _renderChoice(
                    context,
                    'Brand new',
                    'assets/box_setup/icon_controller.svg',
                    'Choose this option if the device is brand new or using it\'s own wifi.',
                    'CONNECT DEVICE', () {
                  BlocProvider.of<MainNavigatorBloc>(context).add(
                      MainNavigateToNewDeviceEvent(futureFn: (future) async {
                    Device device = await future;
                    if (device != null) {
                      BlocProvider.of<MainNavigatorBloc>(context)
                          .add(MainNavigatorActionPop(param: device));
                    }
                  }));
                }),
                _renderChoice(
                    context,
                    'Already running',
                    'assets/box_setup/icon_controller.svg',
                    'Choose this option if the device is already running and connected to your home wifi.',
                    'SEARCH DEVICE', () {
                  BlocProvider.of<MainNavigatorBloc>(context).add(
                      MainNavigateToExistingDeviceEvent(
                          futureFn: (future) async {
                    Device device = await future;
                    if (device != null) {
                      BlocProvider.of<MainNavigatorBloc>(context)
                          .add(MainNavigatorActionPop(param: device));
                    }
                  }));
                }),
              ],
            )));
  }

  Widget _renderChoice(BuildContext context, String title, String icon,
      String description, String buttonTitle, Function onPressed) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SectionTitle(
          title: title,
          icon: icon,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(description),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: GreenButton(
            title: buttonTitle,
            onPressed: onPressed,
          ),
        ),
      )
    ]);
  }
}
