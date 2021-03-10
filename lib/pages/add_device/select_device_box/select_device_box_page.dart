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
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/l10n/common.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device_box/select_device_box_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/section_title.dart';

class SelectDeviceBoxPage extends TraceableStatefulWidget {
  static String get selectDeviceBoxSettingUp {
    return Intl.message(
      'Setting up..',
      name: 'selectDeviceBoxSettingUp',
      desc: 'Message while app is configuring new box',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectDeviceBoxSlot {
    return Intl.message(
      'Select controller\'s box slot',
      name: 'selectDeviceBoxSlot',
      desc: 'Select device box slot',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectDeviceBoxAlreadyRunning {
    return Intl.message(
      'Already running',
      name: 'selectDeviceBoxAlreadyRunning',
      desc: 'Select device box slot',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectDeviceBoxAvailable {
    return Intl.message(
      'Available',
      name: 'selectDeviceBoxAvailable',
      desc: 'Select device box slot available',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectDeviceBoxNoMoreLED {
    return Intl.message(
      'No more free led channels',
      name: 'selectDeviceBoxNoMoreLED',
      desc: 'Select device box slot no more channels',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String selectDeviceBoxNumber(int number) {
    return Intl.message(
      'Box #$number',
      args: [number],
      name: 'selectDeviceBoxNumber',
      desc: 'Box slot number',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String selectDeviceBoxLedChannelDescription(String leds) {
    return Intl.message(
      'Led channels: $leds',
      args: [leds],
      name: 'selectDeviceBoxLedChannelDescription',
      desc: 'Box slot channel description',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String get selectDeviceBoxNoLedChannelAssigned {
    return Intl.message(
      'No led channels assigned',
      name: 'selectDeviceBoxNoLedChannelAssigned',
      desc: 'Box slot no led channel assigned yet',
      locale: SGLLocalizations.current.localeName,
    );
  }

  static String selectDeviceBoxResetDialogTitle(int index, String name) {
    return Intl.message(
      'Reset box #$index on controller $name?',
      args: [index, name],
      name: 'selectDeviceBoxResetDialogTitle',
      desc: 'Box slot reset dialog title',
      locale: SGLLocalizations.current.localeName,
    );
  }

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
      cubit: BlocProvider.of<SelectDeviceBoxBloc>(context),
      listener: (context, state) {
        if (state is SelectDeviceBoxBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigatorActionPop(param: state.box));
        }
      },
      child: BlocBuilder<SelectDeviceBoxBloc, SelectDeviceBoxBlocState>(
          cubit: BlocProvider.of<SelectDeviceBoxBloc>(context),
          builder: (context, state) {
            Widget body;
            if (state is SelectDeviceBoxBlocStateInit) {
              body = FullscreenLoading(title: CommonL10N.loading);
            } else if (state is SelectDeviceBoxBlocStateLoading) {
              body = FullscreenLoading(title: SelectDeviceBoxPage.selectDeviceBoxSettingUp);
            } else if (state is SelectDeviceBoxBlocStateDone) {
              body = Fullscreen(title: CommonL10N.done, child: Icon(Icons.done, color: Color(0xff3bb30b), size: 100));
            } else {
              body = _renderBoxSelection(context, state);
            }
            return Scaffold(
                appBar: SGLAppBar(
                  '🤖🔌',
                  fontSize: 40,
                  backgroundColor: Color(0xff0b6ab3),
                  titleColor: Colors.white,
                  iconColor: Colors.white,
                ),
                body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
          }),
    );
  }

  Widget _renderBoxSelection(BuildContext context, SelectDeviceBoxBlocStateLoaded state) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 20,
          color: Color(0xff0b6ab3),
        ),
        SectionTitle(
          title: SelectDeviceBoxPage.selectDeviceBoxSlot,
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
    int selectedLeds = state.boxes.map<int>((b) => b.leds.length).reduce((acc, b) => acc + b);
    bool hasAvailableLeds = selectedLeds < state.nLeds;
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index == state.boxes.length) {
              return null;
            }
            Widget title;
            if (state.boxes[index].enabled) {
              title = Text(SelectDeviceBoxPage.selectDeviceBoxAlreadyRunning,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w300));
            } else {
              title = Text(
                  hasAvailableLeds
                      ? SelectDeviceBoxPage.selectDeviceBoxAvailable
                      : SelectDeviceBoxPage.selectDeviceBoxNoMoreLED,
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w300));
            }
            return ListTile(
              onTap: () {
                if (state.boxes[index].enabled == false) {
                  BlocProvider.of<MainNavigatorBloc>(context)
                      .add(MainNavigateToSelectNewDeviceBoxEvent(state.device, index, futureFn: (future) async {
                    dynamic done = await future;
                    if (done == true) {
                      BlocProvider.of<SelectDeviceBoxBloc>(context).add(SelectDeviceBoxBlocEventSelectBox(index));
                    }
                  }));
                } else {
                  BlocProvider.of<SelectDeviceBoxBloc>(context)
                      .add(SelectDeviceBoxBlocEventSelectBox(state.boxes[index].box));
                }
              },
              onLongPress: () {
                _deleteBox(state, index);
              },
              title: title,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset('assets/box_setup/icon_box.svg'),
                  Text(SelectDeviceBoxPage.selectDeviceBoxNumber(state.boxes[index].box + 1),
                      style: TextStyle(fontWeight: FontWeight.w300)),
                ],
              ),
              subtitle: Text(state.boxes[index].leds.length > 0
                  ? SelectDeviceBoxPage.selectDeviceBoxLedChannelDescription(
                      state.boxes[index].leds.map((l) => l + 1).join(', '))
                  : SelectDeviceBoxPage.selectDeviceBoxNoLedChannelAssigned),
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
            title: Text(SelectDeviceBoxPage.selectDeviceBoxResetDialogTitle(index + 1, state.device.name)),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(CommonL10N.no),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(CommonL10N.yes),
              ),
            ],
          );
        });
    if (confirm) {
      BlocProvider.of<SelectDeviceBoxBloc>(context).add(SelectDeviceBoxBlocEventDelete(index));
    }
  }
}
