import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TimelapseViewerBlocEvent extends Equatable {}

class TimelapseViewerBlocEventInit extends TimelapseViewerBlocEvent {
  @override
  List<Object> get props => [];
}

class TimelapseViewerBlocEventDelete extends TimelapseViewerBlocEvent {
  final Timelapse timelapse;

  TimelapseViewerBlocEventDelete(this.timelapse);

  @override
  List<Object> get props => [timelapse];
}

abstract class TimelapseViewerBlocState extends Equatable {}

class TimelapseViewerBlocStateInit extends TimelapseViewerBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseViewerBlocStateLoading extends TimelapseViewerBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseViewerBlocStateLoaded extends TimelapseViewerBlocState {
  final Plant plant;
  final List<Timelapse> timelapses;
  final List<Uint8List> images;

  TimelapseViewerBlocStateLoaded(this.plant, this.timelapses, this.images);

  @override
  List<Object> get props => [plant, timelapses, images];
}

class TimelapseViewerBloc
    extends Bloc<TimelapseViewerBlocEvent, TimelapseViewerBlocState> {
  final MainNavigateToTimelapseViewer _args;

  TimelapseViewerBloc(this._args) {
    add(TimelapseViewerBlocEventInit());
  }

  @override
  TimelapseViewerBlocState get initialState => TimelapseViewerBlocStateInit();

  @override
  Stream<TimelapseViewerBlocState> mapEventToState(
      TimelapseViewerBlocEvent event) async* {
    if (event is TimelapseViewerBlocEventInit) {
      yield TimelapseViewerBlocStateLoading();
      yield* reloadTimelapses();
    } else if (event is TimelapseViewerBlocEventDelete) {
      yield TimelapseViewerBlocStateLoading();
      await RelDB.get().plantsDAO.deleteTimelapse(event.timelapse);
      yield* reloadTimelapses();
    }
  }

  Stream<TimelapseViewerBlocState> reloadTimelapses() async* {
    List<Timelapse> timelapses =
        await RelDB.get().plantsDAO.getTimelapses(_args.plant.id);
    List<Uint8List> pictures = [];
    for (int i = 0; i < timelapses.length; ++i) {
      Response res = await post(
          'https://content.dropboxapi.com/2/files/download',
          headers: {
            'Authorization': 'Bearer ${timelapses[i].dropboxToken}',
            'Dropbox-API-Arg':
                '{"path": "/${timelapses[i].uploadName}/latest.jpg"}',
          });
      pictures.add(res.bodyBytes);
    }
    yield TimelapseViewerBlocStateLoaded(_args.plant, timelapses, pictures);
  }
}
