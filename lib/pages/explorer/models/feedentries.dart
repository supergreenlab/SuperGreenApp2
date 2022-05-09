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

import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entries_param_helpers.dart';
import 'package:super_green_app/pages/feed_entries/entry_params/feed_entry_params.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class PublicFeedEntry extends Equatable {
  final String id;
  final String userID;
  final String feedID;
  final DateTime date;
  final String type;

  final PlantSettings plantSettings;
  final BoxSettings boxSettings;

  final FeedEntryParams params;
  final Map<String, dynamic> meta;

  final bool? liked;
  final bool? bookmarked;
  final int? nComments;
  final int? nLikes;

  final String? plantID;
  final String? plantName;
  final String? plantThumbnailPath;

  final String? nickname;
  final String? pic;
  final String? commentID;
  final String? comment;
  final String? replyTo;
  final CommentType? commentType;
  final DateTime? commentDate;

  final DateTime? likeDate;
  final String? thumbnailPath;

  PublicFeedEntry(
      {required this.id,
      required this.userID,
      required this.feedID,
      required this.date,
      required this.type,
      required this.plantSettings,
      required this.boxSettings,
      required this.params,
      required this.meta,
      this.liked,
      this.bookmarked,
      this.nComments,
      this.nLikes,
      this.plantID,
      this.plantName,
      this.plantThumbnailPath,
      this.nickname,
      this.pic,
      this.commentID,
      this.comment,
      this.replyTo,
      this.commentType,
      this.commentDate,
      this.likeDate,
      this.thumbnailPath});

  factory PublicFeedEntry.fromMap(Map<String, dynamic> map) => PublicFeedEntry(
      id: map['id'],
      userID: map['userID'],
      feedID: map['feedID'],
      date: DateTime.parse(map['date'] as String),
      type: map['type'],
      plantSettings: PlantSettings.fromJSON(map['plantSettings'] ?? '{}'),
      boxSettings: BoxSettings.fromJSON(map['boxSettings'] ?? '{}'),
      params: FeedEntriesParamHelpers.paramForFeedEntryType(map['type'], map['params'] ?? '{}'),
      meta: JsonDecoder().convert(map['meta'] ?? '{}'),
      liked: map['liked'],
      bookmarked: map['bookmarked'],
      nComments: map['nComments'],
      nLikes: map['nLikes'],
      plantID: map['plantID'],
      plantName: map['plantName'],
      plantThumbnailPath: map['plantThumbnailPath'],
      nickname: map['nickname'],
      pic: map['pic'],
      commentID: map['commentID'],
      comment: map['comment'],
      replyTo: map['commentReplyTo'],
      commentType: map['commentType'] == null ? null : EnumToString.fromString(CommentType.values, map['commentType']),
      commentDate: map['commentDate'] == null ? null : DateTime.parse(map['commentDate'] as String),
      likeDate: map['likeDate'] == null ? null : DateTime.parse(map['likeDate'] as String),
      thumbnailPath: map['thumbnailPath']);

  @override
  List<Object?> get props => [
        id,
        userID,
        feedID,
        date,
        type,
        plantSettings,
        boxSettings,
        params,
        meta,
        liked,
        bookmarked,
        nComments,
        nLikes,
        plantID,
        plantName,
        plantThumbnailPath,
        nickname,
        pic,
        commentID,
        comment,
        replyTo,
        commentType,
        commentDate,
        likeDate,
        thumbnailPath,
      ];
}
