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
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/widgets/plant_infos_widget.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class PlantInfosPage<PIBloc extends Bloc<PlantInfosEvent, PlantInfosState>>
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PIBloc, PlantInfosState>(
        bloc: BlocProvider.of<PIBloc>(context),
        builder: (BuildContext context, PlantInfosState state) {
          if (state is PlantInfosStateLoading) {
            return _renderLoading(context, state);
          }
          return _renderLoaded(context, state);
        });
  }

  Widget _renderLoading(BuildContext context, PlantInfosStateLoading state) {
    return FullscreenLoading(
      title: "Loading plant data",
    );
  }

  Widget _renderLoaded(BuildContext context, PlantInfosStateLoaded state) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 16),
                    child: Text(
                      state.plantInfos.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  PlantInfosWidget(
                      'icon_plant_type.svg', 'Plant type', null, () {}),
                  PlantInfosWidget(
                      'icon_vegging_since.svg', 'Vegging since', null, () {}),
                  PlantInfosWidget('icon_medium.svg', 'Medium', null, () {}),
                  PlantInfosWidget(
                      'icon_dimension.svg', 'Dimensions', null, () {}),
                ]),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight - 100,
                  child: state.plantInfos.thumbnailPath.startsWith("http")
                      ? Image.network(
                          state.plantInfos.thumbnailPath,
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return FullscreenLoading(
                                percent: loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes);
                          },
                        )
                      : Image.file(File(state.plantInfos.thumbnailPath),
                          fit: BoxFit.contain));
            }),
          )),
        ],
      ),
    );
  }
}
