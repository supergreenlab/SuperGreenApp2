import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';

abstract class AppInitBlocEvent extends Equatable {}

class AppInitBlocEventLoaded extends AppInitBlocEvent {
  final AppData appData;
  AppInitBlocEventLoaded(this.appData);

  @override
  List<Object> get props => [appData];
}

abstract class AppInitBlocState extends Equatable {}

class AppInitBlocStateLoading extends AppInitBlocState {
  @override
  List<Object> get props => [];
}

class AppInitBlocStateReady extends  AppInitBlocState {
  final bool firstStart;

  AppInitBlocStateReady(this.firstStart);

  @override
  List<Object> get props => [firstStart];

}

class AppInitBloc extends Bloc<AppInitBlocEvent, AppInitBlocState> {
  AppDB _db = AppDB();

  @override
  AppInitBlocState get initialState => AppInitBlocStateLoading();

  AppInitBloc() {
    _init();
  }

  @override
  Stream<AppInitBlocState> mapEventToState(AppInitBlocEvent event) async* {
    if (event is AppInitBlocEventLoaded) {
      yield AppInitBlocStateReady(event.appData.firstStart);
    }
  }

  _init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    Hive.registerAdapter(AppDataAdapter());

    await _db.init();

    AppData appData = _db.getAppData();
    add(AppInitBlocEventLoaded(appData));
  }

  done() {
    _db.setFirstStart(false);
  }
}