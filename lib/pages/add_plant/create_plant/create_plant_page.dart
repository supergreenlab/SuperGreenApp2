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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_plant/create_plant/create_plant_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class CreatePlantPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreatePlantPageState();
}

class CreatePlantPageState extends State<CreatePlantPage> {
  final _nameController = TextEditingController();
  bool _isSingle = true;

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
      cubit: BlocProvider.of<CreatePlantBloc>(context),
      listener: (BuildContext context, CreatePlantBlocState state) async {
        if (state is CreatePlantBlocStateDone) {
          BlocProvider.of<TowelieBloc>(context)
              .add(TowelieBlocEventPlantCreated(state.plant));
          Timer(const Duration(milliseconds: 3000), () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop());
          });
        }
      },
      child: BlocBuilder<CreatePlantBloc, CreatePlantBlocState>(
          cubit: BlocProvider.of<CreatePlantBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is CreatePlantBlocStateDone) {
              body = _renderDone(state);
            } else {
              body = _renderForm();
            }
            return Scaffold(
                appBar: SGLAppBar(
                  '🍁',
                  fontSize: 40,
                  hideBackButton: state is CreatePlantBlocStateDone,
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

  Widget _renderDone(CreatePlantBlocStateDone state) {
    String subtitle =
        'Plant ${_nameController.value.text} on lab ${state.box.name} created:)';
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
        Expanded(
          child: ListView(children: [
            SectionTitle(
              title: 'Let\'s name your new plant:',
              icon: 'assets/box_setup/icon_box_name.svg',
              backgroundColor: Color(0xff0bb354),
              titleColor: Colors.white,
              large: true,
              elevation: 5,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
              child: SGLTextField(
                  hintText: 'Ex: Gorilla Kush',
                  controller: _nameController,
                  onChanged: (_) {
                    setState(() {});
                  }),
            ),
            SectionTitle(
              title: 'Is this a single or multiple plant\ngrow diary?',
              icon: 'assets/settings/icon_plants.svg',
              backgroundColor: Color(0xff0bb354),
              titleColor: Colors.white,
              elevation: 5,
            ),
            _renderOptionCheckbx(context, 'Single plant grow diary',
                (newValue) {
              setState(() {
                _isSingle = newValue;
              });
            }, _isSingle),
          ]),
        ),
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

  Widget _renderOptionCheckbx(
      BuildContext context, String text, Function(bool) onChanged, bool value) {
    return Row(
      children: <Widget>[
        Checkbox(
          onChanged: onChanged,
          value: value,
        ),
        InkWell(
          onTap: () {
            onChanged(!value);
          },
          child: MarkdownBody(
            fitContent: true,
            data: text,
            styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: Colors.black, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<MainNavigatorBloc>(context)
        .add(MainNavigateToSelectBoxEvent(futureFn: (future) async {
      dynamic res = await future;
      if (res is Box) {
        BlocProvider.of<CreatePlantBloc>(context)
            .add(CreatePlantBlocEventCreate(
          _nameController.text,
          _isSingle,
          res.id,
        ));
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
