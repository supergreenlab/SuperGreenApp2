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
import 'package:super_green_app/pages/feed_entries/entry_params/feed_measure.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/card/feed_measure_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/local/loaders/local_feed_entry_loader.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';

class FeedMeasureLoader extends LocalFeedEntryLoader {
  
  FeedMeasureLoader(Function(FeedBlocEvent) add) : super(add);

  @override
  Future<FeedEntryStateLoaded> load(FeedEntryStateNotLoaded state) async {
    FeedMeasureParams params = state.params;
    MediaState previous;
    RelDB db = RelDB.get();
    if (params.previous != null) {
      FeedMedia previousMedia;
      if (params.previous is int) {
        previousMedia = await db.feedsDAO.getFeedMedia(params.previous);
      } else if (params.previous is String) {
        previousMedia =
            await db.feedsDAO.getFeedMediaForServerID(params.previous);
      }
      previous = MediaState(previousMedia.id, previousMedia.filePath,
          previousMedia.thumbnailPath, previousMedia.synced);
    }

    List<FeedMedia> currentMedia =
        await db.feedsDAO.getFeedMedias(state.feedEntryID);
    MediaState current = MediaState(
        currentMedia[0].id,
        currentMedia[0].filePath,
        currentMedia[0].thumbnailPath,
        currentMedia[0].synced);
    return FeedMeasureState(state, previous, current);
  }

  @override
  Future<void> close() async {}
}
