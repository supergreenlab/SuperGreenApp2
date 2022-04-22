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

import 'package:flutter/widgets.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/misc/date_renderer.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class AppBarTitle extends StatelessWidget {
  final Plant? plant;
  final String title;
  final Widget? body;

  final bool showDate;

  const AppBarTitle({Key? key, required this.title, this.plant, this.body, this.showDate = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Color(0xFF494949), fontWeight: FontWeight.bold, fontSize: 25)),
        Container(height: 2, color: Color(0xFF777777)),
        showDate || plant != null
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    showDate
                        ? Text(DateRenderer.renderAbsoluteDate(DateTime.now()),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                        : Container(),
                    plant != null
                        ? Text(DateRenderer.renderSincePhase(PlantSettings.fromJSON(plant!.settings), DateTime.now()),
                            style: TextStyle(fontSize: 16))
                        : Container(),
                  ],
                ),
              )
            : Container(),
        body ?? Container(),
      ],
    );
  }
}
