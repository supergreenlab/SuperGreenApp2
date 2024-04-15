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

import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsUpgradeDeviceBlocEvent extends Equatable {}

class SettingsUpgradeDeviceBlocEventInit extends SettingsUpgradeDeviceBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsUpgradeDeviceBlocEventUpgrade extends SettingsUpgradeDeviceBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsUpgradeDeviceBlocEventUpgrading extends SettingsUpgradeDeviceBlocEvent {
  final String progressMessage;

  SettingsUpgradeDeviceBlocEventUpgrading(this.progressMessage);

  @override
  List<Object> get props => [progressMessage];
}

class SettingsUpgradeDeviceBlocEventCheckUpgradeDone extends SettingsUpgradeDeviceBlocEvent {
  final int rand = Random().nextInt(1 << 32);

  SettingsUpgradeDeviceBlocEventCheckUpgradeDone();

  @override
  List<Object> get props => [rand];
}

abstract class SettingsUpgradeDeviceBlocState extends Equatable {}

class SettingsUpgradeDeviceBlocStateInit extends SettingsUpgradeDeviceBlocState {
  @override
  List<Object> get props => [];
}

class SettingsUpgradeDeviceBlocStateLoaded extends SettingsUpgradeDeviceBlocState {
  final bool needsUpgrade;

  SettingsUpgradeDeviceBlocStateLoaded(this.needsUpgrade);

  @override
  List<Object> get props => [needsUpgrade];
}

class SettingsUpgradeDeviceBlocStateUpgrading extends SettingsUpgradeDeviceBlocState {
  final String progressMessage;

  SettingsUpgradeDeviceBlocStateUpgrading(this.progressMessage);

  @override
  List<Object> get props => [progressMessage];
}

class SettingsUpgradeDeviceBlocStateUpgradeDone extends SettingsUpgradeDeviceBlocState {
  SettingsUpgradeDeviceBlocStateUpgradeDone();

  @override
  List<Object> get props => [];
}

class SettingsUpgradeDeviceBlocStateUpgradeError extends SettingsUpgradeDeviceBlocState {
  SettingsUpgradeDeviceBlocStateUpgradeError();

  @override
  List<Object> get props => [];
}

class SettingsUpgradeDeviceBloc extends LegacyBloc<SettingsUpgradeDeviceBlocEvent, SettingsUpgradeDeviceBlocState> {
  final MainNavigateToSettingsUpgradeDevice args;

  HttpServer? server;

  late Param otaTimestamp;

  SettingsUpgradeDeviceBloc(this.args) : super(SettingsUpgradeDeviceBlocStateInit()) {
    add(SettingsUpgradeDeviceBlocEventInit());
  }

