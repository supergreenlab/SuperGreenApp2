import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/kv/models/app_data.dart';

abstract class SyncerBlocEvent extends Equatable {}

class SyncerBlocEventInit extends SyncerBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SyncerBlocState extends Equatable {}

class SyncerBlocStateInit extends SyncerBlocState {
  @override
  List<Object> get props => [];
}

class SyncerBloc extends Bloc<SyncerBlocEvent, SyncerBlocState> {
  Timer _timer;
  bool _working;

  SyncerBloc() {
    add(SyncerBlocEventInit());
    _timer = Timer.periodic(Duration(seconds: 5), (_) async {
      if (_working) return;
      if (!await _validJWT()) return;
      await _sync();
    });
  }

  @override
  SyncerBlocState get initialState => SyncerBlocStateInit();

  @override
  Stream<SyncerBlocState> mapEventToState(SyncerBlocEvent event) async* {}

  Future _sync() async {
    _working = true;
    await _syncFeeds();
    await _syncDevices();
    await _syncPlants();
    _working = false;
  }

  Future<bool> _validJWT() async {
    if (AppDB().getAppData().jwt == null) return false;
    // TODO call server check token endpoint
    return true;
  }

  Future _syncFeeds() async {}

  Future _syncPlants() async {}

  Future _syncDevices() async {}

  @override
  Future<void> close() async {
    if (_timer != null) {
      _timer.cancel();
    }
    return super.close();
  }
}
