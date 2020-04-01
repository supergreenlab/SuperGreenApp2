import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/plant/plants.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SelectBoxBlocEvent extends Equatable {}

class SelectBoxBlocEventInit extends SelectBoxBlocEvent {
  @override
  List<Object> get props => [];
}

class SelectBoxBlocEventCreate extends SelectBoxBlocEvent {
  final String name;
  final Device device;
  final int deviceBox;

  SelectBoxBlocEventCreate(this.name, {this.device, this.deviceBox});

  @override
  List<Object> get props => [name, device, deviceBox];
}

abstract class SelectBoxBlocState extends Equatable {}

class SelectBoxBlocStateLoading extends SelectBoxBlocState {
  @override
  List<Object> get props => [];
}

class SelectBoxBlocStateLoaded extends SelectBoxBlocState {
  final List<Box> boxes;

  SelectBoxBlocStateLoaded(this.boxes);

  @override
  List<Object> get props => [boxes];
}

class SelectBoxBloc extends Bloc<SelectBoxBlocEvent, SelectBoxBlocState> {
  MainNavigateToSelectBoxEvent _args;

  SelectBoxBloc(this._args) {
    add(SelectBoxBlocEventInit());
  }

  @override
  SelectBoxBlocState get initialState => SelectBoxBlocStateLoading();

  @override
  Stream<SelectBoxBlocState> mapEventToState(SelectBoxBlocEvent event) async* {
    if (event is SelectBoxBlocEventInit) {
      yield SelectBoxBlocStateLoading();
      List<Box> boxes = await RelDB.get().plantsDAO.getBoxes();
      yield SelectBoxBlocStateLoaded(boxes);
    }
  }
}
