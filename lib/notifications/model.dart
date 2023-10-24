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
import 'package:super_green_app/data/logger/logger.dart';

enum NotificationDataType {
  PLANT_COMMENT,
  PLANT_COMMENT_REPLY,
  REMINDER,
  ALERT,
  LIKE_PLANT_COMMENT,
  LIKE_PLANT_FEEDENTRY,
  FOLLOWED_PLANT_ACTIVITY,
  NEW_FOLLOWER,
  DEVICE_UNREACHABLE,
  LIVECAM_UNREACHABLE,
  NEW_TIMELAPSE,
  CHECKLIST_SEED_TRIGGERED,
}

abstract class NotificationData extends Equatable {
  final Map<String, dynamic> data;

  NotificationData({required this.data, NotificationDataType? type, String? title, String? body, int? id}) {
    data['type'] = (type != null ? EnumToString.convertToString(type) : null) ?? data['type'];
    data['id'] = id ?? data['id'];
    data['title'] = title ?? data['title'];
    data['body'] = body ?? data['body'];
  }

  NotificationDataType get type => EnumToString.fromString(NotificationDataType.values, data['type'])!;
  int get id => data['id'];
  String get title => data['title'];
  String get body => data['body'];

  factory NotificationData.fromMap(Map<String, dynamic> data) {
    switch (EnumToString.fromString(NotificationDataType.values, data['type'])) {
      case NotificationDataType.PLANT_COMMENT:
        return NotificationDataPlantComment.fromMap(data);
      case NotificationDataType.PLANT_COMMENT_REPLY:
        return NotificationDataPlantCommentReply.fromMap(data);
      case NotificationDataType.REMINDER:
        return NotificationDataReminder.fromMap(data);
      case NotificationDataType.ALERT:
        return NotificationDataAlert.fromMap(data);
      case NotificationDataType.LIKE_PLANT_COMMENT:
        return NotificationDataLikePlantComment.fromMap(data);
      case NotificationDataType.LIKE_PLANT_FEEDENTRY:
        return NotificationDataLikePlantFeedEntry.fromMap(data);
      case NotificationDataType.FOLLOWED_PLANT_ACTIVITY:
        return NotificationDataFollowedPlantActivity.fromMap(data);
      case NotificationDataType.NEW_FOLLOWER:
        return NotificationDataNewFollower.fromMap(data);
      case NotificationDataType.DEVICE_UNREACHABLE:
        return NotificationDataDeviceUnreachable.fromMap(data);
      case NotificationDataType.LIVECAM_UNREACHABLE:
        return NotificationDataLivecamUnreachable.fromMap(data);
      case NotificationDataType.NEW_TIMELAPSE:
        return NotificationDataNewTimelapse.fromMap(data);
      case NotificationDataType.CHECKLIST_SEED_TRIGGERED:
        return NotificationDataChecklistSeedTriggered.fromMap(data);
      default:
        try {
          throw 'Unknown type ${data['type']}';
        } catch (e, trace) {
          Logger.logError(e, trace, data: data);
          throw e;
        }
    }
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

class NotificationDataPlantComment extends NotificationData {
  NotificationDataPlantComment(
      {int? id,
      String? title,
      String? body,
      required String plantID,
      required String feedEntryID,
      required CommentType commentType})
      : super(
          id: id,
          data: {
            'plantID': plantID,
            'feedEntryID': feedEntryID,
            'commentType': EnumToString.convertToString(commentType)
          },
          type: NotificationDataType.PLANT_COMMENT,
          title: title,
          body: body,
        );
  NotificationDataPlantComment.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
  String get feedEntryID => data['feedEntryID'];
  CommentType get commentType => EnumToString.fromString(CommentType.values, data['commentType'])!;
}

class NotificationDataPlantCommentReply extends NotificationData {
  NotificationDataPlantCommentReply({
    int? id,
    String? title,
    String? body,
    required String plantID,
    required String feedEntryID,
    required String commentID,
    String? replyTo,
  }) : super(
          id: id,
          data: {
            'plantID': plantID,
            'feedEntryID': feedEntryID,
            'commentID': commentID,
            'replyTo': replyTo,
          },
          type: NotificationDataType.PLANT_COMMENT,
          title: title,
          body: body,
        );
  NotificationDataPlantCommentReply.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
  String get feedEntryID => data['feedEntryID'];
  String get commentID => data['commentID'];
  String get replyTo => data['replyTo'];
}

class NotificationDataReminder extends NotificationData {
  NotificationDataReminder({int? id, String? title, String? body, required int plantID})
      : super(
            id: id,
            data: {
              'plantID': plantID,
            },
            type: NotificationDataType.REMINDER,
            title: title,
            body: body);
  NotificationDataReminder.fromMap(Map<String, dynamic> data) : super(data: data);

  int get plantID => data['plantID'];
}

class NotificationDataAlert extends NotificationData {
  NotificationDataAlert({int? id, String? title, String? body, required String plantID})
      : super(
            id: id,
            data: {
              'plantID': plantID,
            },
            type: NotificationDataType.ALERT,
            title: title,
            body: body);
  NotificationDataAlert.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
}

class NotificationDataLikePlantComment extends NotificationData {
  NotificationDataLikePlantComment(
      {int? id,
      String? title,
      String? body,
      required String plantID,
      required String feedEntryID,
      required String commentID,
      String? replyTo})
      : super(
          id: id,
          data: {'plantID': plantID, 'feedEntryID': feedEntryID, 'commentID': commentID, 'replyTo': replyTo},
          type: NotificationDataType.LIKE_PLANT_COMMENT,
          title: title,
          body: body,
        );
  NotificationDataLikePlantComment.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
  String get feedEntryID => data['feedEntryID'];
  String get commentID => data['commentID'];
  String get replyTo => data['replyTo'];
}

class NotificationDataLikePlantFeedEntry extends NotificationData {
  NotificationDataLikePlantFeedEntry(
      {int? id, String? title, String? body, required String plantID, required String feedEntryID})
      : super(
          id: id,
          data: {'plantID': plantID, 'feedEntryID': feedEntryID},
          type: NotificationDataType.LIKE_PLANT_FEEDENTRY,
          title: title,
          body: body,
        );
  NotificationDataLikePlantFeedEntry.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
  String get feedEntryID => data['feedEntryID'];
}

class NotificationDataFollowedPlantActivity extends NotificationData {
  NotificationDataFollowedPlantActivity({int? id, String? title, String? body, required String plantID})
      : super(
            id: id,
            data: {
              'plantID': plantID,
            },
            type: NotificationDataType.FOLLOWED_PLANT_ACTIVITY,
            title: title,
            body: body);
  NotificationDataFollowedPlantActivity.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
}

class NotificationDataNewFollower extends NotificationData {
  NotificationDataNewFollower({int? id, String? title, String? body, required String plantID})
      : super(
            id: id,
            data: {
              'plantID': plantID,
            },
            type: NotificationDataType.NEW_FOLLOWER,
            title: title,
            body: body);
  NotificationDataNewFollower.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
}

class NotificationDataDeviceUnreachable extends NotificationData {
  NotificationDataDeviceUnreachable({int? id, String? title, String? body, required String deviceID})
      : super(
            id: id,
            data: {
              'deviceID': deviceID,
            },
            type: NotificationDataType.DEVICE_UNREACHABLE,
            title: title,
            body: body);
  NotificationDataDeviceUnreachable.fromMap(Map<String, dynamic> data) : super(data: data);

  String get deviceID => data['deviceID'];
}

class NotificationDataLivecamUnreachable extends NotificationData {
  NotificationDataLivecamUnreachable({int? id, String? title, String? body, required String plantID})
      : super(
            id: id,
            data: {
              'plantID': plantID,
            },
            type: NotificationDataType.LIVECAM_UNREACHABLE,
            title: title,
            body: body);
  NotificationDataLivecamUnreachable.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
}

class NotificationDataNewTimelapse extends NotificationData {
  NotificationDataNewTimelapse({int? id, String? title, String? body, required String plantID})
      : super(
          id: id,
          title: title,
          body: body,
          data: {
            'plantID': plantID,
          },
          type: NotificationDataType.NEW_TIMELAPSE,
        );
  NotificationDataNewTimelapse.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
}

class NotificationDataChecklistSeedTriggered extends NotificationData {
  NotificationDataChecklistSeedTriggered(
      {int? id,
      String? title,
      String? body,
      required String plantID,
      required String checklistID,
      required CommentType checklistSeedID,})
      : super(
          id: id,
          data: {
            'plantID': plantID,
            'checklistID': checklistID,
            'checklistSeedID': checklistSeedID,
          },
          type: NotificationDataType.CHECKLIST_SEED_TRIGGERED,
          title: title,
          body: body,
        );
  NotificationDataChecklistSeedTriggered.fromMap(Map<String, dynamic> data) : super(data: data);

  String get plantID => data['plantID'];
  String get checklistID => data['checklistID'];
  String get checklistSeedID => data['checklistSeedID'];
}