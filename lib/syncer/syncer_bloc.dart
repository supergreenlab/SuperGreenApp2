import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

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
  }

  @override
  SyncerBlocState get initialState => SyncerBlocStateInit();

  @override
  Stream<SyncerBlocState> mapEventToState(SyncerBlocEvent event) async* {
    if (event is SyncerBlocEventInit) {
      _timer = Timer.periodic(Duration(seconds: 5), (_) async {
        if (_working == true) return;
        _working = true;
        if (!await _validJWT()) {
          _working = false;
          return;
        }
        try {
          await _sync();
        } catch (e) {
          print(e);
        }
        _working = false;
      });
    }
  }

  Future _sync() async {
    await _syncFeeds();
    await _syncFeedEntries();
    await _syncFeedMedias();
    await _syncDevices();
    await _syncBoxes();
    await _syncPlants();
  }

  Future<bool> _validJWT() async {
    if (AppDB().getAppData().jwt == null) return false;
    // TODO call server check token endpoint
    return true;
  }

  Future _syncFeeds() async {
    List<Feed> feeds = await RelDB.get().feedsDAO.getUnsyncedFeeds();
    for (int i = 0; i < feeds.length; ++i) {
      Feed feed = feeds[i];
      await FeedsAPI().syncFeed(feed);
    }
  }

  Future _syncFeedEntries() async {
    List<FeedEntry> feedEntries =
        await RelDB.get().feedsDAO.getUnsyncedFeedEntries();
    for (int i = 0; i < feedEntries.length; ++i) {
      FeedEntry feedEntry = feedEntries[i];
      await FeedsAPI().syncFeedEntry(feedEntry);
    }
  }

  Future _syncFeedMedias() async {
    List<FeedMedia> feedMedias =
        await RelDB.get().feedsDAO.getUnsyncedFeedMedias();
    for (int i = 0; i < feedMedias.length; ++i) {
      FeedMedia feedMedia = feedMedias[i];
      await FeedsAPI().syncFeedMedia(feedMedia);
    }
  }

  Future _syncDevices() async {
    List<Device> devices = await RelDB.get().devicesDAO.getUnsyncedDevices();
    for (int i = 0; i < devices.length; ++i) {
      Device device = devices[i];
      await FeedsAPI().syncDevice(device);
    }
  }

  Future _syncBoxes() async {
    List<Box> boxes = await RelDB.get().plantsDAO.getUnsyncedBoxes();
    for (int i = 0; i < boxes.length; ++i) {
      Box box = boxes[i];
      await FeedsAPI().syncBox(box);
    }
  }

  Future _syncPlants() async {
    List<Plant> plants = await RelDB.get().plantsDAO.getUnsyncedPlants();
    for (int i = 0; i < plants.length; ++i) {
      Plant plant = plants[i];
      await FeedsAPI().syncPlant(plant);
    }
  }

  @override
  Future<void> close() async {
    if (_timer != null) {
      _timer.cancel();
    }
    return super.close();
  }
}
