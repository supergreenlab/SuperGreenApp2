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
import 'package:intl/intl.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/explorer/models/plants.dart';
import 'package:super_green_app/pages/explorer/sections/last_update/last_update_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/section/section_page.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/list_title.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_phase.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_strain.dart';
import 'package:super_green_app/widgets/item_loading.dart';

class LastUpdatePage extends SectionPage<LastUpdateBloc, PublicPlant> {
  @override
  double get listItemWidth {
    return 250;
  }

  @override
  double get listHeight {
    return 228;
  }

  Widget itemBuilder(BuildContext context, PublicPlant plant) {
    String format = AppDB().getUserSettings().freedomUnits! ? 'MM/dd/yyyy' : 'dd/MM/yyyy';
    return InkWell(
      onTap: () {
        BlocProvider.of<MainNavigatorBloc>(context).add(MainNavigateToPublicPlant(
          plant.id,
          name: plant.name,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffdedede)), borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(BackendAPI().feedsAPI.absoluteFileURL(plant.thumbnailPath!),
                            fit: BoxFit.cover, headers: {'Host': BackendAPI().storageServerHostHeader},
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Container(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: ItemLoading(),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            plant.name,
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1.5, -1.5),
                                  color: Colors.white),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1.5, -1.5),
                                  color: Colors.white),
                              Shadow(
                                  // topRight
                                  offset: Offset(1.5, 1.5),
                                  color: Colors.white),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1.5, 1.5),
                                  color: Colors.white),
                            ]),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            color: Colors.black45,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                                vertical: 2.0,
                              ),
                              child: Text(
                                'Last update: ${DateFormat(format).format(plant.lastUpdate)}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(height: 4),
              PlantStrain(plantSettings: plant.settings),
              PlantPhase(plantSettings: plant.settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(BuildContext context) {
    return ListTitle(
      title: 'Last plant updates',
    );
  }
}
