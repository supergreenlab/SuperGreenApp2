import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_green_app/models/app_data.dart';
import 'package:super_green_app/models/device/device_data.dart';
import 'package:super_green_app/models/device/module_data.dart';
import 'package:super_green_app/models/device/param_data.dart';
import 'package:super_green_app/storage/app_db.dart';

abstract class AppInitEvent extends Equatable {}

class AppInitEventLoaded extends AppInitEvent {
  final AppData appData;
  AppInitEventLoaded(this.appData);

  @override
  List<Object> get props => [appData];
}

abstract class AppInitState extends Equatable {}

class AppInitStateLoading extends AppInitState {
  @override
  List<Object> get props => [];
}

class AppInitStateReady extends  AppInitState {
  final bool firstStart;

  AppInitStateReady(this.firstStart);

  @override
  List<Object> get props => [firstStart];

}

class AppInitBloc extends Bloc<AppInitEvent, AppInitState> {
  AppDB _db = AppDB();

  @override
  AppInitState get initialState => AppInitStateLoading();

  @override
  Stream<AppInitState> mapEventToState(AppInitEvent event) async* {
    if (event is AppInitEventLoaded) {
      yield AppInitStateReady(event.appData.firstStart);
    }
  }

  AppInitBloc() {
    _init();
  }

  _init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    Hive.registerAdapter(AppDataAdapter(), 35);
    Hive.registerAdapter(DeviceDataAdapter(), 36);
    Hive.registerAdapter(ModuleDataAdapter(), 37);
    Hive.registerAdapter(ParamDataAdapter(), 38);
    Hive.registerAdapter(ParamTypeAdapter(), 39);

    await _db.init();

    AppData appData = _db.getAppData();
    add(AppInitEventLoaded(appData));
  }

  done() {
    _db.setFirstStart(false);
  }
}