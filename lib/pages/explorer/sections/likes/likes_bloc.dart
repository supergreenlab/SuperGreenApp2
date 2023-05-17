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

import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/pages/explorer/models/feedentries.dart';
import 'package:super_green_app/pages/explorer/sections/section/section_bloc.dart';

class LikesBloc extends SectionBloc<PublicFeedEntry> {
  @override
  int get nItemsLoad => 20;

  Future<List<dynamic>> loadItems(int n, int offset) async {
    List<dynamic> likedFeedEntries = await BackendAPI().feedsAPI.publicLikedFeedEntries(n, offset);
    List<dynamic> likedComments = await BackendAPI().feedsAPI.publicLikedComments(n, offset);
    List<Map<String, dynamic>> allLikes = [...likedFeedEntries, ...likedComments];
    allLikes.sort((l1, l2) {
      return DateTime.parse(l2['likeDate']).difference(DateTime.parse(l1['likeDate'])).inSeconds;
    });
    return allLikes;
  }

  PublicFeedEntry itemFromMap(Map<String, dynamic> map) => PublicFeedEntry.fromMap(map);
}
