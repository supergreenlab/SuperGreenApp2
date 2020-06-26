import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/device_api.dart';
import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/helpers/device_helper.dart';
import 'package:super_green_app/data/helpers/feed_helper.dart';
import 'package:super_green_app/data/helpers/plant_helper.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/logger/logger.dart';
import 'package:super_green_app/data/rel/device/devices.dart';
import 'package:super_green_app/data/rel/feed/feeds.dart';
import 'package:super_green_app/data/rel/plant/plants.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class SyncerBlocEvent extends Equatable {}

class SyncerBlocEventInit extends SyncerBlocEvent {
  @override
  List<Object> get props => [];
}

class SyncerBlocEventSyncing extends SyncerBlocEvent {
  final bool syncing;
  final String text;

  SyncerBlocEventSyncing(this.syncing, this.text);

  @override
  List<Object> get props => [syncing, text];
}

abstract class SyncerBlocState extends Equatable {}

class SyncerBlocStateInit extends SyncerBlocState {
  @override
  List<Object> get props => [];
}

class SyncerBlocStateSyncing extends SyncerBlocState {
  final bool syncing;
  final String text;

  SyncerBlocStateSyncing(this.syncing, this.text);

  @override
  List<Object> get props => [syncing, text];
}

class SyncerBloc extends Bloc<SyncerBlocEvent, SyncerBlocState> {
  StreamSubscription<ConnectivityResult> _connectivity;

  Timer _timerOut;
  bool _workingOut;

  Timer _timerIn;
  bool _workingIn;

  bool _usingWifi = false;

  SyncerBloc() {
    add(SyncerBlocEventInit());
  }

  @override
  SyncerBlocState get initialState => SyncerBlocStateInit();

  @override
  Stream<SyncerBlocState> mapEventToState(SyncerBlocEvent event) async* {
    if (event is SyncerBlocEventInit) {
      _connectivity = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        _usingWifi = (result == ConnectivityResult.wifi);
      });
      _timerOut = Timer.periodic(Duration(seconds: 5), (_) async {
        if (_workingOut == true) return;
        _workingOut = true;
        if (!await _validJWT()) {
          _workingOut = false;
          return;
        }
        try {
          await _syncOut();
        } catch (e) {
          Logger.log(e);
        }
        _workingOut = false;
      });

