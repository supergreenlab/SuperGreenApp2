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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_plant/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/add_plant/select_device/select_device_page.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class PlantInfosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlantInfosPageState();
}

class PlantInfosPageState extends State<PlantInfosPage> {
  final _nameController = TextEditingController();

  KeyboardVisibilityNotification _keyboardVisibility =
      KeyboardVisibilityNotification();
  int _listener;
  bool _keyboardVisible = false;

  @protected
  void initState() {
    super.initState();
    _listener = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
        if (!_keyboardVisible) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<PlantInfosBloc>(context),
      listener: (BuildContext context, PlantInfosBlocState state) async {
        if (state is PlantInfosBlocStateDone) {
          BlocProvider.of<TowelieBloc>(context)
              .add(TowelieBlocEventPlantCreated(state.plant));
          Timer(const Duration(milliseconds: 1500), () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          });
        }
      },
      child: BlocBuilder<PlantInfosBloc, PlantInfosBlocState>(
          bloc: BlocProvider.of<PlantInfosBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is PlantInfosBlocStateDone) {
              body = _renderDone(state);
            } else {
              body = _renderForm();
            }
            return Scaffold(
                appBar: SGLAppBar(
                  'Plant creation',
                  hideBackButton: state is PlantInfosBlocStateDone,
                  backgroundColor: Color(0xff0bb354),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                backgroundColor: Colors.white,
                body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderDone(PlantInfosBlocStateDone state) {
    String subtitle;
    if (state.device == null && state.deviceBox == null) {
      subtitle = 'Plant ${_nameController.value.text} created:)';
    } else {
      subtitle =
          'Plant ${_nameController.value.text} on controller ${state.device.name} created:)';
    }
    return Fullscreen(
        title: 'Done!',
        subtitle: subtitle,
        child: Icon(Icons.done, color: Color(0xff0bb354), size: 100));
  }

  Widget _renderForm() {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _keyboardVisible ? 0 : 100,
          color: Color(0xff0bb354),
        ),
        SectionTitle(
          title: 'Let\'s name your new plant:',
          icon: 'assets/box_setup/icon_box_name.svg',
          backgroundColor: Color(0xff0bb354),
          titleColor: Colors.white,
          large: true,
          elevation: 5,
        ),
        Expanded(
            child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
              child: SGLTextField(
                  hintText: 'Ex: IkeHigh',
                  controller: _nameController,
                  onChanged: (_) {
                    setState(() {});
                  }),
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: GreenButton(
              title: 'CREATE PLANT',
              onPressed: _nameController.value.text != ''
                  ? () => _handleInput(context)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToSelectPlantDeviceEvent(futureFn: (future) async {
      dynamic res = await future;
      if (res is SelectBoxDeviceData) {
        BlocProvider.of<PlantInfosBloc>(context).add(PlantInfosBlocEventCreateBox(
            _nameController.text,
            device: res.device,
            deviceBox: res.deviceBox));
      } else if (res == false) {
        BlocProvider.of<PlantInfosBloc>(context)
            .add(PlantInfosBlocEventCreateBox(_nameController.text));
      }
    }));
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_listener);
    _nameController.dispose();
    super.dispose();
  }
}
