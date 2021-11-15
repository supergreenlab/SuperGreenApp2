import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/api/backend/feeds/plant_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsPlantsBlocEvent extends Equatable {}

class SettingsPlantsBlocEventInit extends SettingsPlantsBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsPlantsblocEventPlantListChanged extends SettingsPlantsBlocEvent {
  final List<Plant> plants;
  final List<Box> boxes;

  SettingsPlantsblocEventPlantListChanged(this.plants, this.boxes);

  @override
  List<Object> get props => [plants, boxes];
}

class SettingsPlantsBlocEventDeletePlant extends SettingsPlantsBlocEvent {
  final Plant plant;

  SettingsPlantsBlocEventDeletePlant(this.plant);

  @override
  List<Object> get props => [plant];
}

abstract class SettingsPlantsBlocState extends Equatable {}

class SettingsPlantsBlocStateInit extends SettingsPlantsBlocState {
  @override
  List<Object> get props => [];
}

class SettingsPlantsBlocStateLoading extends SettingsPlantsBlocState {
  @override
  List<Object> get props => [];
}

class SettingsPlantsBlocStateLoaded extends SettingsPlantsBlocState {
  final List<Plant> plants;
  final List<Box> boxes;

  SettingsPlantsBlocStateLoaded(this.plants, this.boxes);

  @override
  List<Object> get props => [plants, boxes];
}

class SettingsPlantsBloc extends Bloc<SettingsPlantsBlocEvent, SettingsPlantsBlocState> {
  List<Plant> plants = [];
  List<Box> boxes = [];
  StreamSubscription<List<Plant>>? _plantsStream;
  StreamSubscription<List<Box>>? _boxesStream;

  //ignore: unused_field
  final MainNavigateToSettingsPlants args;

  SettingsPlantsBloc(this.args) : super(SettingsPlantsBlocStateInit()) {
    add(SettingsPlantsBlocEventInit());
  }

  @override
  Stream<SettingsPlantsBlocState> mapEventToState(event) async* {
    if (event is SettingsPlantsBlocEventInit) {
      yield SettingsPlantsBlocStateLoading();
      _plantsStream = RelDB.get().plantsDAO.watchPlants().listen(_onPlantListChange);
      _boxesStream = RelDB.get().plantsDAO.watchBoxes().listen(_onBoxListChange);
    } else if (event is SettingsPlantsblocEventPlantListChanged) {
      yield SettingsPlantsBlocStateLoaded(event.plants, event.boxes);
    } else if (event is SettingsPlantsBlocEventDeletePlant) {
      await PlantHelper.deletePlant(event.plant);
    }
  }

  void _onPlantListChange(List<Plant> p) {
    plants = p;
    add(SettingsPlantsblocEventPlantListChanged(plants, boxes));
  }

  void _onBoxListChange(List<Box> b) {
    boxes = b;
    add(SettingsPlantsblocEventPlantListChanged(plants, boxes));
  }

  @override
  Future<void> close() async {
    await _plantsStream?.cancel();
    await _boxesStream?.cancel();
    return super.close();
  }
}
