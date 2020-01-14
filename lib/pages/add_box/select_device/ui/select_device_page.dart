import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device/bloc/select_device_bloc.dart';

class SelectDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<SelectDeviceBloc>(context),
      listener: (BuildContext context, SelectDeviceBlocState state) {
        if (state is SelectDeviceBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToHomeEvent());
        }
      },
      child: BlocBuilder<SelectDeviceBloc, SelectDeviceBlocState>(
          bloc: Provider.of<SelectDeviceBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: AppBar(title: Text('Select Box device')),
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
          state is SelectDeviceBlocStateLoadedDevices,
      builder: (BuildContext context, SelectDeviceBlocState state) {
        List<Device> devices = List();
        if (state is SelectDeviceBlocStateLoadedDevices) {
          devices = state.devices;
        }
        return ListView(
          children: devices
              .map((d) => ListTile(
                    onTap: () => _selectDevice(context, state.box, d),
                    title: Text('${d.name}'),
                  ))
              .toList(),
        );
      },
    );
  }

  void _selectDevice(BuildContext context, Box box, Device device) {
    BlocProvider.of<SelectDeviceBloc>(context)
        .add(SelectDeviceBlocEventSelectDevice(box, device));
  }
}
