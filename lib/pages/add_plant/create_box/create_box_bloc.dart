import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/box_settings.dart';

abstract class CreateBoxBlocEvent extends Equatable {}

class CreateBoxBlocEventCreate extends CreateBoxBlocEvent {
  final String name;
  final Device device;
  final int deviceBox;
  CreateBoxBlocEventCreate(
    this.name, {
    this.device,
    this.deviceBox,
  });

  @override
  List<Object> get props => [name, device, deviceBox];
}

class CreateBoxBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateBoxBlocStateDone extends CreateBoxBlocState {
  final Box box;
  CreateBoxBlocStateDone(this.box);

  @override
  List<Object> get props => [box];
}

class CreateBoxBloc extends Bloc<CreateBoxBlocEvent, CreateBoxBlocState> {
  //ignore: unused_field
  final MainNavigateToCreateBoxEvent args;

  CreateBoxBloc(this.args) : super(CreateBoxBlocState());

  @override
  Stream<CreateBoxBlocState> mapEventToState(CreateBoxBlocEvent event) async* {
    if (event is CreateBoxBlocEventCreate) {
      final bdb = RelDB.get().plantsDAO;
      BoxesCompanion box;
      if (event.device == null && event.deviceBox == null) {
        box = BoxesCompanion.insert(
            name: event.name, settings: Value(BoxSettings().toJSON()));
      } else {
        box = BoxesCompanion.insert(
            name: event.name,
            device: Value(event.device.id),
            deviceBox: Value(event.deviceBox),
            settings: Value(BoxSettings().toJSON()));
      }
      final boxID = await bdb.addBox(box);
      final b = await bdb.getBox(boxID);
      yield CreateBoxBlocStateDone(b);
    }
  }
}
