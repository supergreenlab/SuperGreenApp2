import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:moor/moor.dart';
import 'package:permission_handler/permission_handler.dart';
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
  List<Object> get props => [];
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
  List<Object> get props => [];
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
  final Box box;

  TimelapseSetupBlocStateDone(this.box);

  @override
  List<Object> get props => [];
}

const ServiceUUID = "7bfdeb0b-f06d-480f-a82c-cde56ab3d686";
const CharacteristicUUID = "ec0e";

class TimelapseSetupBloc
    extends Bloc<TimelapseSetupBlocEvent, TimelapseSetupBlocState> {
  final BleManager _bleManager = BleManager();
  ScanResult _scanResult;

  final MainNavigateToTimelapseSetup _args;

  TimelapseSetupBloc(this._args) {
    add(TimelapseSetupBlocEventInit());
  }

  @override
  TimelapseSetupBlocState get initialState => TimelapseSetupBlocStateInit();

  @override
  Stream<TimelapseSetupBlocState> mapEventToState(
      TimelapseSetupBlocEvent event) async* {
    if (event is TimelapseSetupBlocEventInit) {
      await _bleManager.createClient();
      BluetoothState currentState = await _bleManager.bluetoothState();
      add(TimelapseSetupBlocEventBleStateChanged(currentState));
      _bleManager.observeBluetoothState().listen((btState) {
        add(TimelapseSetupBlocEventBleStateChanged(btState));
      });
    } else if (event is TimelapseSetupBlocEventDeviceFound) {
      String controllerid;
      if (_args.box.device != null) {
        Device device =
            await RelDB.get().devicesDAO.getDevice(_args.box.device);
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
          print(e);
        }
      }
    } else if (event is TimelapseSetupBlocEventSetConfig) {
      yield TimelapseSetupBlocStateSettingParams();
      String value =
          '${event.ssid};|;${event.password};|;${event.controllerID};|;${event.dropboxToken};|;${event.name};|;${event.strain};|;${event.uploadName};|;${event.rotate}';
      Peripheral peripheral = _scanResult.peripheral;
      if (!await peripheral.isConnected()) {
        await peripheral.connect();
      }
      await peripheral.discoverAllServicesAndCharacteristics();
      await peripheral.writeCharacteristic(ServiceUUID, CharacteristicUUID,
          Uint8List.fromList(value.codeUnits), true);
      await peripheral.disconnectOrCancelConnection();

      await RelDB.get().boxesDAO.addTimelapse(TimelapsesCompanion.insert(
          box: _args.box.id,
          ssid: Value(event.ssid),
          password: Value(event.password),
          controllerID: Value(event.controllerID),
          rotate: Value(event.rotate),
          name: Value(event.name),
          strain: Value(event.strain),
          dropboxToken: Value(event.dropboxToken),
          uploadName: Value(event.uploadName)));

      yield TimelapseSetupBlocStateDone(_args.box);
    }
  }

  void startScan() {
    _bleManager.startPeripheralScan(
      uuids: [ServiceUUID],
    ).listen((scanResult) {
      _scanResult = scanResult;
      print(
          '${scanResult.peripheral.name} ${scanResult.peripheral.identifier}');
      if (scanResult.peripheral.name == 'sgl-cam') {
        add(TimelapseSetupBlocEventDeviceFound());
        _bleManager.stopPeripheralScan();
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
  Future<void> close() {
    _bleManager.destroyClient();
    return super.close();
  }
}
