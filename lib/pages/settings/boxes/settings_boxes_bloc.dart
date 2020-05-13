import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsBoxesBlocEvent extends Equatable {}

class SettingsBoxesBlocEventInit extends SettingsBoxesBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsBoxesblocEventBoxListChanged extends SettingsBoxesBlocEvent {
  final List<Box> boxes;

  SettingsBoxesblocEventBoxListChanged(this.boxes);

  @override
  List<Object> get props => [boxes];
}

class SettingsBoxesBlocEventDeleteBox extends SettingsBoxesBlocEvent {
  final Box box;

  SettingsBoxesBlocEventDeleteBox(this.box);

  @override
  List<Object> get props => [box];
}

abstract class SettingsBoxesBlocState extends Equatable {}

class SettingsBoxesBlocStateInit extends SettingsBoxesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsBoxesBlocStateLoading extends SettingsBoxesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsBoxesBlocStateNotEmptyBox extends SettingsBoxesBlocState {
  @override
  List<Object> get props => [];
}

class SettingsBoxesBlocStateLoaded extends SettingsBoxesBlocState {
  final List<Box> boxes;

  SettingsBoxesBlocStateLoaded(this.boxes);

  @override
  List<Object> get props => [boxes];
}

class SettingsBoxesBloc
    extends Bloc<SettingsBoxesBlocEvent, SettingsBoxesBlocState> {
  List<Box> _boxes;
  StreamSubscription<List<Box>> _boxesStream;

  //ignore: unused_field
  final MainNavigateToSettingsBoxes args;

  SettingsBoxesBloc(this.args) {
    add(SettingsBoxesBlocEventInit());
  }

  @override
  get initialState => SettingsBoxesBlocStateInit();

  @override
  Stream<SettingsBoxesBlocState> mapEventToState(event) async* {
    if (event is SettingsBoxesBlocEventInit) {
      yield SettingsBoxesBlocStateLoading();
      _boxesStream =
          RelDB.get().plantsDAO.watchBoxes().listen(_onBoxListChange);
    } else if (event is SettingsBoxesblocEventBoxListChanged) {
      yield SettingsBoxesBlocStateLoaded(event.boxes);
    } else if (event is SettingsBoxesBlocEventDeleteBox) {
      int nPlants =
          await RelDB.get().plantsDAO.nPlantsInBox(event.box.id).getSingle();
      if (nPlants != 0) {
        yield SettingsBoxesBlocStateNotEmptyBox();
        await Future.delayed(Duration(seconds: 2));
        yield SettingsBoxesBlocStateLoaded(_boxes);
        return;
      }
      await RelDB.get().plantsDAO.deleteBox(event.box);
    }
  }

  void _onBoxListChange(List<Box> boxes) {
    _boxes = boxes;
    add(SettingsBoxesblocEventBoxListChanged(_boxes));
  }

  @override
  Future<void> close() async {
    if (_boxesStream != null) {
      await _boxesStream.cancel();
    }
    return super.close();
  }
}
