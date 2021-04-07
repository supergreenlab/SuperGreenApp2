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
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/pages/explorer/models/feedentries.dart';
import 'package:super_green_app/pages/explorer/sections/discussions/discussions_bloc.dart';
import 'package:super_green_app/pages/explorer/sections/section/section_page.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/list_title.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_phase.dart';
import 'package:super_green_app/pages/explorer/sections/widgets/plant_strain.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class DiscussionsPage extends SectionPage<DiscussionsBloc, PublicFeedEntry> {
  Widget itemBuilder(BuildContext context, PublicFeedEntry feedEntry) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffdedede)), borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.network(BackendAPI().feedsAPI.absoluteFileURL(feedEntry.thumbnailPath), fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return FullscreenLoading(
                        percent: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes);
                  }),
                ],
              ),
            ),
            Text(feedEntry.comment),
            Container(height: 4),
            PlantStrain(plantSettings: feedEntry.plantSettings),
            PlantPhase(plantSettings: feedEntry.plantSettings),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(BuildContext context) {
    return ListTitle(
      title: 'Latest discussions',
    );
  }
}
