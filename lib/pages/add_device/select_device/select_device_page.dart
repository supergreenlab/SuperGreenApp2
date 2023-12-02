/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device/select_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectBoxDeviceData {
  final Device device;
  final int deviceBox;

  SelectBoxDeviceData(this.device, this.deviceBox);
}

class SelectDevicePage extends StatefulWidget {
  static String get selectDeviceSkipAddDevice {
    return Intl.message(
      'NO SGL DEVICE',
      name: 'selectDeviceSkipAddDevice',
      desc: 'Button to skip the sgl device config',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceNewController {
    return Intl.message(
      'NEW CONTROLLER',
      name: 'selectDeviceNewController',
      desc: 'Add new controller button',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceListTitle {
    return Intl.message(
      'Select a controller below',
      name: 'selectDeviceListTitle',
      desc: 'Instruction title above the controller list.',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceListItemInstruction {
    return Intl.message(
      'Tap to select',
      name: 'selectDeviceListItemInstruction',
      desc: 'Instruction for controller list items.',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceNoController {
    return Intl.message(
      'You have no controller\nfor your new lab.',
      name: 'selectDeviceNoController',
      desc: 'Message on the select device screen when no controller added yet',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceAddFirst {
    return Intl.message(
      'Add a first',
      name: 'selectDeviceAddFirst',
      desc: 'First half of the "Add a first controller" instructions',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceAddFirstController {
    return Intl.message(
      'CONTROLLER',
      name: 'selectDeviceAddFirstController',
      desc: 'Second half of the "Add a first controller" instructions',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceAdd {
    return Intl.message(
      'ADD',
      name: 'selectDeviceAdd',
      desc: 'First part of the "Add or Shop now" instructions',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceOr {
    return Intl.message(
      'OR',
      name: 'selectDeviceOr',
      desc: 'Second part of the "Add or Shop now" instructions',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceShopNow {
    return Intl.message(
      'SHOP NOW',
      name: 'selectDeviceShopNow',
      desc: 'Last part of the "Add or Shop now" instructions',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceDIYNow {
    return Intl.message(
      'DIY NOW',
      name: 'selectDeviceDIYNow',
      desc: 'After the "Add or Shop now" instructions',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceContinueWithoutController {
    return Intl.message(
      'Continue without controller',
      name: 'selectDeviceContinueWithoutController',
      desc: 'Skip select controller',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String selectDeviceDeleteControllerDialogTitle(String name) {
    return Intl.message(
      'Delete controller $name?',
      args: [name],
      name: 'selectDeviceDeleteControllerDialogTitle',
      desc: 'Title for the delete controller dialog',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  static String get selectDeviceDeleteControllerDialogBody {
    return Intl.message(
      'This can\'t be reverted. Continue?',
      name: 'selectDeviceDeleteControllerDialogBody',
      desc: 'Confirm controller deletion',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  @override
  _SelectDevicePageState createState() => _SelectDevicePageState();
}

class _SelectDevicePageState extends State<SelectDevicePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectDeviceBloc, SelectDeviceBlocState>(
      listener: (BuildContext context, state) {
        if (state is SelectDeviceBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(param: SelectBoxDeviceData(state.device, state.deviceBox)));
        }
      },
      child: BlocBuilder<SelectDeviceBloc, SelectDeviceBlocState>(
          bloc: BlocProvider.of<SelectDeviceBloc>(context),
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
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
                      title: SelectDevicePage.selectDeviceListTitle,
                      icon: 'assets/box_setup/icon_controller.svg',
                      backgroundColor: Color(0xff0b6ab3),
                      titleColor: Colors.white,
                      large: true,
                      elevation: 5,
                    ),
                    Expanded(child: _deviceList(context, state)),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      TextButton(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.resolveWith((state) => TextStyle(
                                color: Colors.red,
                              )),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.close),
                            Text(SelectDevicePage.selectDeviceSkipAddDevice),
                          ],
                        ),
                        onPressed: () {
                          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: false));
                        },
                      ),
                      TextButton(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.resolveWith((state) => TextStyle(
                                color: Colors.blue,
                              )),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add),
                            Text(SelectDevicePage.selectDeviceNewController),
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
                body: body);
          }),
    );
  }

  Widget _deviceList(BuildContext context, SelectDeviceBlocStateDeviceListUpdated state) {
    int i = 1;
    return ListView(
      children: state.devices
          .map((
            d,
          ) =>
              ListTile(
                leading: Text('🤖', style: TextStyle(fontSize: 30)),
                onTap: () => _selectDevice(context, d),
                onLongPress: () => _deleteDevice(context, d),
                title: Text(
                  '${i++} - ${d.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                subtitle: Text(SelectDevicePage.selectDeviceListItemInstruction),
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
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            SelectDevicePage.selectDeviceNoController,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          SelectDevicePage.selectDeviceAddFirst,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                        Text(SelectDevicePage.selectDeviceAddFirstController,
                            style: TextStyle(fontSize: 45, fontWeight: FontWeight.w200, color: Color(0xff3bb30b))),
                      ],
                    ),
                  ),
                  GreenButton(
                    title: SelectDevicePage.selectDeviceAdd,
                    onPressed: () {
                      _addNewDevice(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      SelectDevicePage.selectDeviceOr,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GreenButton(
                        title: SelectDevicePage.selectDeviceShopNow,
                        onPressed: () {
                          launchUrl(Uri.parse('https://www.supergreenlab.com/bundle/micro-box-bundle'));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('/'),
                      ),
                      GreenButton(
                        title: SelectDevicePage.selectDeviceDIYNow,
                        onPressed: () {
                          launchUrl(Uri.parse('https://picofarmled.com/guide/how-to-setup-pico-farm-os'));
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
          child: TextButton(
            onPressed: () {
              BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: false));
            },
            child: Text(SelectDevicePage.selectDeviceContinueWithoutController,
                style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  void _addNewDevice(BuildContext context) {
    BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToAddDeviceEvent(isController: true, futureFn: (future) async {
      Device? device = await future;
      if (device != null) {
        _selectDevice(context, device);
      }
    }));
  }

  void _selectDevice(BuildContext context, Device device) {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToSelectDeviceBoxEvent(device, futureFn: (future) async {
      dynamic deviceBox = await future;
      if (deviceBox is int) {
        BlocProvider.of<SelectDeviceBloc>(context).add(SelectDeviceBlocEventSelect(device, deviceBox));
      }
    }));
  }

  void _deleteDevice(BuildContext context, Device device) async {
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(SelectDevicePage.selectDeviceDeleteControllerDialogTitle(device.name)),
            content: Text(SelectDevicePage.selectDeviceDeleteControllerDialogBody),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(CommonL10N.no),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(CommonL10N.yes),
              ),
            ],
          );
        });
    if (confirm ?? false) {
      BlocProvider.of<SelectDeviceBloc>(context).add(SelectDeviceBlocEventDelete(device));
    }
  }
}
