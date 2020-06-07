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
import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/explorer/explorer_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class ExplorerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExplorerBloc, ExplorerBlocState>(
        bloc: BlocProvider.of<ExplorerBloc>(context),
        builder: (context, state) {
          Widget body;
          if (state is ExplorerBlocStateInit) {
            body = FullscreenLoading();
          } else if (state is ExplorerBlocStateLoaded) {
            body = _renderList(context, state);
          }
          return Scaffold(
              appBar: SGLAppBar(
                'Explorer',
                backgroundColor: Colors.deepPurple,
                titleColor: Colors.yellow,
                iconColor: Colors.white,
                elevation: 10,
              ),
              body: body);
        });
  }

  Widget _renderList(BuildContext context, ExplorerBlocStateLoaded state) {
    return GridView.count(
      crossAxisCount: 2,
      children:
          state.plants.map<Widget>((p) => _renderPlant(context, p)).toList(),
    );
  }

  Widget _renderPlant(BuildContext context, PlantState plant) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return InkWell(
          onTap: () {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(MainNavigateToPublicPlant(plant.id));
          },
          child: Stack(
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Image.network(
                    FeedsAPI().absoluteFileURL(plant.thumbnailPath),
                    fit: BoxFit.cover),
              ),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                '${plant.name}',
                style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
