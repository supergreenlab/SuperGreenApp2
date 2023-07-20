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
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/checklist/checklist_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class ChecklistPage extends TraceableStatefulWidget {

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChecklistBloc, ChecklistBlocState>(
      listener: (BuildContext context, ChecklistBlocState state) {
        if (state is ChecklistBlocStateLoaded) {}
      },
      child: BlocBuilder<ChecklistBloc, ChecklistBlocState>(
          bloc: BlocProvider.of<ChecklistBloc>(context),
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is ChecklistBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is ChecklistBlocStateLoaded) {
              body = _renderLoaded(context, state);
            }
            return Scaffold(
              appBar: SGLAppBar(
                '🦜',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
                actions: state is ChecklistBlocStateLoaded ? [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToCreateChecklist(state.checklist));
                    },
                  ),
                ] : [],
              ),
              body: body,
            );
          }),
    );
  }

  Widget _renderLoaded(BuildContext context, ChecklistBlocStateLoaded state) {
    return Text("Checklist loaded pouet 2");
  }
}
