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

class Comment extends Equatable {
  final String id;
  final String feedEntryID;
  final String userID;

  final String from;

  final String replyTo;
  final String text;
  final String type;

  final String params;

  final DateTime createdAt;

  Comment(
      {this.id,
      this.feedEntryID,
      this.userID,
      this.from,
      this.replyTo,
      this.text,
      this.type,
      this.params,
      this.createdAt});

  @override
  List<Object> get props => [
        id,
        feedEntryID,
        userID,
        from,
        replyTo,
        text,
        type,
        params,
        createdAt,
      ];

  Map<String, dynamic> toMap() {
    return {
      'feedEntryID': this.feedEntryID,
      'replyTo': this.replyTo,
      'text': this.text,
      'type': this.type,
      'params': this.params,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      feedEntryID: map['feedEntryID'],
      userID: map['userID'],
      from: map['from'],
      replyTo: map['replyTo'],
      text: map['text'],
      type: map['type'],
      params: map['params'],
      createdAt: DateTime.parse(map['cat'] as String).toLocal(),
    );
  }

  factory Comment.fromJSON(String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return Comment.fromMap(map);
  }
  String toJSON() => JsonEncoder().convert(toMap());
}
