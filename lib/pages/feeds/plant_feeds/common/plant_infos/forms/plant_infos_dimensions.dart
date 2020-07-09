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

class PlantInfosDimensions extends StatefulWidget {
  final int width;
  final int height;
  final int depth;

  final Function onCancel;
  final Function(int width, int height, int depth) onSubmit;

  PlantInfosDimensions(
      {@required this.onCancel,
      @required this.onSubmit,
      @required this.width,
      @required this.height,
      @required this.depth});

  @override
  _PlantInfosDimensionsState createState() => _PlantInfosDimensionsState();
}

class _PlantInfosDimensionsState extends State<PlantInfosDimensions> {
  final TextEditingController dimensionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlantInfosForm(
      title: 'Dimensions',
      icon: 'icon_dimension.svg',
      onCancel: widget.onCancel,
      onSubmit: () {
        widget.onSubmit(0, 0, 0);
      },
      child: Column(
        children: <Widget>[],
      ),
    );
  }
}