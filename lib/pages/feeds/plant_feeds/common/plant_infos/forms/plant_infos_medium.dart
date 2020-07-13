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
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/widgets/plant_infos_dropdown_input.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/widgets/plant_infos_form.dart';

class PlantInfosMedium extends StatefulWidget {
  final String medium;

  final Function onCancel;
  final Function(String medium) onSubmit;

  PlantInfosMedium(
      {@required this.medium,
      @required this.onCancel,
      @required this.onSubmit});

  @override
  _PlantInfosMediumState createState() => _PlantInfosMediumState();
}

class _PlantInfosMediumState extends State<PlantInfosMedium> {
  String medium;

  @override
  void initState() {
    medium = widget.medium;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlantInfosForm(
      title: 'Medium',
      icon: 'icon_medium.svg',
      onCancel: widget.onCancel,
      onSubmit: () {
        widget.onSubmit(medium);
      },
      child: Column(
        children: <Widget>[
          PlantInfosDropdownInput(
            labelText: 'Medium',
            hintText: 'Choose a medium',
            items: [
              ['SOIL', 'Soil'],
              ['COCO', 'Coco'],
              ['DWC', 'DWC'],
              ['HYDRO', 'Hydro'],
            ],
            value: medium,
            onChanged: (String newValue) {
              setState(() {
                medium = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}
