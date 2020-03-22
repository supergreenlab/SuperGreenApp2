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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/existing_device/existing_device_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';
import 'package:super_green_app/widgets/textfield.dart';

class ExistingDevicePage extends StatefulWidget {
  @override
  _ExistingDevicePageState createState() => _ExistingDevicePageState();
}

class _ExistingDevicePageState extends State<ExistingDevicePage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<ExistingDeviceBloc>(context),
      listener: (BuildContext context, ExistingDeviceBlocState state) {
        if (state is ExistingDeviceBlocStateFound) {
          BlocProvider.of<MainNavigatorBloc>(context).add(
              MainNavigateToDeviceSetupEvent(state.ip,
                  futureFn: (future) async {
            Device device = await future;
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigatorActionPop(param: device));
          }));
        }
      },
      child: BlocBuilder<ExistingDeviceBloc, ExistingDeviceBlocState>(
          bloc: BlocProvider.of<ExistingDeviceBloc>(context),
          builder: (context, state) {
            Widget body;

            if (state is ExistingDeviceBlocStateResolving) {
              body = FullscreenLoading(
                title: 'Searching device..',
              );
            } else {
              final form = <Widget>[
                SectionTitle(
                  title:
                      SGLLocalizations.current.instructionsExistingDeviceTitle,
                  icon: 'assets/box_setup/icon_search.svg',
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  large: true,
                  elevation: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MarkdownBody(
                    data: SGLLocalizations.current.instructionsExistingDevice,
                    styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SGLTextField(
                      hintText: 'Ex: supergreencontroller or IP address',
                      controller: _nameController,
                      onChanged: (_) {
                        setState(() {});
                      }),
                ),
              ];
              if (state is ExistingDeviceBlocStateNotFound) {
                form.add(Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Device "${_nameController.value.text}" not found!${Platform.isIOS ? '\nThis is a known bug on iOS, should be fixed by April 2020.' : ''}',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w500)),
                ));
              }
              body = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: form,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GreenButton(
                        title: 'SEARCH DEVICE',
                        onPressed: _nameController.value.text != ''
                            ? () => _handleInput(context)
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            }
            return Scaffold(
              appBar: SGLAppBar(
                'Add device',
                backgroundColor: Color(0xff0b6ab3),
                titleColor: Colors.white,
                iconColor: Colors.white,
                hideBackButton: state is ExistingDeviceBlocStateResolving,
              ),
              body: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200), child: body),
            );
          }),
    );
  }

  void _handleInput(BuildContext context) async {
    BlocProvider.of<ExistingDeviceBloc>(context)
        .add(ExistingDeviceBlocEventStartSearch(_nameController.value.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
