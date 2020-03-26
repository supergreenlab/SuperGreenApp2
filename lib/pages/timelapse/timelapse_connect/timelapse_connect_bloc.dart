import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TimelapseConnectBlocEvent extends Equatable {}

class TimelapseConnectBlocEventSaveConfig extends TimelapseConnectBlocEvent {
  final String dropboxToken;
  final String uploadName;

  TimelapseConnectBlocEventSaveConfig({
    this.dropboxToken,
    this.uploadName,
  });

  @override
  List<Object> get props => [];
}

class TimelapseConnectBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class TimelapseConnectBlocStateDone extends TimelapseConnectBlocState {
  final Plant plant;

  TimelapseConnectBlocStateDone(this.plant);

  @override
  List<Object> get props => [plant];
}

class TimelapseConnectBloc
    extends Bloc<TimelapseConnectBlocEvent, TimelapseConnectBlocState> {
  final MainNavigateToTimelapseConnect _args;

  TimelapseConnectBloc(this._args);

  @override
  TimelapseConnectBlocState get initialState => TimelapseConnectBlocState();

  @override
  Stream<TimelapseConnectBlocState> mapEventToState(
      TimelapseConnectBlocEvent event) async* {
    if (event is TimelapseConnectBlocEventSaveConfig) {
      await RelDB.get().plantsDAO.addTimelapse(TimelapsesCompanion.insert(
          plant: _args.plant.id,
          dropboxToken: Value(event.dropboxToken),
          uploadName: Value(event.uploadName)));

      yield TimelapseConnectBlocStateDone(_args.plant);
    }
  }
}
