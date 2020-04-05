import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsDeviceBlocEvent extends Equatable {}

class SettingsDeviceBlocEventInit extends SettingsDeviceBlocEvent {
  @override
  List<Object> get props => [];
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

class SettingsDeviceBlocStateLoaded extends SettingsDeviceBlocState {
  final Device device;

  SettingsDeviceBlocStateLoaded(this.device);

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
  final MainNavigateToSettingsDevice _args;
  Device _device;

  SettingsDeviceBloc(this._args) {
    add(SettingsDeviceBlocEventInit());
  }

  @override
  SettingsDeviceBlocState get initialState => SettingsDeviceBlocStateLoading();

  @override
  Stream<SettingsDeviceBlocState> mapEventToState(
      SettingsDeviceBlocEvent event) async* {
    if (event is SettingsDeviceBlocEventInit) {
      _device = await RelDB.get().devicesDAO.getDevice(_args.device.id);
      yield SettingsDeviceBlocStateLoaded(_device);
    } else if (event is SettingsDeviceBlocEventUpdate) {
      yield SettingsDeviceBlocStateLoading();
      await DeviceHelper.updateDeviceName(_args.device, event.name);
      Param mdns =
          await RelDB.get().devicesDAO.getParam(_args.device.id, 'MDNS_DOMAIN');
      await DeviceHelper.updateStringParam(
          _args.device, mdns, event.name.toLowerCase());
      yield SettingsDeviceBlocStateDone(_device);
    }
  }
}
