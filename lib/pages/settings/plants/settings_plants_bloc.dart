import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/helpers/plant_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsPlantsBlocEvent extends Equatable {}

class SettingsPlantsBlocEventInit extends SettingsPlantsBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsPlantsblocEventPlantListChanged extends SettingsPlantsBlocEvent {
  final List<Plant> plants;

  SettingsPlantsblocEventPlantListChanged(this.plants);

  @override
  List<Object> get props => [plants];
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

  SettingsPlantsBlocStateLoaded(this.plants);

  @override
  List<Object> get props => [plants];
}

class SettingsPlantsBloc
    extends Bloc<SettingsPlantsBlocEvent, SettingsPlantsBlocState> {
  List<Plant> plants;
  StreamSubscription<List<Plant>> _plantsStream;

  //ignore: unused_field
  final MainNavigateToSettingsPlants args;

  SettingsPlantsBloc(this.args) {
    add(SettingsPlantsBlocEventInit());
  }

  @override
  get initialState => SettingsPlantsBlocStateInit();

  @override
  Stream<SettingsPlantsBlocState> mapEventToState(event) async* {
    if (event is SettingsPlantsBlocEventInit) {
      yield SettingsPlantsBlocStateLoading();
      _plantsStream =
          RelDB.get().plantsDAO.watchPlants().listen(_onPlantListChange);
    } else if (event is SettingsPlantsblocEventPlantListChanged) {
      yield SettingsPlantsBlocStateLoaded(event.plants);
    } else if (event is SettingsPlantsBlocEventDeletePlant) {
      await RelDB.get().feedsDAO.deleteFeedMediasForFeed(event.plant.feed);
      await RelDB.get().feedsDAO.deleteFeedEntriesForFeed(event.plant.feed);
      Feed feed = await RelDB.get().feedsDAO.getFeed(event.plant.feed);
      await RelDB.get().feedsDAO.deleteFeed(feed);
      PlantHelper.deletePlant(event.plant);
    }
  }

  void _onPlantListChange(List<Plant> p) {
    plants = p;
    add(SettingsPlantsblocEventPlantListChanged(plants));
  }

  @override
  Future<void> close() async {
    if (_plantsStream != null) {
      await _plantsStream.cancel();
    }
    return super.close();
  }
}
