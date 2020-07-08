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

class PlantInfosStrain extends StatefulWidget {
  final String strain;
  final String seedbank;

  final Function onCancel;
  final Function onSubmit;

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
      onSubmit: widget.onSubmit,
      child: Column(
        children: <Widget>[
          _renderInputField(
              strainController, widget.strain, 'Strain', 'Ex: White widow'),
          _renderInputField(seedbankController, widget.seedbank, 'Seedbank',
              'Ex: Paradise Seeds'),
        ],
      ),
    );
  }

  Widget _renderInputField(TextEditingController controller,
      String initialValue, String labelText, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          filled: true,
          fillColor: Colors.white10,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white30),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
        style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
        initialValue: widget.strain,
        controller: strainController,
      ),
    );
  }
}
