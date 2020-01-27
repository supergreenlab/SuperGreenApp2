import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device/bloc/select_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class SelectDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<SelectDeviceBloc>(context),
      listener: (BuildContext context, SelectDeviceBlocState state) {
        if (state is SelectDeviceBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToSelectBoxDeviceBoxEvent(state.box));
        }
      },
      child: BlocBuilder<SelectDeviceBloc, SelectDeviceBlocState>(
          bloc: Provider.of<SelectDeviceBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: SGLAppBar('Select Box device'),
              body: Column(
                children: [
                  Expanded(child: _deviceList(context)),
                  FlatButton(
                    child: Text('ADD DEVICE'),
                    onPressed: () {
                      BlocProvider.of<MainNavigatorBloc>(context)
                          .add(MainNavigateToNewDeviceEvent(state.box));
                    },
                  )
                ],
              ))),
    );
  }

  Widget _deviceList(BuildContext context) {
    return BlocBuilder<SelectDeviceBloc, SelectDeviceBlocState>(
      bloc: Provider.of<SelectDeviceBloc>(context),
      condition: (previousState, state) =>
          state is SelectDeviceBlocStateDeviceListUpdated,
      builder: (BuildContext context, SelectDeviceBlocState state) {
        List<Device> devices = List();
        if (state is SelectDeviceBlocStateDeviceListUpdated) {
          devices = state.devices;
        }
        return ListView(
          children: devices
              .map((d) => ListTile(
                    onTap: () => _selectDevice(context, d),
                    title: Text('${d.name}'),
                  ))
              .toList(),
        );
      },
    );
  }

  void _selectDevice(BuildContext context, Device device) {
    BlocProvider.of<SelectDeviceBloc>(context)
        .add(SelectDeviceBlocEventSelectDevice(device));
  }
}
