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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ControllerMetric extends Equatable {
  final String controllerID;
  final String key;
  final dynamic value;

  ControllerMetric({this.controllerID, this.key, this.value});

  @override
  List<Object> get props => [controllerID, key, value];

  factory ControllerMetric.fromMap(Map<String, dynamic> map) {
    return ControllerMetric(controllerID: map['controllerID'], key: map['key'], value: map['value']);
  }

  factory ControllerMetric.fromJSON(String json) {
    return ControllerMetric.fromMap(JsonDecoder().convert(json));
  }
}

class DeviceWebsocket {
  final Device device;
  WebSocketChannel channel;
  StreamSubscription sub;

  DeviceWebsocket(this.device);

  void connect() async {
    String url = '${BackendAPI().websocketServerHost}/device/${device.identifier}/stream';
    channel = IOWebSocketChannel(await WebSocket.connect(url, headers: {
      'Authentication': 'Bearer ${AppDB().getAppData().jwt}',
    }));
    sub = channel.stream.listen((message) async {
      ControllerMetric cm = ControllerMetric.fromJSON(message);
      Param param = await RelDB.get().devicesDAO.getParam(device.id, cm.key);
      if (param == null) {
        Logger.log("Unknown param ${cm.key}");
        return;
      }
      dynamic value = cm.value;
      if (value is String) {
        await RelDB.get().devicesDAO.updateParam(param.copyWith(svalue: value));
      } else if (value is double) {
        await RelDB.get().devicesDAO.updateParam(param.copyWith(ivalue: value.round()));
      } else if (value is int) {
        await RelDB.get().devicesDAO.updateParam(param.copyWith(ivalue: value));
      }
      Logger.log("Updated parameter ${cm.key} to value ${cm.value}");
    }, onError: (e) async {
      Logger.logError(e, null);
      await Future.delayed(Duration(seconds: 3));
      connect();
    }, onDone: () async {
      await Future.delayed(Duration(seconds: 3));
      connect();
    });
  }

  void close() {
    sub.cancel();
  }
}
