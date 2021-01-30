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

import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NotificationDataType {
  COMMENT,
  REMINDER,
}

abstract class NotificationData extends Equatable {
  final Map<String, dynamic> data;

  NotificationData(
      {this.data,
      NotificationDataType type,
      String title,
      String body,
      int id}) {
    data['type'] = (type != null ? EnumToString.convertToString(type) : null) ??
        data['type'];
    data['id'] = id ?? data['id'];
    data['title'] = title ?? data['title'];
    data['body'] = body ?? data['body'];
  }

  NotificationDataType get type =>
      EnumToString.fromString(NotificationDataType.values, data['type']);
  int get id => data['id'];
  String get title => data['title'];
  String get body => data['body'];

  factory NotificationData.fromMap(Map<String, dynamic> data) {
    switch (
        EnumToString.fromString(NotificationDataType.values, data['type'])) {
      case NotificationDataType.COMMENT:
        return NotificationDataComment.fromMap(data);
      case NotificationDataType.REMINDER:
        return NotificationDataComment.fromMap(data);
    }
    throw 'Unknown type ${data['type']}';
  }

  factory NotificationData.fromJSON(String data) {
    Map<String, dynamic> map = JsonDecoder().convert(data);
    return NotificationData.fromMap(map);
  }

  Map<String, dynamic> toMap() => data;

  String toJSON() => JsonEncoder().convert(toMap());

  @override
  List<Object> get props => [
        data,
      ];
}

class NotificationDataComment extends NotificationData {
  NotificationDataComment(
      {int id,
      String title,
      String body,
      @required String plantID,
      @required String feedEntryID})
      : super(
          id: id,
          data: {'plantID': plantID, 'feedEntryID': feedEntryID},
          type: NotificationDataType.COMMENT,
          title: title,
          body: body,
        );
  NotificationDataComment.fromMap(Map<String, dynamic> data)
      : super(data: data);

  String get plantID => data['plantID'];
  String get feedEntryID => data['feedEntryID'];
}

class NotificationDataReminder extends NotificationData {
  NotificationDataReminder(
      {int id, String title, String body, @required int plantID})
      : super(
            id: id,
            data: {
              'plantID': plantID,
            },
            type: NotificationDataType.REMINDER,
            title: title,
            body: body);
  NotificationDataReminder.fromMap(Map<String, dynamic> data)
      : super(data: data);

  int get plantID => data['plantID'];
}
