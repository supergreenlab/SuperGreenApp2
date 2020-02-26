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
import 'package:super_green_app/pages/add_box/box_infos/box_infos_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device/select_device_page.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class BoxInfosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BoxInfosPageState();
}

class BoxInfosPageState extends State<BoxInfosPage> {
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
      bloc: BlocProvider.of<BoxInfosBloc>(context),
      listener: (BuildContext context, BoxInfosBlocState state) async {
        if (state is BoxInfosBlocStateDone) {
          Timer(const Duration(milliseconds: 1500), () {
            HomeNavigatorBloc.eventBus
                .fire(HomeNavigateToBoxFeedEvent(state.box));
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          });
        }
      },
      child: BlocBuilder<BoxInfosBloc, BoxInfosBlocState>(
          bloc: BlocProvider.of<BoxInfosBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is BoxInfosBlocStateDone) {
              body = _renderDone(state);
            } else {
              body = _renderForm();
            }
            return Scaffold(
                appBar: SGLAppBar(
                  'NEW BOX SETUP',
                  hideBackButton: state is BoxInfosBlocStateDone,
                  backgroundColor: Colors.orange,
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                backgroundColor: Colors.white,
                body: body);
          }),
    );
  }

  Widget _renderDone(BoxInfosBlocStateDone state) {
    String subtitle;
    if (state.device == null && state.deviceBox == null) {
      subtitle = 'Box ${_nameController.value.text} created:)';
    } else {
      subtitle =
          'Box ${_nameController.value.text} on device ${state.device.name} created:)';
    }
    return Fullscreen(
        title: 'Done!',
        subtitle: subtitle,
        child: Icon(Icons.done, color: Color(0xff3bb30b), size: 100));
  }

  Widget _renderForm() {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _keyboardVisible ? 0 : 100,
          color: Colors.orange,
        ),
        SectionTitle(
          title: 'Let\'s name your new box:',
          icon: 'assets/box_setup/icon_box_name.svg',
          backgroundColor: Colors.orange,
          titleColor: Colors.white,
          large: true,
        ),
        Expanded(
            child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
              child: SGLTextField(
                  hintText: 'Ex: BedroomGrow',
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
              title: 'CREATE BOX',
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
        .add(MainNavigateToSelectBoxDeviceEvent(futureFn: (future) async {
      dynamic res = await future;
      if (res is SelectBoxDeviceData) {
        BlocProvider.of<BoxInfosBloc>(context).add(BoxInfosBlocEventCreateBox(
            _nameController.text,
            device: res.device,
            deviceBox: res.deviceBox));
      } else if (res == false) {
        BlocProvider.of<BoxInfosBloc>(context)
            .add(BoxInfosBlocEventCreateBox(_nameController.text));
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
