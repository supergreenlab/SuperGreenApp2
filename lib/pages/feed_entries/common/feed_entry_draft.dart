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

import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class MediaDraftState extends Equatable {
  final String filePath;
  final String thumbnailPath;

  MediaDraftState(this.filePath, this.thumbnailPath);

  factory MediaDraftState.fromMap(Map<String, dynamic> map) {
    return MediaDraftState(map['filePath'], (map['thumbnailPath']));
  }

  Map<String, dynamic> toMap() {
    return {
      'filePath': filePath,
      'thumbnailPath': thumbnailPath,
    };
  }

  factory MediaDraftState.fromFeedMediaCompanion(FeedMediasCompanion feedMediasCompanion) {
    return MediaDraftState(feedMediasCompanion.filePath.value, feedMediasCompanion.thumbnailPath.value);
  }

  FeedMediasCompanion toFeedMediaCompanion() {
    return FeedMediasCompanion(
      filePath: Value(filePath),
      thumbnailPath: Value(thumbnailPath),
    );
  }

  @override
  List<Object> get props => [filePath, thumbnailPath];
}

abstract class FeedEntryDraftState extends Equatable {
  final int? draftID;

  FeedEntryDraftState(this.draftID);

  FeedEntryDraftState copyWithDraftID(int draftID);
  String toJSON();
}
