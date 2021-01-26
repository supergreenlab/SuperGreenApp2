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

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/feeds/models/comments.dart';

abstract class FeedEntrySocialState extends Equatable {}

class FeedEntrySocialStateNotLoaded extends FeedEntrySocialState {
  @override
  List<Object> get props => [];
}

class FeedEntrySocialStateLoaded extends FeedEntrySocialState {
  final bool isLiked;
  final bool isBookmarked;
  final int nComments;
  final int nLikes;
  final List<Comment> comments;

  FeedEntrySocialStateLoaded(
      {this.isLiked,
      this.isBookmarked,
      this.nComments,
      this.nLikes,
      this.comments});

  FeedEntrySocialStateLoaded copyWith(
      {bool isLiked,
      bool isBookmarked,
      int nComments,
      int nLikes,
      List<Comment> comments}) {
    return FeedEntrySocialStateLoaded(
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      nComments: nComments ?? this.nComments,
      nLikes: nLikes ?? this.nLikes,
      comments: comments ?? this.comments,
    );
  }

  factory FeedEntrySocialStateLoaded.fromMap(Map<String, dynamic> map) =>
      FeedEntrySocialStateLoaded(
          isLiked: map['liked'],
          isBookmarked: map['bookmarked'],
          nComments: map['nComments'],
          nLikes: map['nLikes']);

  @override
  List<Object> get props => [
        isLiked,
        isBookmarked,
        nComments,
        nLikes,
        comments,
      ];
}