      _timerIn = Timer.periodic(Duration(seconds: 5), (_) async {
        if (_workingIn == true) return;
        _workingIn = true;
        if (!await _validJWT()) {
          _workingIn = false;
          return;
        }
        try {
          await _syncIn();
        } catch (e) {
          Logger.log(e);
        }
        _workingIn = false;
      });
    } else if (event is SyncerBlocEventSyncing) {
      yield SyncerBlocStateSyncing(event.syncing, event.text);
    }
  }

  Future _syncIn() async {
    if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
      throw 'Can\'t sync over GSM';
    }
    await _syncInFeeds();
    await _syncInFeedEntries();
    await _syncInFeedMedias();
    await _syncInDevices();
    await _syncInBoxes();
    await _syncInPlants();
    await _syncInTimelapses();
    add(SyncerBlocEventSyncing(false, ''));
  }

  Future _syncInFeeds() async {
    Logger.log("Syncing feeds");
    List<FeedsCompanion> feeds = await FeedsAPI().unsyncedFeeds();
    for (int i = 0; i < feeds.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'feed: ${i + 1}/${feeds.length}'));
      FeedsCompanion feedsCompanion = feeds[i];
      Feed exists = await RelDB.get()
          .feedsDAO
          .getFeedForServerID(feedsCompanion.serverID.value);
      if (feedsCompanion is DeletedFeedsCompanion) {
        if (exists != null) {
          await FeedEntryHelper.deleteFeed(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get()
              .feedsDAO
              .updateFeed(feedsCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().feedsDAO.addFeed(feedsCompanion);
        }
      }
      await FeedsAPI().setSynced("feed", feedsCompanion.serverID.value);
      Logger.log("Synced feed");
    }
  }

  Future _syncInFeedEntries() async {
    Logger.log("Syncing feedEntries");
    List<FeedEntriesCompanion> feedEntries =
        await FeedsAPI().unsyncedFeedEntries();
    for (int i = 0; i < feedEntries.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(
          true, 'entry: ${i + 1}/${feedEntries.length}'));
      FeedEntriesCompanion feedEntriesCompanion = feedEntries[i];
      FeedEntry exists = await RelDB.get()
          .feedsDAO
          .getFeedEntryForServerID(feedEntriesCompanion.serverID.value);
      if (feedEntriesCompanion is DeletedFeedEntriesCompanion) {
        if (exists != null) {
          await FeedEntryHelper.deleteFeedEntry(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await FeedEntryHelper.updateFeedEntry(
              feedEntriesCompanion.copyWith(id: Value(exists.id)));
        } else {
          await FeedEntryHelper.addFeedEntry(feedEntriesCompanion);
        }
      }
      await FeedsAPI()
          .setSynced("feedEntry", feedEntriesCompanion.serverID.value);
      Logger.log("Synced feedEntry");
    }
  }

  Future _syncInFeedMedias() async {
    Logger.log("Syncing feedMedias");
    List<FeedMediasCompanion> feedMedias =
        await FeedsAPI().unsyncedFeedMedias();
    for (int i = 0; i < feedMedias.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }

      add(SyncerBlocEventSyncing(true, 'media: ${i + 1}/${feedMedias.length}'));
      FeedMediasCompanion feedMediasCompanion = feedMedias[i];
      FeedMedia exists = await RelDB.get()
          .feedsDAO
          .getFeedMediaForServerID(feedMediasCompanion.serverID.value);
      if (feedMediasCompanion is DeletedFeedMediasCompanion) {
        if (exists != null) {
          await FeedEntryHelper.deleteFeedMedia(exists, addDeleted: false);
        }
      } else {
        String filePath =
            '${FeedMedias.makeFilePath()}.${feedMediasCompanion.filePath.value.split('.')[1].split('?')[0]}';
        String thumbnailPath =
            '${FeedMedias.makeFilePath(prefix: 'thumbnail_')}.${feedMediasCompanion.thumbnailPath.value.split('.')[1].split('?')[0]}';
        await FeedsAPI().download(feedMediasCompanion.filePath.value,
            FeedMedias.makeAbsoluteFilePath(filePath));
        await FeedsAPI().download(feedMediasCompanion.thumbnailPath.value,
            FeedMedias.makeAbsoluteFilePath(thumbnailPath));
        if (exists != null) {
          await _deleteFileIfExists(
              FeedMedias.makeAbsoluteFilePath(exists.filePath));
          await _deleteFileIfExists(
              FeedMedias.makeAbsoluteFilePath(exists.thumbnailPath));
          await RelDB.get().feedsDAO.updateFeedMedia(
              feedMediasCompanion.copyWith(
                  id: Value(exists.id),
                  filePath: Value(filePath),
                  thumbnailPath: Value(thumbnailPath)));
        } else {
          await RelDB.get().feedsDAO.addFeedMedia(feedMediasCompanion.copyWith(
              filePath: Value(filePath), thumbnailPath: Value(thumbnailPath)));
        }
      }
      await FeedsAPI()
          .setSynced("feedMedia", feedMediasCompanion.serverID.value);
      Logger.log("Synced feedMedia");
    }
  }

  Future _syncInDevices() async {
    Logger.log("Syncing devices");
    List<DevicesCompanion> devices = await FeedsAPI().unsyncedDevices();
    for (int i = 0; i < devices.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'device: ${i + 1}/${devices.length}'));
      DevicesCompanion devicesCompanion = devices[i];
      Device exists = await RelDB.get()
          .devicesDAO
          .getDeviceForServerID(devicesCompanion.serverID.value);
      if (devicesCompanion is DeletedDevicesCompanion) {
        if (exists != null) {
          await DeviceHelper.deleteDevice(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get()
              .devicesDAO
              .updateDevice(devicesCompanion.copyWith(id: Value(exists.id)));
        } else {
          int deviceID =
              await RelDB.get().devicesDAO.addDevice(devicesCompanion);
          // No await, that's intentional
          DeviceAPI.fetchAllParams(
              devicesCompanion.ip.value, deviceID, (adv) {});
        }
      }
      await FeedsAPI().setSynced("device", devicesCompanion.serverID.value);
      Logger.log("Synced device");
    }
  }

  Future _syncInBoxes() async {
    Logger.log("Syncing boxes");
    List<BoxesCompanion> boxes = await FeedsAPI().unsyncedBoxes();
    for (int i = 0; i < boxes.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'box: ${i + 1}/${boxes.length}'));
      BoxesCompanion boxesCompanion = boxes[i];
      Box exists = await RelDB.get()
          .plantsDAO
          .getBoxForServerID(boxesCompanion.serverID.value);
      if (boxesCompanion is DeletedBoxesCompanion) {
        if (exists != null) {
          await PlantHelper.deleteBox(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get()
              .plantsDAO
              .updateBox(boxesCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().plantsDAO.addBox(boxesCompanion);
        }
      }
      await FeedsAPI().setSynced("box", boxesCompanion.serverID.value);
      Logger.log("Synced box");
    }
  }

  Future _syncInPlants() async {
    Logger.log("Syncing plants");
    List<PlantsCompanion> plants = await FeedsAPI().unsyncedPlants();
    for (int i = 0; i < plants.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'plant: ${i + 1}/${plants.length}'));
      PlantsCompanion plantsCompanion = plants[i];
      Plant exists = await RelDB.get()
          .plantsDAO
          .getPlantForServerID(plantsCompanion.serverID.value);
      if (plantsCompanion is DeletedPlantsCompanion) {
        if (exists != null) {
          await PlantHelper.deletePlant(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get()
              .plantsDAO
              .updatePlant(plantsCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().plantsDAO.addPlant(plantsCompanion);
        }
      }
      await FeedsAPI().setSynced("plant", plantsCompanion.serverID.value);
      Logger.log("Synced plant");
    }
  }

  Future _syncInTimelapses() async {
    Logger.log("Syncing timelapses");
    List<TimelapsesCompanion> timelapses =
        await FeedsAPI().unsyncedTimelapses();
    for (int i = 0; i < timelapses.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(
          true, 'timelapse: ${i + 1}/${timelapses.length}'));
      TimelapsesCompanion timelapsesCompanion = timelapses[i];
      Timelapse exists = await RelDB.get()
          .plantsDAO
          .getTimelapseForServerID(timelapsesCompanion.serverID.value);
      if (timelapsesCompanion is DeletedTimelapsesCompanion) {
        if (exists != null) {
          await PlantHelper.deleteTimelapse(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get().plantsDAO.updateTimelapse(
              timelapsesCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().plantsDAO.addTimelapse(timelapsesCompanion);
        }
      }
      await FeedsAPI()
          .setSynced("timelapse", timelapsesCompanion.serverID.value);
      Logger.log("Synced timelapse");
    }
  }

  Future _syncOut() async {
    if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
      throw 'Can\'t sync over GSM';
    }
    await _syncOutDeletes();
    await _syncOutFeeds();
    await _syncOutOrphanedFeedMedias();
    await _syncOutFeedEntries();
    await _syncOutDevices();
    await _syncOutBoxes();
    await _syncOutPlants();
    await _syncOutTimelapses();
  }

  Future _syncOutDeletes() async {
    Logger.log("Sending deletes");
    List<Delete> deletes = await RelDB.get().deletesDAO.getDeletes();
    if (deletes.length == 0) {
      return;
    }
    await FeedsAPI().sendDeletes(deletes);
    await RelDB.get().deletesDAO.removeDeletes(deletes);
  }

  Future _syncOutFeeds() async {
    Logger.log("Sending feeds");
    List<Feed> feeds = await RelDB.get().feedsDAO.getUnsyncedFeeds();
    for (int i = 0; i < feeds.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Feed feed = feeds[i];
      await FeedsAPI().syncFeed(feed);
    }
  }

  Future _syncOutFeedEntries() async {
    Logger.log("Sending feedEntries");
    List<FeedEntry> feedEntries =
        await RelDB.get().feedsDAO.getUnsyncedFeedEntries();
    for (int i = 0; i < feedEntries.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      FeedEntry feedEntry = feedEntries[i];
      await FeedsAPI().syncFeedEntry(feedEntry);
      await _syncOutFeedMedias(feedEntry.id);
    }
  }

  Future _syncOutOrphanedFeedMedias() async {
    Logger.log("Sending orphaned feedMedias");
    List<FeedMedia> feedMedias =
        await RelDB.get().feedsDAO.getOrphanedFeedMedias();
    for (int i = 0; i < feedMedias.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      FeedMedia feedMedia = feedMedias[i];
      await FeedsAPI().syncFeedMedia(feedMedia);
    }
  }

  Future _syncOutFeedMedias(int feedEntryID) async {
    Logger.log("Sending feedMedias");
    List<FeedMedia> feedMedias =
        await RelDB.get().feedsDAO.getUnsyncedFeedMedias(feedEntryID);
    for (int i = 0; i < feedMedias.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      FeedMedia feedMedia = feedMedias[i];
      await FeedsAPI().syncFeedMedia(feedMedia);
    }
  }

  Future _syncOutDevices() async {
    Logger.log("Sending devices");
    List<Device> devices = await RelDB.get().devicesDAO.getUnsyncedDevices();
    for (int i = 0; i < devices.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Device device = devices[i];
      await FeedsAPI().syncDevice(device);
    }
  }

  Future _syncOutBoxes() async {
    Logger.log("Sending boxes");
    List<Box> boxes = await RelDB.get().plantsDAO.getUnsyncedBoxes();
    for (int i = 0; i < boxes.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Box box = boxes[i];
      await FeedsAPI().syncBox(box);
    }
  }

  Future _syncOutPlants() async {
    Logger.log("Sending plants");
    List<Plant> plants = await RelDB.get().plantsDAO.getUnsyncedPlants();
    for (int i = 0; i < plants.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Plant plant = plants[i];
      await FeedsAPI().syncPlant(plant);
    }
  }

  Future _syncOutTimelapses() async {
    Logger.log("Sending timelapses");
    List<Timelapse> timelapses =
        await RelDB.get().plantsDAO.getUnsyncedTimelapses();
    for (int i = 0; i < timelapses.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Timelapse timelapse = timelapses[i];
      await FeedsAPI().syncTimelapse(timelapse);
    }
  }

  Future<bool> _validJWT() async {
    if (AppDB().getAppData().jwt == null) return false;
    return true;
  }

  Future _deleteFileIfExists(String filePath) async {
    final File file = File(filePath);
    try {
      await file.delete();
    } catch (e) {}
  }

  @override
  Future<void> close() async {
    if (_connectivity != null) {
      _connectivity.cancel();
    }
    if (_timerOut != null) {
      _timerOut.cancel();
    }
    if (_timerIn != null) {
      _timerIn.cancel();
    }
    return super.close();
  }
}
