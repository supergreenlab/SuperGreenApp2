import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsUpgradeDeviceBlocEvent extends Equatable {}

class SettingsUpgradeDeviceBlocEventInit
    extends SettingsUpgradeDeviceBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsUpgradeDeviceBlocEventUpgrade
    extends SettingsUpgradeDeviceBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SettingsUpgradeDeviceBlocState extends Equatable {}

class SettingsUpgradeDeviceBlocStateInit
    extends SettingsUpgradeDeviceBlocState {
  @override
  List<Object> get props => [];
}

class SettingsUpgradeDeviceBlocStateLoaded
    extends SettingsUpgradeDeviceBlocState {
  final bool needsUpgrade;

  SettingsUpgradeDeviceBlocStateLoaded(this.needsUpgrade);

  @override
  List<Object> get props => [needsUpgrade];
}

class SettingsUpgradeDeviceBlocStateUpgrading
    extends SettingsUpgradeDeviceBlocState {
  final int progress;

  SettingsUpgradeDeviceBlocStateUpgrading(this.progress);

  @override
  List<Object> get props => [progress];
}

class SettingsUpgradeDeviceBlocStateUpgradeDone
    extends SettingsUpgradeDeviceBlocState {
  SettingsUpgradeDeviceBlocStateUpgradeDone();

  @override
  List<Object> get props => [];
}

class SettingsUpgradeDeviceBloc extends Bloc<SettingsUpgradeDeviceBlocEvent,
    SettingsUpgradeDeviceBlocState> {
  final MainNavigateToSettingsUpgradeDevice args;

  HttpServer server;

  SettingsUpgradeDeviceBloc(this.args)
      : super(SettingsUpgradeDeviceBlocStateInit()) {
    add(SettingsUpgradeDeviceBlocEventInit());
  }

  @override
  Stream<SettingsUpgradeDeviceBlocState> mapEventToState(
      SettingsUpgradeDeviceBlocEvent event) async* {
    if (event is SettingsUpgradeDeviceBlocEventInit) {
      Param otaTimestamp = await RelDB.get()
          .devicesDAO
          .getParam(args.device.id, 'OTA_TIMESTAMP');
      Param otaBaseDir =
          await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_BASEDIR');
      String localOTATimestamp = await rootBundle
          .loadString('assets/firmware${otaBaseDir.svalue}/timestamp');
      yield SettingsUpgradeDeviceBlocStateLoaded(
          int.parse(localOTATimestamp) > otaTimestamp.ivalue);
    } else if (event is SettingsUpgradeDeviceBlocEventUpgrade) {
      yield SettingsUpgradeDeviceBlocStateUpgrading(0);
      Param otaServerIP = await RelDB.get()
          .devicesDAO
          .getParam(args.device.id, 'OTA_SERVER_IP');
      Param otaServerPort = await RelDB.get()
          .devicesDAO
          .getParam(args.device.id, 'OTA_SERVER_PORT');
      String myip =
          await DeviceAPI.fetchString('http://${args.device.ip}/myip');
      server = await HttpServer.bind(InternetAddress.anyIPv6, 0);
      server.listen(listenRequest);

      await DeviceHelper.updateStringParam(args.device, otaServerIP, myip);
      await DeviceHelper.updateIntParam(
          args.device, otaServerPort, server.port);

      Param reboot =
          await RelDB.get().devicesDAO.getParam(args.device.id, 'REBOOT');
      try {
        await DeviceHelper.updateIntParam(args.device, reboot, 1, nRetries: 1);
      } catch (e) {
        print(e);
      }
    }
  }

  void listenRequest(HttpRequest request) async {
    if (request.requestedUri.pathSegments.last == 'last_timestamp') {
      Param otaBaseDir =
          await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_BASEDIR');
      String localOTATimestamp = await rootBundle
          .loadString('assets/firmware${otaBaseDir.svalue}/timestamp');
      request.response.statusCode = 200;
      request.response.write(localOTATimestamp);
      await request.response.flush();
      await request.response.close();
      return;
    } else if (request.requestedUri.pathSegments.last == 'firmware.bin') {
      Param otaBaseDir =
          await RelDB.get().devicesDAO.getParam(args.device.id, 'OTA_BASEDIR');
      ByteData firmwareBin = await rootBundle
          .load('assets/firmware${otaBaseDir.svalue}/firmware.bin');
      request.response.statusCode = 200;
      request.response.add(firmwareBin.buffer.asInt8List());
      await request.response.flush();
      await request.response.close();
      return;
    }
    request.response.statusCode = 404;
    request.response.write('Page not found');
    request.response.close();
  }

  @override
  Future<void> close() async {
    if (server != null) {
      await server.close(force: true);
    }
    return super.close();
  }
}
