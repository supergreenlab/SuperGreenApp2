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
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/widgets/plant_infos_form.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/plant_infos/widgets/plant_infos_input.dart';

class PlantInfosStrain extends StatefulWidget {
  final String strain;
  final String seedbank;

  final Function onCancel;
  final Function(String strain, String seedbank) onSubmit;

  PlantInfosStrain(
      {@required this.strain,
      @required this.seedbank,
      @required this.onCancel,
      @required this.onSubmit});

  @override
  _PlantInfosStrainState createState() => _PlantInfosStrainState();
}

class _PlantInfosStrainState extends State<PlantInfosStrain> {
  final TextEditingController strainController = TextEditingController();
  final TextEditingController seedbankController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlantInfosForm(
      title: 'Strain name',
      icon: null,
      onCancel: widget.onCancel,
      onSubmit: () {
        widget.onSubmit(strainController.text, seedbankController.text);
      },
      child: Column(
        children: <Widget>[
          PlantInfosInput(
              controller: strainController,
              initialValue: widget.strain,
              labelText: 'Strain',
              hintText: 'Ex: White widow'),
          PlantInfosInput(
              controller: seedbankController,
              initialValue: widget.seedbank,
              labelText: 'Seedbank',
              hintText: 'Ex: Paradise Seeds'),
        ],
      ),
    );
  }
}
