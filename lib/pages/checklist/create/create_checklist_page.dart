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
import 'package:flutter_svg/svg.dart';
import 'package:super_green_app/data/analytics/matomo.dart';
import 'package:super_green_app/pages/checklist/create/create_checklist_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class CreateChecklistPage extends TraceableStatefulWidget {

  @override
  _CreateChecklistPageState createState() => _CreateChecklistPageState();
}

class _CreateChecklistPageState extends State<CreateChecklistPage> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateChecklistBloc, CreateChecklistBlocState>(
      listener: (BuildContext context, CreateChecklistBlocState state) {
        if (state is CreateChecklistBlocStateLoaded) {}
      },
      child: BlocBuilder<CreateChecklistBloc, CreateChecklistBlocState>(
          bloc: BlocProvider.of<CreateChecklistBloc>(context),
          builder: (context, state) {
            Widget body = FullscreenLoading(
              title: 'Loading..',
            );
            if (state is CreateChecklistBlocStateInit) {
              body = FullscreenLoading();
            } else if (state is CreateChecklistBlocStateLoaded) {
              body = _renderLoaded(context, state);
            }
            return Scaffold(
              appBar: SGLAppBar(
                '🦜',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
              ),
              body: body,
            );
          }),
    );
  }

  Widget _renderLoaded(BuildContext context, CreateChecklistBlocStateLoaded state) {
    return Text("New Checklist");
  }
}
