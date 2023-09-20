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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/settings/boxes/settings_boxes_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';
import 'package:super_green_app/widgets/green_button.dart';

class SettingsBoxesPage extends TraceableStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBoxesBloc, SettingsBoxesBlocState>(
      listener: (BuildContext context, SettingsBoxesBlocState state) {},
      child: BlocBuilder<SettingsBoxesBloc, SettingsBoxesBlocState>(
        bloc: BlocProvider.of<SettingsBoxesBloc>(context),
        builder: (BuildContext context, SettingsBoxesBlocState state) {
          Widget body = FullscreenLoading(
            title: 'Loading..',
          );

          if (state is SettingsBoxesBlocStateLoading) {
            body = FullscreenLoading(
              title: 'Loading..',
            );
          } else if (state is SettingsBoxesBlocStateNotEmptyBox) {
            body = Fullscreen(
              child: Icon(Icons.do_not_disturb, color: Colors.red, size: 100),
              title: 'Cannot delete lab',
              subtitle: 'Move all plants to another lab first.',
            );
          } else if (state is SettingsBoxesBlocStateLoaded) {
            if (state.boxes.length == 0) {
              body = _renderNoBox(context);
            } else {
              body = ListView.builder(
                itemCount: state.boxes.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      leading: SizedBox(width: 40, height: 40, child: SvgPicture.asset('assets/settings/icon_lab.svg')),
                      onLongPress: () {
                        _deleteBox(context, state.boxes[index]);
                      },
                      onTap: () {
                        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToSettingsBox(state.boxes[index]));
                      },
                      title: Text('${index + 1}. ${state.boxes[index].name}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Tap to open, Long press to delete.'),
                      trailing: SizedBox(
                          width: 30,
                          height: 30,
                          child: SvgPicture.asset(
                              'assets/settings/icon_${state.boxes[index].synced ? '' : 'un'}synced.svg')));
                },
              );
            }
          }
          return Scaffold(
              appBar: SGLAppBar(
                '⚗️',
                fontSize: 35,
                backgroundColor: Colors.yellow,
                titleColor: Colors.green,
                iconColor: Colors.green,
                hideBackButton: !(state is SettingsBoxesBlocStateLoaded),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreateBoxEvent());
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                  ),
                ],
                elevation: 10,
              ),
              body: AnimatedSwitcher(duration: Duration(milliseconds: 200), child: body));
        },
      ),
    );
  }

  Widget _renderNoBox(BuildContext context) {
    return Column(
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
                    child: Text('You have no lab yet', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200)),
                  ),
                  Text('Create your first', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
                  Text('GREEN LAB',
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200, color: Color(0xff3bb30b)),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            GreenButton(
              title: 'CREATE',
              onPressed: () {
                BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreateBoxEvent());
              },
            ),
          ],
        )),
      ],
    );
  }

  void _deleteBox(BuildContext context, Box box) async {
    bool? confirm = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete lab ${box.name}?'),
            content: Text('This can\'t be reverted. Continue?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
    if (confirm ?? false) {
      BlocProvider.of<SettingsBoxesBloc>(context).add(SettingsBoxesBlocEventDeleteBox(box));
    }
  }
}
