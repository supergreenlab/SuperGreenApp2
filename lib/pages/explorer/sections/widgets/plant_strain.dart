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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class PlantStrain extends StatelessWidget {
  final PlantSettings plantSettings;

  const PlantStrain({Key? key, required this.plantSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> body = [];
    if (plantSettings.strain == null) {
      body = [
        Text('Strain not set',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ];
    } else {
      body = [
        Text(plantSettings.strain!,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            )),
        Row(
          children: [
            Text('from ', style: TextStyle(fontWeight: FontWeight.w300)),
            Text(plantSettings.seedbank!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3bb30b),
                )),
          ],
        ),
      ];
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 8.0, bottom: 3.0),
              child: SvgPicture.asset("assets/explorer/icon_seeds.svg", width: 35, height: 35),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
