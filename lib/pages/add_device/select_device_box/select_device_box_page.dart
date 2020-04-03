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
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device_box/select_device_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SelectDeviceBoxPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectDeviceBoxPageState();
}

class SelectDeviceBoxPageState extends State<SelectDeviceBoxPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectDeviceBoxBloc, SelectDeviceBoxBlocState>(
      bloc: BlocProvider.of<SelectDeviceBoxBloc>(context),
      listener: (context, state) {
        if (state is SelectDeviceBoxBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(param: state.box));
        }
      },
      child: BlocBuilder<SelectDeviceBoxBloc, SelectDeviceBoxBlocState>(
          bloc: BlocProvider.of<SelectDeviceBoxBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is SelectDeviceBoxBlocStateInit) {
              body = FullscreenLoading(title: 'Loading..');
            } else if (state is SelectDeviceBoxBlocStateLoading) {
              body = FullscreenLoading(title: 'Setting up..');
            } else if (state is SelectDeviceBoxBlocStateDone) {
              body = Fullscreen(
                  title: 'Done!',
                  child: Icon(Icons.done, color: Color(0xff3bb30b), size: 100));
            } else {
              body = _renderBoxSelection(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  '🤖',
                  fontSize: 40,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderBoxSelection(
      BuildContext context, SelectDeviceBoxBlocStateLoaded state) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 20,
          color: Color(0xff0b6ab3),
        ),
        SectionTitle(
          title: 'Controller boxes',
          icon: 'assets/box_setup/icon_controller.svg',
          backgroundColor: Color(0xff0b6ab3),
          titleColor: Colors.white,
          elevation: 5,
          large: true,
        ),
        _renderBoxes(state),
      ],
    );
  }

  Widget _renderBoxes(SelectDeviceBoxBlocStateLoaded state) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index >= state.boxes.length + 1) {
              return null;
            } else if (index == state.boxes.length) {
              if (state.boxes.length > 0) {
                int selectedLeds = state.boxes
                    .map<int>((b) => b.leds.length)
                    .reduce((acc, b) => acc + b);
                if (selectedLeds >= state.nLeds) {
                  return null;
                }
              }
              return ListTile(
                onTap: () {
                  BlocProvider.of<MainNavigatorBloc>(context).add(
                      MainNavigateToSelectNewDeviceBoxEvent(state.device,
                          futureFn: (future) async {
                    dynamic deviceBox = await future;
                    if (deviceBox is int) {
                      BlocProvider.of<SelectDeviceBoxBloc>(context)
                          .add(SelectDeviceBoxBlocEventSelectBox(deviceBox));
                    }
                  }));
                },
                title: Text('Add new box to controller'),
                leading:
                    SizedBox(width: 50, height: 50, child: Icon(Icons.add)),
              );
            }
            return ListTile(
              onTap: () {
                BlocProvider.of<SelectDeviceBoxBloc>(context).add(
                    SelectDeviceBoxBlocEventSelectBox(state.boxes[index].box));
              },
              onLongPress: () {
                _deleteBox(state, index);
              },
              title: state.boxes[index].enabled
                  ? Text('Already running', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                  : Text('Available', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.home, color: Color(0xff3bb30b)),
                  Text('Box #${state.boxes[index].box + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              subtitle: Text(
                  'Led channels: ${state.boxes[index].leds.map((l) => l + 1).join(', ')}'),
            );
          },
        ),
      ),
    );
  }

  void _deleteBox(SelectDeviceBoxBlocStateLoaded state, int index) async {
    bool confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reset box #$index on controller ${state.device.name}?'),
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
      BlocProvider.of<SelectDeviceBoxBloc>(context)
          .add(SelectDeviceBoxBlocEventDelete(index));
    }
  }
}
