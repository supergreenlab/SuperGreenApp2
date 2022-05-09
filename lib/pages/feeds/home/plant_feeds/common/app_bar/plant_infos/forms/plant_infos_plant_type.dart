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
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/widgets/plant_infos_dropdown_input.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/common/app_bar/plant_infos/widgets/plant_infos_form.dart';

class PlantInfosPlantType extends StatefulWidget {
  final String? plantType;

  final Function onCancel;
  final Function(String? plantType) onSubmit;

  PlantInfosPlantType({required this.plantType, required this.onCancel, required this.onSubmit});

  @override
  _PlantInfosPlantTypeState createState() => _PlantInfosPlantTypeState();
}

class _PlantInfosPlantTypeState extends State<PlantInfosPlantType> {
  late String? plantType;

  @override
  void initState() {
    plantType = widget.plantType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlantInfosForm(
      title: 'Plant type',
      icon: 'icon_plant_type.svg',
      onCancel: widget.onCancel,
      onSubmit: () {
        widget.onSubmit(plantType);
      },
      child: Column(
        children: <Widget>[
          PlantInfosDropdownInput(
            labelText: 'Plant type',
            hintText: 'Choose a type',
            items: [
              ['PHOTO', 'Photoperiod'],
              ['AUTO', 'Auto'],
            ],
            value: plantType,
            onChanged: (String? newValue) {
              setState(() {
                plantType = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}
