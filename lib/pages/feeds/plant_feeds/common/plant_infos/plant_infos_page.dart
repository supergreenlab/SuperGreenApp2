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
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/forms/plant_infos_plant_type.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/forms/plant_infos_strain.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/plant_infos_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/widgets/plant_infos_widget.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class PlantInfosPage<PIBloc extends Bloc<PlantInfosEvent, PlantInfosState>>
    extends StatefulWidget {
  @override
  _PlantInfosPageState<PIBloc> createState() => _PlantInfosPageState<PIBloc>();
}

class _PlantInfosPageState<
        PIBloc extends Bloc<PlantInfosEvent, PlantInfosState>>
    extends State<PlantInfosPage<PIBloc>> {
  String form;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PIBloc, PlantInfosState>(
        bloc: BlocProvider.of<PIBloc>(context),
        builder: (BuildContext context, PlantInfosState state) {
          if (state is PlantInfosStateLoading) {
            return _renderLoading(context, state);
          }
          if (form == null) {
            return _renderLoaded(context, state);
          } else {
            return Stack(
              children: <Widget>[
                _renderLoaded(context, state),
                _renderForm(context, state),
              ],
            );
          }
        });
  }

  Widget _renderLoading(BuildContext context, PlantInfosStateLoading state) {
    return FullscreenLoading(
      title: "Loading plant data",
    );
  }

  Widget _renderLoaded(BuildContext context, PlantInfosStateLoaded state) {
    String strain;

    if (state.plantInfos.settings.strain != null &&
        state.plantInfos.settings.seedbank != null) {
      strain =
          '# ${state.plantInfos.settings.strain}\nfrom **${state.plantInfos.settings.seedbank}**';
    } else if (state.plantInfos.settings.strain != null) {
      strain = '# ${state.plantInfos.settings.strain}';
    }
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
                  PlantInfosWidget(
                      title: 'Strain name',
                      value: strain,
                      onEdit: () => _openForm('STRAIN')),
                  PlantInfosWidget(
                      icon: 'icon_plant_type.svg',
                      title: 'Plant type',
                      value: state.plantInfos.settings.plantType,
                      onEdit: () => _openForm('PLANT_TYPE')),
                  PlantInfosWidget(
                      icon: 'icon_vegging_since.svg',
                      title: 'Vegging since',
                      value: null,
                      onEdit: () => _openForm('STRAIN')),
                  PlantInfosWidget(
                      icon: 'icon_medium.svg',
                      title: 'Medium',
                      value: state.plantInfos.settings.medium,
                      onEdit: () => _openForm('STRAIN')),
                  PlantInfosWidget(
                      icon: 'icon_dimension.svg',
                      title: 'Dimensions',
                      value:
                          '${state.plantInfos.settings.width}x${state.plantInfos.settings.height}x${state.plantInfos.settings.depth}',
                      onEdit: () => _openForm('STRAIN')),
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

  Widget _renderForm(BuildContext context, PlantInfosStateLoaded state) {
    final forms = {
      'STRAIN': () => PlantInfosStrain(
            strain: state.plantInfos.settings.strain,
            seedbank: state.plantInfos.settings.seedbank,
            onCancel: () => _openForm(null),
            onSubmit: () => _openForm(null),
          ),
      'PLANT_TYPE': () => PlantInfosPlantType(
            plantType: state.plantInfos.settings.plantType,
            onCancel: () => _openForm(null),
            onSubmit: () => _openForm(null),
          ),
    };
    return Container(
      color: Color(0xff063047).withAlpha(127),
      child: Column(
        children: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xff063047),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: Colors.white)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: forms[form](),
                )),
          )),
        ],
      ),
    );
  }

  void _openForm(String form) {
    setState(() {
      this.form = form;
    });
  }
}