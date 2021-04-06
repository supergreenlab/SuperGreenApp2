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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entries_param_helpers.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';

class PublicFeedEntry extends Equatable {
  final String id;
  final String userID;
  final String feedID;
  final DateTime date;
  final String type;

  final FeedEntryParams params;
  final Map<String, dynamic> meta;

  final bool liked;
  final bool bookmarked;
  final int nComments;
  final int nLikes;

  final String plantID;
  final String plantName;

  final String commentID;
  final String comment;

  final DateTime likeDate;
  final String thumbnailPath;

  PublicFeedEntry(
      {this.id,
      this.userID,
      this.feedID,
      this.date,
      this.type,
      this.params,
      this.meta,
      this.liked,
      this.bookmarked,
      this.nComments,
      this.nLikes,
      this.plantID,
      this.plantName,
      this.commentID,
      this.comment,
      this.likeDate,
      this.thumbnailPath});

  factory PublicFeedEntry.fromMap(Map<String, dynamic> map) => PublicFeedEntry(
      id: map['id'],
      userID: map['userID'],
      feedID: map['feedID'],
      date: DateTime.parse(map['date'] as String),
      type: map['type'],
      params: FeedEntriesParamHelpers.paramForFeedEntryType(map['type'], map['params'] ?? '{}'),
      meta: JsonDecoder().convert(map['meta'] ?? '{}'),
      liked: map['liked'],
      bookmarked: map['bookmarked'],
      nComments: map['nComments'],
      nLikes: map['nLikes'],
      plantID: map['plantID'],
      plantName: map['plantName'],
      commentID: map['commentID'],
      comment: map['comment'],
      likeDate: map['likeDate'] == null ? null : DateTime.parse(map['likeDate'] as String),
      thumbnailPath: map['thumbnailPath']);

  @override
  List<Object> get props => [
        id,
        userID,
        feedID,
        date,
        type,
        params,
        meta,
        liked,
        bookmarked,
        nComments,
        nLikes,
        plantID,
        plantName,
        commentID,
        comment,
        likeDate,
        thumbnailPath,
      ];
}
