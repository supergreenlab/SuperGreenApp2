import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/plants/timelapse/dropbox.dart';
import 'package:super_green_app/data/api/backend/plants/timelapse/sglstorage.dart';

abstract class TimelapseSettings extends Equatable {
  TimelapseSettings();

  factory TimelapseSettings.fromMap(String type, Map<String, dynamic> map) {
    if (type == "dropbox") {
      return DropboxSettings.fromMap(map);
    } else if (type == "sglstorage") {
      return SGLStorageSettings.fromMap(map);
    }
    throw 'Unknown type $type';
  }

  factory TimelapseSettings.fromJSON(String type, String json) {
    Map<String, dynamic> map = JsonDecoder().convert(json);
    return TimelapseSettings.fromMap(type, map);
  }

  Map<String, dynamic> toMap();
  String toJSON() => JsonEncoder().convert(toMap());
}
