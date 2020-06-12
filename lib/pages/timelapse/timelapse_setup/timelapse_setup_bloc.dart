import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:moor/moor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_green_app/data/logger/Logger.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TimelapseSetupBlocEvent extends Equatable {}

class TimelapseSetupBlocEventInit extends TimelapseSetupBlocEvent {
  @override
  List<Object> get props => [];
}

class TimelapseSetupBlocEventBleStateChanged extends TimelapseSetupBlocEvent {
  final BluetoothState currentState;

  TimelapseSetupBlocEventBleStateChanged(this.currentState);

  @override
  List<Object> get props => [currentState];
}

class TimelapseSetupBlocEventSetConfig extends TimelapseSetupBlocEvent {
  final String ssid;
  final String password;
  final String controllerID;
  final String dropboxToken;
  final String name;
  final String strain;
  final String uploadName;
  final String rotate;

  TimelapseSetupBlocEventSetConfig(
      {this.ssid,
      this.password,
      this.controllerID,
      this.dropboxToken,
      this.name,
      this.strain,
      this.uploadName,
      this.rotate});

  @override
  List<Object> get props => [
        this.ssid,
        this.password,
        this.controllerID,
        this.dropboxToken,
        this.name,
        this.strain,
        this.uploadName,
        this.rotate
      ];
}

class TimelapseSetupBlocEventDeviceFound extends TimelapseSetupBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class TimelapseSetupBlocState extends Equatable {}

class TimelapseSetupBlocStateInit extends TimelapseSetupBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseSetupBlocStateBleOFF extends TimelapseSetupBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseSetupBlocStateUnauthorized extends TimelapseSetupBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseSetupBlocStateScanning extends TimelapseSetupBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseSetupBlocStateDeviceFound extends TimelapseSetupBlocState {
  final String controllerid;

  TimelapseSetupBlocStateDeviceFound(this.controllerid);

  @override
  List<Object> get props => [];
}

class TimelapseSetupBlocStateSettingParams extends TimelapseSetupBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseSetupBlocStateDone extends TimelapseSetupBlocState {
  final Plant plant;

  TimelapseSetupBlocStateDone(this.plant);

  @override
  List<Object> get props => [plant];
}

const ServiceUUID = "7bfdeb0b-f06d-480f-a82c-cde56ab3d686";
const CharacteristicUUID = "ec0e";

class TimelapseSetupBloc
    extends Bloc<TimelapseSetupBlocEvent, TimelapseSetupBlocState> {
  final BleManager bleManager = BleManager();
  ScanResult scanResult;

  final MainNavigateToTimelapseSetup args;

  TimelapseSetupBloc(this.args) {
    add(TimelapseSetupBlocEventInit());
  }

  @override
  TimelapseSetupBlocState get initialState => TimelapseSetupBlocStateInit();

  @override
  Stream<TimelapseSetupBlocState> mapEventToState(
      TimelapseSetupBlocEvent event) async* {
    if (event is TimelapseSetupBlocEventInit) {
      await bleManager.createClient();
      BluetoothState currentState = await bleManager.bluetoothState();
      add(TimelapseSetupBlocEventBleStateChanged(currentState));
      bleManager.observeBluetoothState().listen((btState) {
        add(TimelapseSetupBlocEventBleStateChanged(btState));
      });
    } else if (event is TimelapseSetupBlocEventDeviceFound) {
      final db = RelDB.get();
      Box box = await db.plantsDAO.getBox(args.plant.box);
      String controllerid;
      if (box.device != null) {
        Device device =
            await db.devicesDAO.getDevice(box.device);
        controllerid = device.identifier;
      }
      yield TimelapseSetupBlocStateDeviceFound(controllerid);
    } else if (event is TimelapseSetupBlocEventBleStateChanged) {
      if (event.currentState == BluetoothState.POWERED_OFF) {
        yield TimelapseSetupBlocStateBleOFF();
      } else if (event.currentState == BluetoothState.UNAUTHORIZED) {
        yield TimelapseSetupBlocStateUnauthorized();
      } else if (event.currentState == BluetoothState.POWERED_ON) {
        try {
          await _checkPermissions();
          yield TimelapseSetupBlocStateScanning();
          startScan();
        } catch (e) {
          Logger.log(e);
        }
      }
    } else if (event is TimelapseSetupBlocEventSetConfig) {
      yield TimelapseSetupBlocStateSettingParams();
      String value =
          '${event.ssid};|;${event.password};|;${event.controllerID};|;${event.dropboxToken};|;${event.name};|;${event.strain};|;${event.uploadName};|;${event.rotate}';
      Peripheral peripheral = scanResult.peripheral;
      if (!await peripheral.isConnected()) {
        await peripheral.connect();
      }
      await peripheral.discoverAllServicesAndCharacteristics();
      await peripheral.writeCharacteristic(ServiceUUID, CharacteristicUUID,
          Uint8List.fromList(value.codeUnits), true);
      await peripheral.disconnectOrCancelConnection();

      await RelDB.get().plantsDAO.addTimelapse(TimelapsesCompanion.insert(
          plant: args.plant.id,
          ssid: Value(event.ssid),
          password: Value(event.password),
          controllerID: Value(event.controllerID),
          rotate: Value(event.rotate),
          name: Value(event.name),
          strain: Value(event.strain),
          dropboxToken: Value(event.dropboxToken),
          uploadName: Value(event.uploadName)));

      yield TimelapseSetupBlocStateDone(args.plant);
    }
  }

  void startScan() {
    scanResult = null;
    bleManager.startPeripheralScan(
      uuids: [ServiceUUID],
    ).listen((ScanResult sr) {
      if (scanResult != null) {
        return;
      }
      Logger.log(
          '${sr.peripheral.name} ${sr.peripheral.identifier}');
      if (sr.peripheral.name == 'sgl-cam' ||
          sr.peripheral.name == 'supergreenlivepi') {
        scanResult = sr;
        add(TimelapseSetupBlocEventDeviceFound());
        bleManager.stopPeripheralScan();
      }
    });
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      var permissionStatus = await PermissionHandler()
          .requestPermissions([PermissionGroup.location]);

      PermissionStatus locationPermissionStatus =
          permissionStatus[PermissionGroup.location];

      if (locationPermissionStatus != PermissionStatus.granted) {
        return Future.error(Exception("Location permission not granted"));
      }
    }
  }

  @override
  Future<void> close() async {
    await bleManager.destroyClient();
    return super.close();
  }
}
