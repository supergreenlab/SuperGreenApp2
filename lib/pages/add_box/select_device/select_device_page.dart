/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device/select_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SelectBoxDeviceData {
  final Device device;
  final int deviceBox;

  SelectBoxDeviceData(this.device, this.deviceBox);
}

class SelectDevicePage extends StatefulWidget {
  @override
  _SelectDevicePageState createState() => _SelectDevicePageState();
}

class _SelectDevicePageState extends State<SelectDevicePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectDeviceBloc, SelectDeviceBlocState>(
        bloc: BlocProvider.of<SelectDeviceBloc>(context),
        builder: (context, state) => Scaffold(
            appBar: SGLAppBar(
              'Select Box device',
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  SectionTitle(
                      title: 'Select the device below',
                      icon: 'assets/box_setup/icon_controller.svg'),
                  Expanded(child: _deviceList(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.red,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.close),
                            Text('NO SGL DEVICE'),
                          ],
                        ),
                        onPressed: () {
                          BlocProvider.of<MainNavigatorBloc>(context)
                              .add(MainNavigatorActionPop(param: false));
                        },
                      ),
                      FlatButton(
                        textColor: Colors.blue,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add),
                            Text('ADD NEW DEVICE'),
                          ],
                        ),
                        onPressed: () {
                          BlocProvider.of<MainNavigatorBloc>(context).add(
                              MainNavigateToAddDeviceEvent(
                                  futureFn: (future) async {
                            Device device = await future;
                            if (device != null) {
                              _selectDevice(context, device);
                            }
                          }));
                        },
                      ),
                    ],
                  )
                ],
              ),
            )));
  }

  Widget _deviceList(BuildContext context) {
    return BlocBuilder<SelectDeviceBloc, SelectDeviceBlocState>(
      bloc: BlocProvider.of<SelectDeviceBloc>(context),
      condition: (previousState, state) =>
          state is SelectDeviceBlocStateDeviceListUpdated,
      builder: (BuildContext context, SelectDeviceBlocState state) {
        List<Device> devices = List();
        if (state is SelectDeviceBlocStateDeviceListUpdated) {
          devices = state.devices;
        }
        int i = 1;
        return ListView(
          children: devices
              .map((
                d,
              ) =>
                  ListTile(
                    onTap: () => _selectDevice(context, d),
                    title: Text(
                      '${i++} - ${d.name}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  void _selectDevice(BuildContext context, Device device) {
    BlocProvider.of<MainNavigatorBloc>(context).add(
        MainNavigateToSelectBoxDeviceBoxEvent(device, futureFn: (future) async {
      dynamic deviceBox = await future;
      if (deviceBox is int) {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(
            param: SelectBoxDeviceData(device, deviceBox)));
      }
    }));
  }
}
