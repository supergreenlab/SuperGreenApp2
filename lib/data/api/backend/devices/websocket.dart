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

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:uuid/uuid.dart';

class ControllerMetric extends Equatable {
  final String controllerID;
  final String key;
  final dynamic value;

  ControllerMetric({required this.controllerID, required this.key, required this.value});

  @override
  List<Object> get props => [controllerID, key, value];

  factory ControllerMetric.fromMap(Map<String, dynamic> map) {
    return ControllerMetric(controllerID: map['controllerID'], key: map['key'], value: map['value']);
  }

  factory ControllerMetric.fromJSON(String json) {
    return ControllerMetric.fromMap(JsonDecoder().convert(json));
  }
}

class ControllerLog extends Equatable {
  final String controllerID;
  final String module;
  final String msg;

  ControllerLog({required this.controllerID, required this.module, required this.msg});

  @override
  List<Object> get props => [controllerID, module, msg];

  factory ControllerLog.fromMap(Map<String, dynamic> map) {
    return ControllerLog(controllerID: map['controllerID'], module: map['module'], msg: map['msg']);
  }

  factory ControllerLog.fromJSON(String json) {
    return ControllerLog.fromMap(JsonDecoder().convert(json));
  }
}

class DeviceWebsocket {
  static Map<String, DeviceWebsocket> websockets = {};

  Device device;
  late WebSocketChannel channel;
  StreamSubscription? sub;
  StreamSubscription? deviceSub;

  Timer? pingTimer;
  Timer? timeout;

  Map<String, Completer> commandCompleters = {};

  DeviceWebsocket(this.device) {
    deviceSub = RelDB.get().devicesDAO.watchDevice(device.id).listen((Device newDevice) {
      this.device = newDevice;
    });
  }

  static DeviceWebsocket? getWebsocket(Device device) {
    return websockets[device.serverID];
  }

  static Future<DeviceWebsocket> createIfNotAlready(Device device) async {
    DeviceWebsocket? socket;
    if ((socket = DeviceWebsocket.websockets[device.serverID]) == null) {
      socket = DeviceWebsocket(device);
      DeviceWebsocket.websockets[device.serverID!] = socket;
      socket.connect();
    }
    return socket!;
  }

  static void deleteIfExists(String serverID) {
    DeviceWebsocket? dw = DeviceWebsocket.websockets[serverID];
    if (dw == null) {
      return;
    }
    dw.close();
    websockets.remove(dw);
  }

  void connect() async {
    await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isRemote: Value(false)));
    String url = '${BackendAPI().websocketServerHost}/device/${device.serverID}/stream';
    try {
      channel = IOWebSocketChannel(await WebSocket.connect(url, headers: {
        'Authorization': 'Bearer ${AppDB().getAppData().jwt}',
      }));
    } catch (e, trace) {
      Logger.logError(e, trace);
      await Future.delayed(Duration(seconds: 5));
      connect();
      return;
    }

    sub = channel.stream.listen((message) async {
      bool remoteEnabled = AppDB().getDeviceSigning(device.identifier) != null;
      //if (device.isRemote == false && remoteEnabled) {
      // This could be a problem, why set isRemote to true? only pingTimer should be able to do that
      //await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isRemote: Value(true)));
      //}
      if (remoteEnabled) {
        if (pingTimer == null) {
          pingTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
            // This needs testing, added the line below instead of the line 133
            try {
              await sendRemoteCommand('geti -k TIME', nRetries: 0);
              await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isRemote: Value(true)));
            } catch (e) {
              await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isRemote: Value(false)));
            }
          });
        }
        timeout?.cancel();
        timeout = Timer(Duration(seconds: 10), () {
          RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isRemote: Value(false)));
          timeout = null;
          pingTimer?.cancel();
          pingTimer = null;
        });
      }
      Map<String, dynamic> messageMap = JsonDecoder().convert(message);
      if (messageMap['type'] == 'log') {
        ControllerLog log = ControllerLog.fromMap(messageMap);
        if (log.module == 'CMD') {
          String cmdId = log.msg.split(')')[0].substring(1);
          if (commandCompleters.containsKey(cmdId)) {
            commandCompleters[cmdId]!.complete();
            commandCompleters.remove(cmdId);
          }
        }
      } else {
        ControllerMetric cm = ControllerMetric.fromMap(messageMap);
        late Param param;
        try {
          param = await RelDB.get().devicesDAO.getParam(device.id, cm.key);
        } catch (e) {
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
      }
    }, onError: (e) async {
      await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isRemote: Value(false)));
      Logger.logError(e, null);
      await Future.delayed(Duration(seconds: 3));
      connect();
    }, onDone: () async {
      await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(id: Value(device.id), isRemote: Value(false)));
      await Future.delayed(Duration(seconds: 3));
      connect();
    });
  }

  Future sendRemoteCommand(String cmd, {int nRetries = 5, int tryN = 0, Completer? completer, String? uuid}) async {
    String signing = AppDB().getDeviceSigning(device.identifier)!;
    if (uuid == null) {
      uuid = Uuid().v4();
    }
    String cmdWithId = '$cmd -i $uuid';
    String cmdWithSigning = '$signing:$cmdWithId';
    String signature = sha256.convert(utf8.encode(cmdWithSigning)).toString();
    String signedCmd = '$signature:$cmdWithId';
    if (completer == null) {
      completer = Completer();
      commandCompleters[uuid] = completer;
    }
    channel.sink.add(signedCmd);
    Timer(Duration(seconds: 2), () {
      if (!completer!.isCompleted) {
        if (tryN < nRetries) {
          Logger.log("Retrying $cmd");
          sendRemoteCommand(cmd, nRetries: nRetries, tryN: tryN + 1, completer: completer, uuid: uuid);
          return;
        } else {
          completer.completeError(Exception('Timeout for command $uuid'));
        }
      }
      commandCompleters.remove(uuid);
    });
    return completer.future;
  }

  void close() {
    deviceSub?.cancel();
    sub?.cancel();
    pingTimer?.cancel();
  }
}
