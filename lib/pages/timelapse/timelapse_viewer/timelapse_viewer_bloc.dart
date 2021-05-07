import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/plant_helper.dart';
import 'package:super_green_app/data/api/backend/plants/timelapse/dropbox.dart';
import 'package:super_green_app/data/logger/logger.dart';
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

class TimelapseViewerBloc extends Bloc<TimelapseViewerBlocEvent, TimelapseViewerBlocState> {
  final MainNavigateToTimelapseViewer args;

  TimelapseViewerBloc(this.args) : super(TimelapseViewerBlocStateInit()) {
    add(TimelapseViewerBlocEventInit());
  }

  @override
  Stream<TimelapseViewerBlocState> mapEventToState(TimelapseViewerBlocEvent event) async* {
    if (event is TimelapseViewerBlocEventInit) {
      yield TimelapseViewerBlocStateLoading();
      yield* reloadTimelapses();
    } else if (event is TimelapseViewerBlocEventDelete) {
      yield TimelapseViewerBlocStateLoading();
      await PlantHelper.deleteTimelapse(event.timelapse);
      yield* reloadTimelapses();
    }
  }

  Stream<TimelapseViewerBlocState> reloadTimelapses() async* {
    List<Timelapse> timelapses = await RelDB.get().plantsDAO.getTimelapses(args.plant.id);
    List<Uint8List> pictures = [];
    for (int i = 0; i < timelapses.length; ++i) {
      try {
        if (timelapses[i].type == "dropbox") {
          DropboxSettings dbSettings = DropboxSettings.fromMap(JsonDecoder().convert(timelapses[i].settings));
          Logger.log('${timelapses[i].settings} ${dbSettings.dropboxToken} ${dbSettings.uploadName}');
          Response res = await post('https://content.dropboxapi.com/2/files/download', headers: {
            'Authorization': 'Bearer ${dbSettings.dropboxToken}',
            'Dropbox-API-Arg': '{"path": "/${dbSettings.uploadName}/latest.jpg"}',
          });
          pictures.add(res.bodyBytes);
        } else if (timelapses[i].type == "sglstorage") {
          Map<String, dynamic> frame = await BackendAPI().feedsAPI.fetchLatestTimelapseFrame(timelapses[i].serverID);
          String url = '${BackendAPI().storageServerHost}${frame['filePath']}';
          Box box = await RelDB.get().plantsDAO.getBox(args.plant.box);
          pictures
              .add(await BackendAPI().feedsAPI.sglOverlay(box, args.plant, JsonDecoder().convert(frame['meta']), url));
        }
      } catch (e, trace) {
        Logger.logError(e, trace, data: {"timelapse": timelapses[i]});
      }
    }
    yield TimelapseViewerBlocStateLoaded(args.plant, timelapses, pictures);
  }
}
