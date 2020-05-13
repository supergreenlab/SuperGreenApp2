import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsBoxBlocEvent extends Equatable {}

class SettingsBoxBlocEventInit extends SettingsBoxBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsBoxBlocEventUpdate extends SettingsBoxBlocEvent {
  final String name;
  final Device device;
  final int deviceBox;

  SettingsBoxBlocEventUpdate(this.name, this.device, this.deviceBox);

  @override
  List<Object> get props => [name, device];
}

abstract class SettingsBoxBlocState extends Equatable {}

class SettingsBoxBlocStateLoading extends SettingsBoxBlocState {
  @override
  List<Object> get props => [];
}

class SettingsBoxBlocStateLoaded extends SettingsBoxBlocState {
  final Box box;
  final Device device;
  final int deviceBox;

  SettingsBoxBlocStateLoaded(this.box, this.device, this.deviceBox);

  @override
  List<Object> get props => [box, device, deviceBox];
}

class SettingsBoxBlocStateDone extends SettingsBoxBlocState {
  final Box box;
  final Device device;
  final int deviceBox;

  SettingsBoxBlocStateDone(this.box, this.device, this.deviceBox);

  @override
  List<Object> get props => [box, device, deviceBox];
}

class SettingsBoxBloc extends Bloc<SettingsBoxBlocEvent, SettingsBoxBlocState> {
  //ignore: unused_field
  final MainNavigateToSettingsBox args;
  Box box;
  Device device;
  int deviceBox;

  SettingsBoxBloc(this.args) {
    add(SettingsBoxBlocEventInit());
  }

  @override
  SettingsBoxBlocState get initialState => SettingsBoxBlocStateLoading();

  @override
  Stream<SettingsBoxBlocState> mapEventToState(
      SettingsBoxBlocEvent event) async* {
    if (event is SettingsBoxBlocEventInit) {
      box = await RelDB.get().plantsDAO.getBox(args.box.id);
      if (box.device != null) {
        device = await RelDB.get().devicesDAO.getDevice(box.device);
        deviceBox = box.deviceBox;
      }
      yield SettingsBoxBlocStateLoaded(box, device, deviceBox);
    } else if (event is SettingsBoxBlocEventUpdate) {
      yield SettingsBoxBlocStateLoading();
      await RelDB.get().plantsDAO.updateBox(BoxesCompanion(
          id: Value(box.id),
          name: Value(event.name),
          device: Value(event.device?.id),
          deviceBox: Value(event.deviceBox),
          synced: Value(false)));
      yield SettingsBoxBlocStateDone(box, device, deviceBox);
    }
  }
}
