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

import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feed_entries/common/media_state.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/card/feed_media_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class FeedMediaLoader extends FeedEntryLoader {
  @override
  Future<FeedEntryStateLoaded> load(FeedEntryStateNotLoaded state) async {
    List<FeedMedia> feedMedias =
        await RelDB.get().feedsDAO.getFeedMedias(state.id);
    List<MediaState> medias = feedMedias
        .map((m) => MediaState(m.id, m.filePath, m.thumbnailPath, m.synced));
    return FeedMediaState(state, medias);
  }
}
