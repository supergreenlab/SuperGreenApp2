import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsDeviceBlocEvent extends Equatable {}

class SettingsDeviceBlocEventInit extends SettingsDeviceBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsDeviceBlocEventRefresh extends SettingsDeviceBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsDeviceBlocEventRefreshing extends SettingsDeviceBlocEvent {
  final double percent;
  SettingsDeviceBlocEventRefreshing(this.percent);

  @override
  List<Object> get props => [percent];
}

class SettingsDeviceBlocEventUpdate extends SettingsDeviceBlocEvent {
  final String name;

  SettingsDeviceBlocEventUpdate(this.name);

  @override
  List<Object> get props => [name];
}

abstract class SettingsDeviceBlocState extends Equatable {}

class SettingsDeviceBlocStateLoading extends SettingsDeviceBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDeviceBlocStateRefreshing extends SettingsDeviceBlocState {
  final double percent;
  SettingsDeviceBlocStateRefreshing(this.percent);

  @override
  List<Object> get props => [percent];
}

class SettingsDeviceBlocStateLoaded extends SettingsDeviceBlocState {
  final Device device;

  SettingsDeviceBlocStateLoaded(this.device);

  @override
  List<Object> get props => [device];
}

class SettingsDeviceBlocStateRefreshed extends SettingsDeviceBlocState {
  final Device device;

  SettingsDeviceBlocStateRefreshed(this.device);

  @override
  List<Object> get props => [device];
}

class SettingsDeviceBlocStateDone extends SettingsDeviceBlocState {
  final Device device;

  SettingsDeviceBlocStateDone(this.device);

  @override
  List<Object> get props => [device];
}

class SettingsDeviceBloc
    extends Bloc<SettingsDeviceBlocEvent, SettingsDeviceBlocState> {
  //ignore: unused_field
  final MainNavigateToSettingsDevice args;
  Device device;

  SettingsDeviceBloc(this.args) : super(SettingsDeviceBlocStateLoading()) {
    add(SettingsDeviceBlocEventInit());
  }

  @override
  Stream<SettingsDeviceBlocState> mapEventToState(
      SettingsDeviceBlocEvent event) async* {
    if (event is SettingsDeviceBlocEventInit) {
      device = await RelDB.get().devicesDAO.getDevice(args.device.id);
      yield SettingsDeviceBlocStateLoaded(device);
    } else if (event is SettingsDeviceBlocEventRefresh) {
      yield SettingsDeviceBlocStateRefreshing(0);
      refreshParams();
    } else if (event is SettingsDeviceBlocEventRefreshing) {
      if (event.percent != 100) {
        yield SettingsDeviceBlocStateRefreshing(event.percent);
      } else {
        yield SettingsDeviceBlocStateRefreshed(device);
        await Future.delayed(Duration(seconds: 2));
        yield SettingsDeviceBlocStateLoaded(device);
      }
    } else if (event is SettingsDeviceBlocEventUpdate) {
      yield SettingsDeviceBlocStateLoading();
      await DeviceHelper.updateDeviceName(args.device, event.name);
      yield SettingsDeviceBlocStateDone(device);
    }
  }

  void refreshParams() async {
    final deviceName =
        await DeviceAPI.fetchStringParam(device.ip, "DEVICE_NAME");
    final mdnsDomain =
        await DeviceAPI.fetchStringParam(device.ip, "MDNS_DOMAIN");
    await RelDB.get().devicesDAO.updateDevice(DevicesCompanion(
        id: Value(device.id),
        name: Value(deviceName),
        mdns: Value(mdnsDomain),
        synced: Value(false)));
    await DeviceAPI.fetchAllParams(device.ip, device.id, (adv) {
      add(SettingsDeviceBlocEventRefreshing(adv));
    });
    add(SettingsDeviceBlocEventRefreshing(100));
  }
}
