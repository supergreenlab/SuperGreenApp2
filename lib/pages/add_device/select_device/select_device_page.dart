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
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device/select_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return BlocListener<SelectDeviceBloc, SelectDeviceBlocState>(
      listener: (BuildContext context, state) {
        if (state is SelectDeviceBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context).add(
              MainNavigatorActionPop(
                  param: SelectBoxDeviceData(state.device, state.deviceBox)));
        }
      },
      child: BlocBuilder<SelectDeviceBloc, SelectDeviceBlocState>(
          bloc: BlocProvider.of<SelectDeviceBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is SelectDeviceBlocStateDeviceListUpdated) {
              if (state.devices.length > 0) {
                body = Column(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      height: 100,
                      color: Color(0xff0b6ab3),
                    ),
                    SectionTitle(
                      title: 'Select the controller below',
                      icon: 'assets/box_setup/icon_controller.svg',
                      backgroundColor: Color(0xff0b6ab3),
                      titleColor: Colors.white,
                      large: true,
                      elevation: 5,
                    ),
                    Expanded(child: _deviceList(context, state)),
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
                                Text('NEW CONTROLLER'),
                              ],
                            ),
                            onPressed: () {
                              _addNewDevice(context);
                            },
                          ),
                        ])
                  ],
                );
              } else {
                body = _renderNoController(context);
              }
            }
            return Scaffold(
                appBar: SGLAppBar(
                  '🤖',
                  fontSize: 40,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                body: _renderNoController(context));
          }),
    );
  }

  Widget _deviceList(
      BuildContext context, SelectDeviceBlocStateDeviceListUpdated state) {
    int i = 1;
    return ListView(
      children: state.devices
          .map((
            d,
          ) =>
              ListTile(
                onTap: () => _selectDevice(context, d),
                onLongPress: () => _deleteDevice(context, d),
                title: Text(
                  '${i++} - ${d.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ))
          .toList(),
    );
  }

  Widget _renderNoController(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 24),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'You have no controller\nfor your new lab.',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w200),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          'Add a first',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                        Text('CONTROLLER',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w200,
                                color: Color(0xff3bb30b))),
                      ],
                    ),
                  ),
                  GreenButton(
                    title: 'ADD',
                    onPressed: () {
                      _addNewDevice(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'OR',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GreenButton(
                        title: 'SHOW NOW',
                        onPressed: () {
                          launch('https://www.supergreelab.com');
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('/'),
                      ),
                      GreenButton(
                        title: 'DIY NOW',
                        onPressed: () {
                          launch('https://github.com/supergreenlab/');
                        },
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
        Center(
          child: FlatButton(
            onPressed: () {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(MainNavigatorActionPop(param: false));
            },
            child: Text('Continue without controller',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 15,
                    color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  void _addNewDevice(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToAddDeviceEvent(futureFn: (future) async {
      Device device = await future;
      if (device != null) {
        _selectDevice(context, device);
      }
    }));
  }

  void _selectDevice(BuildContext context, Device device) {
    BlocProvider.of<MainNavigatorBloc>(context).add(
        MainNavigateToSelectDeviceBoxEvent(device, futureFn: (future) async {
      dynamic deviceBox = await future;
      if (deviceBox is int) {
        BlocProvider.of<SelectDeviceBloc>(context)
            .add(SelectDeviceBlocEventSelect(device, deviceBox));
      }
    }));
  }

  void _deleteDevice(BuildContext context, Device device) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete controller ${device.name}?'),
            content: Text('This can\'t be reverted. Continue?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<SelectDeviceBloc>(context)
          .add(SelectDeviceBlocEventDelete(device));
    }
  }
}
