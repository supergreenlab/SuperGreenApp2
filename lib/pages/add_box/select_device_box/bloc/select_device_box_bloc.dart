import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectDeviceBoxBlocEvent extends Equatable {}

class SelectDeviceBoxBlocEventSetDeviceBox extends SelectDeviceBoxBlocEvent {
  final int deviceBox;
  SelectDeviceBoxBlocEventSetDeviceBox(this.deviceBox);

  @override
  List<Object> get props => [deviceBox];
}

abstract class SelectDeviceBoxBlocState extends Equatable {}

class SelectDeviceBoxBlocStateIdle extends SelectDeviceBoxBlocState {
  @override
  List<Object> get props => [];
}

class SelectDeviceBoxBlocStateDone extends SelectDeviceBoxBlocState {
  final Box box;
  SelectDeviceBoxBlocStateDone(this.box);

  @override
  List<Object> get props => [box];
}

class SelectDeviceBoxBloc
    extends Bloc<SelectDeviceBoxBlocEvent, SelectDeviceBoxBlocState> {
  final MainNavigateToSelectBoxDeviceBoxEvent _args;

  SelectDeviceBoxBloc(this._args);

  @override
  SelectDeviceBoxBlocState get initialState => SelectDeviceBoxBlocStateIdle();

  @override
  Stream<SelectDeviceBoxBlocState> mapEventToState(
      SelectDeviceBoxBlocEvent event) async* {
    if (event is SelectDeviceBoxBlocEventSetDeviceBox) {
      final bdb = RelDB.get().boxesDAO;
      await bdb.updateBox(
        _args.box.id,
        BoxesCompanion(deviceBox: Value(event.deviceBox)),
      );
      Box box = await bdb.getBox(_args.box.id);
      yield SelectDeviceBoxBlocStateDone(box);
    }
  }
}