  @override
  Stream<SettingsUpgradeDeviceBlocState> mapEventToState(SettingsUpgradeDeviceBlocEvent event) async* {
    if (event is SettingsUpgradeDeviceBlocEventInit) {
      otaTimestamp = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_TIMESTAMP');
      Param otaBaseDir = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_BASEDIR');

      String localOTATimestamp = await rootBundle.loadString('assets/firmware${otaBaseDir.svalue}/timestamp');
      yield SettingsUpgradeDeviceBlocStateLoaded(int.parse(localOTATimestamp) > otaTimestamp.ivalue!);
    } else if (event is SettingsUpgradeDeviceBlocEventUpgrade) {
      yield SettingsUpgradeDeviceBlocStateUpgrading('Setting parameters..');
      String? auth = AppDB().getDeviceAuth(args.device.identifier);
      Param otaServerIP = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_SERVER_IP');
      Param otaServerPort = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_SERVER_PORT');
      String myip = await DeviceAPI.fetchString('http://${args.device.ip}/myip', auth: auth);

      Param otaBaseDir = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_BASEDIR');
      ByteData config = await rootBundle.load('assets/firmware${otaBaseDir.svalue}/html_app/config.json');
      await DeviceAPI.uploadFile(args.device.ip, 'config.json', config, auth: auth);
      ByteData htmlApp = await rootBundle.load('assets/firmware${otaBaseDir.svalue}/html_app/app.html');
      await DeviceAPI.uploadFile(args.device.ip, 'app.html', htmlApp, auth: auth);

      server = await HttpServer.bind(InternetAddress.anyIPv6, 0);
      server!.listen(listenRequest);

      await Future.delayed(Duration(seconds: 1));
      await DeviceHelper.updateStringParam(args.device, otaServerIP, myip, forceLocal: true);
      await DeviceHelper.updateIntParam(args.device, otaServerPort, server!.port, forceLocal: true);

      bool hasStart = true;
      late Param start;
      try {
        start = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_START');
      } catch (e) {
        hasStart = false;
      }
      if (hasStart) {
        try {
          await DeviceHelper.updateIntParam(args.device, start, 1, nRetries: 1, forceLocal: true);
        } catch (e) {
          print(e);
        }
      } else {
        Param reboot = await RelDB.get().devicesDAO.getParam(args.device.id, 'REBOOT');
        yield SettingsUpgradeDeviceBlocStateUpgrading('Rebooting controller..');
        try {
          await DeviceHelper.updateIntParam(args.device, reboot, 1, nRetries: 1, forceLocal: true);
        } catch (e) {
          print(e);
        }
      }
      yield SettingsUpgradeDeviceBlocStateUpgrading('Waiting controller connection..');
    } else if (event is SettingsUpgradeDeviceBlocEventUpgrading) {
      yield SettingsUpgradeDeviceBlocStateUpgrading(event.progressMessage);
    } else if (event is SettingsUpgradeDeviceBlocEventCheckUpgradeDone) {
      yield SettingsUpgradeDeviceBlocStateUpgrading('Firmware sent, waiting for controller..');
      try {
        await waitFirmwareUpgraded();
        yield SettingsUpgradeDeviceBlocStateUpgradeDone();
      } catch (e) {
        yield SettingsUpgradeDeviceBlocStateUpgradeError();
      }
    }
  }

  void listenRequest(HttpRequest request) async {
    if (request.requestedUri.pathSegments.last == 'last_timestamp') {
      add(SettingsUpgradeDeviceBlocEventUpgrading('Controller connected'));
      Param otaBaseDir = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_BASEDIR');
      String localOTATimestamp = await rootBundle.loadString('assets/firmware${otaBaseDir.svalue}/timestamp');
      request.response.statusCode = 200;
      request.response.write(localOTATimestamp);
      await request.response.flush();
      await request.response.close();
      return;
    } else if (request.requestedUri.pathSegments.last == 'firmware.bin') {
      add(SettingsUpgradeDeviceBlocEventUpgrading('Downloading firmware..'));
      Param otaBaseDir = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_BASEDIR');
      ByteData firmwareBin = await rootBundle.load('assets/firmware${otaBaseDir.svalue}/firmware.bin');
      request.response.statusCode = 200;
      request.response.add(firmwareBin.buffer.asInt8List());
      await request.response.flush();
      await request.response.close();
      await Future.delayed(Duration(seconds: 10));
      add(SettingsUpgradeDeviceBlocEventCheckUpgradeDone());
      return;
    }
    request.response.statusCode = 404;
    request.response.write('Page not found');
    await request.response.close();
  }

  Future<void> waitFirmwareUpgraded() async {
    Param otaBaseDir = await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_BASEDIR');
    String localOTATimestamp = await rootBundle.loadString('assets/firmware${otaBaseDir.svalue}/timestamp');
    int ts = int.parse(localOTATimestamp);
    String? auth = AppDB().getDeviceAuth(args.device.identifier);
    int nRetries = 10;
    for (int i = 0; i < nRetries; ++i) {
      await Future.delayed(Duration(seconds: 5));
      try {
        int value = await DeviceAPI.fetchIntParam(args.device.ip, 'OTA_TIMESTAMP', timeout: 5, nRetries: 1, auth: auth);
        if (value == ts) {
          break;
        }
      } catch (e, trace) {
        if (i == nRetries-1) {
          Logger.logError(e, trace, data: {"ip": args.device.ip, "deviceID": args.device.identifier}, fwdThrow: true);
        }
      }
    }
  }

  @override
  Future<void> close() async {
    await server?.close(force: true);
    return super.close();
  }
}
