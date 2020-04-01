import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsDevicesBlocEvent extends Equatable {}

class SettingsDevicesBlocEventInit extends SettingsDevicesBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsDevicesblocEventBoxListChanged extends SettingsDevicesBlocEvent {
  final List<Device> devices;

  SettingsDevicesblocEventBoxListChanged(this.devices);

  @override
  List<Object> get props => [devices];
}

class SettingsDevicesBlocEventDeleteBox extends SettingsDevicesBlocEvent {
  final Device device;

  SettingsDevicesBlocEventDeleteBox(this.device);

  @override
  List<Object> get props => [device];
}

abstract class SettingsDevicesBlocState extends Equatable {}

class SettingsDevicesBlocStateInit extends SettingsDevicesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDevicesBlocStateLoading extends SettingsDevicesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDevicesBlocStateNotEmptyBox extends SettingsDevicesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsDevicesBlocStateLoaded extends SettingsDevicesBlocState {
  final List<Device> devices;

  SettingsDevicesBlocStateLoaded(this.devices);

  @override
  List<Object> get props => [devices];
}

class SettingsDevicesBloc
    extends Bloc<SettingsDevicesBlocEvent, SettingsDevicesBlocState> {
  List<Device> _devices;

  //ignore: unused_field
  final MainNavigateToSettingsDevices _args;

  SettingsDevicesBloc(this._args) {
    add(SettingsDevicesBlocEventInit());
  }

  @override
  get initialState => SettingsDevicesBlocStateInit();

  @override
  Stream<SettingsDevicesBlocState> mapEventToState(event) async* {
    if (event is SettingsDevicesBlocEventInit) {
      yield SettingsDevicesBlocStateLoading();
      RelDB.get().devicesDAO.watchDevices().listen(_onDeviceListChange);
    } else if (event is SettingsDevicesblocEventBoxListChanged) {
      yield SettingsDevicesBlocStateLoaded(event.devices);
    } else if (event is SettingsDevicesBlocEventDeleteBox) {
      final ddb = RelDB.get().devicesDAO;
      await RelDB.get().plantsDAO.cleanDeviceIDs(event.device.id);
      await ddb.deleteDevice(event.device);
      await ddb.deleteParams(event.device.id);
      await ddb.deleteModules(event.device.id);
    }
  }

  void _onDeviceListChange(List<Device> devices) {
    _devices = devices;
    add(SettingsDevicesblocEventBoxListChanged(_devices));
  }
}
