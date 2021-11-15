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

class Bookmark extends Equatable {
  final String? id;
  final String feedEntryID;
  final String? userID;

  final DateTime? createdAt;

  Bookmark({
    this.id,
    required this.feedEntryID,
    this.userID,
    this.createdAt,
  });

  Bookmark copyWith({
    String? id,
    String? feedEntryID,
    String? userID,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      feedEntryID: feedEntryID ?? this.feedEntryID,
      userID: userID ?? this.userID,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        feedEntryID,
        userID,
        createdAt,
      ];

  Map<String, dynamic> toMap() {
    return {
      'feedEntryID': this.feedEntryID,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'],
      feedEntryID: map['feedEntryID'],
      userID: map['userID'],
      createdAt: DateTime.parse(map['cat'] as String).toLocal(),
    );
  }

  factory Bookmark.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return Bookmark.fromMap(map);
  }
  String toJSON() => JsonEncoder().convert(toMap());
}
