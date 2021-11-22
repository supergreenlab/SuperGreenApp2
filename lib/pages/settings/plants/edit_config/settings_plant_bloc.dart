import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/plant_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class SettingsPlantBlocEvent extends Equatable {}

class SettingsPlantBlocEventInit extends SettingsPlantBlocEvent {
  @override
  List<Object> get props => [];
}

class SettingsPlantBlocEventUpdate extends SettingsPlantBlocEvent {
  final String name;
  final bool public;
  final Box box;

  SettingsPlantBlocEventUpdate(this.name, this.public, this.box);

  @override
  List<Object> get props => [name, public, box];
}

class SettingsPlantBlocEventArchive extends SettingsPlantBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SettingsPlantBlocState extends Equatable {}

class SettingsPlantBlocStateLoading extends SettingsPlantBlocState {
  @override
  List<Object> get props => [];
}

class SettingsPlantBlocStateLoaded extends SettingsPlantBlocState {
  final Plant plant;
  final Box box;
  final bool loggedIn;

  SettingsPlantBlocStateLoaded(this.plant, this.box, this.loggedIn);

  @override
  List<Object> get props => [plant, box, loggedIn];
}

class SettingsPlantBlocStateDone extends SettingsPlantBlocState {
  final Plant plant;
  final Box box;
  final bool? archived;

  SettingsPlantBlocStateDone(this.plant, this.box, {this.archived});

  @override
  List<Object?> get props => [plant, box, archived];
}

class SettingsPlantBlocStateError extends SettingsPlantBlocState {
  final String message;

  SettingsPlantBlocStateError(this.message);

  @override
  List<Object> get props => [message];
}

class SettingsPlantBloc extends Bloc<SettingsPlantBlocEvent, SettingsPlantBlocState> {
  //ignore: unused_field
  final MainNavigateToSettingsPlant args;
  late Plant plant;
  late Box box;

  SettingsPlantBloc(this.args) : super(SettingsPlantBlocStateLoading()) {
    add(SettingsPlantBlocEventInit());
  }

  @override
  Stream<SettingsPlantBlocState> mapEventToState(SettingsPlantBlocEvent event) async* {
    if (event is SettingsPlantBlocEventInit) {
      plant = await RelDB.get().plantsDAO.getPlant(args.plant.id);
      box = await RelDB.get().plantsDAO.getBox(plant.box);
      yield SettingsPlantBlocStateLoaded(plant, box, BackendAPI().usersAPI.loggedIn);
    } else if (event is SettingsPlantBlocEventUpdate) {
      yield SettingsPlantBlocStateLoading();
      await RelDB.get().plantsDAO.updatePlant(PlantsCompanion(
          id: Value(plant.id),
          name: Value(event.name),
          public: Value(event.public),
          box: Value(event.box.id),
          synced: Value(false)));
      yield SettingsPlantBlocStateDone(plant, box);
    } else if (event is SettingsPlantBlocEventArchive) {
      yield SettingsPlantBlocStateLoading();
      if (plant.serverID == null) {
        yield SettingsPlantBlocStateError("This plant is not synced.");
        return;
      }
      try {
        await BackendAPI().feedsAPI.archivePlant(plant.serverID!);
      } catch (e) {
        yield SettingsPlantBlocStateError(e.toString());
        return;
      }
      await PlantHelper.deletePlant(plant, addDeleted: false);
      yield SettingsPlantBlocStateDone(plant, box, archived: true);
    }
  }
}
