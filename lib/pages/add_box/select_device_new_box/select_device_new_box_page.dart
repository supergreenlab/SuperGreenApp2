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
import 'package:super_green_app/pages/add_box/select_device_new_box/select_device_new_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SelectDeviceNewBoxPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectDeviceNewBoxPageState();
}

class SelectDeviceNewBoxPageState extends State<SelectDeviceNewBoxPage> {
  List<int> _selectedLeds;

  @override
  void initState() {
    _selectedLeds = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectDeviceNewBoxBloc, SelectDeviceNewBoxBlocState>(
      bloc: BlocProvider.of<SelectDeviceNewBoxBloc>(context),
      listener: (context, state) {
        if (state is SelectDeviceNewBoxBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop(param: state.box));
        }
      },
      child: BlocBuilder<SelectDeviceNewBoxBloc, SelectDeviceNewBoxBlocState>(
          bloc: BlocProvider.of<SelectDeviceNewBoxBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is SelectDeviceNewBoxBlocStateLoading) {
              body = FullscreenLoading(title: 'Setting up..');
            } else if (state is SelectDeviceNewBoxBlocStateDeviceFull) {
              body = _renderNoLedsAvailable(context, state);
            } else if (state is SelectDeviceNewBoxBlocStateDone) {
              body = Fullscreen(
                  title: 'Done!',
                  child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
            } else {
              body = _renderLedSelection(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  'Device configuration',
                  backgroundColor: Color(0xff0bb354),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderNoLedsAvailable(context, state) {
    return Fullscreen(
        title: 'Device can\'t handle\nmore box!',
        child: Icon(Icons.warning, color: Color(0xff3bb30b), size: 100));
  }

  Widget _renderLedSelection(context, state) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 20,
          color: Color(0xff0bb354),
        ),
        SectionTitle(
          title: 'Available LED channels',
          icon: 'assets/box_setup/icon_controller.svg',
          backgroundColor: Color(0xff0bb354),
          titleColor: Colors.white,
        ),
        _renderLeds(
            state.leds.where((l) => !_selectedLeds.contains(l)).toList(),
            (int led) {
          setState(() {
            _selectedLeds.add(led);
            BlocProvider.of<SelectDeviceNewBoxBloc>(context)
                .add(SelectDeviceNewBoxBlocEventSelectLed(led));
          });
        }),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SectionTitle(
            title: 'Selected LED channels',
            icon: 'assets/box_setup/icon_controller.svg',
            backgroundColor: Color(0xff0bb354),
            titleColor: Colors.white,
          ),
        ),
        _renderLeds(_selectedLeds, (int led) {
          setState(() {
            _selectedLeds.remove(led);
            BlocProvider.of<SelectDeviceNewBoxBloc>(context)
                .add(SelectDeviceNewBoxBlocEventUnselectLed(led));
          });
        }),
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GreenButton(
              title: 'SETUP BOX',
              onPressed: _selectedLeds.length == 0
                  ? null
                  : () => _handleInput(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderLeds(List<int> leds, Function(int) onSelected) {
    return Container(
      height: 91,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: leds
            .map<Widget>((led) => _renderBox(Key('$led'), context, () {
                  onSelected(led);
                },
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Text('LED chan', style: TextStyle(fontSize: 10)),
                          Text(
                            '${led + 1}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )))
            .toList(),
      ),
    );
  }

  void _handleInput(BuildContext context) {
    BlocProvider.of<SelectDeviceNewBoxBloc>(context)
        .add(SelectDeviceNewBoxBlocEventSelectLeds(_selectedLeds));
  }

  Widget _renderBox(
      Key key, BuildContext context, Function onPressed, Widget content) {
    return SizedBox(
        key: key,
        width: 100,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
          child: RawMaterialButton(
            onPressed: onPressed,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: content),
          ),
        ));
  }
}
