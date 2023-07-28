/*
 * Copyright (C) 2022  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/api/backend/checklist/checklist_helper.dart';
import 'package:super_green_app/data/api/backend/userend/userend_helper.dart';
import 'package:super_green_app/data/rel/checklist/checklists.dart';
import 'package:super_green_app/misc/bloc.dart';
import 'package:drift/drift.dart';
import 'package:super_green_app/data/api/backend/backend_api.dart';
import 'package:super_green_app/data/api/backend/feeds/feed_helper.dart';
import 'package:super_green_app/data/api/backend/feeds/plant_helper.dart';
import 'package:super_green_app/data/api/device/device_api.dart';
import 'package:super_green_app/data/api/device/device_helper.dart';
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

class SyncerBloc extends LegacyBloc<SyncerBlocEvent, SyncerBlocState> {
  late StreamSubscription<ConnectivityResult> _connectivity;

  Timer? _timerOut;
  bool _workingOut = false;

  Timer? _timerIn;
  bool _workingIn = false;

  bool _usingWifi = false;

  SyncerBloc() : super(SyncerBlocStateInit());

  @override
  Stream<SyncerBlocState> mapEventToState(SyncerBlocEvent event) async* {
    if (event is SyncerBlocEventInit) {
      _usingWifi = await Connectivity().checkConnectivity() == ConnectivityResult.wifi;
      _connectivity = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        _usingWifi = (result == ConnectivityResult.wifi);
      });
      _timerOut = Timer.periodic(Duration(seconds: 5), (_) async {
        if (_workingOut == true) return;
        _workingOut = true;
        if (!BackendAPI().usersAPI.loggedIn) {
          _workingOut = false;
          return;
        }
        try {
          await _syncOut();
        } catch (e, trace) {
          if (e != 'Can\'t sync over GSM') {
            Logger.logError(e, trace);
          }
        }
        _workingOut = false;
      });

      _timerIn = Timer.periodic(Duration(seconds: 5), (_) async {
        if (_workingIn == true) return;
        _workingIn = true;
        if (!BackendAPI().usersAPI.loggedIn) {
          _workingIn = false;
          return;
        }
        try {
          await _syncIn();
        } catch (e, trace) {
          if (e != 'Can\'t sync over GSM') {
            Logger.logError(e, trace);
          }
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
    await _syncInChecklists();
    await _syncInChecklistSeeds();
    await _syncInChecklistLogs();
    add(SyncerBlocEventSyncing(false, ''));
  }

  Future _syncInFeeds() async {
    List<FeedsCompanion> feeds = await BackendAPI().feedsAPI.unsyncedFeeds();
    for (int i = 0; i < feeds.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'feed: ${i + 1}/${feeds.length}'));
      FeedsCompanion feedsCompanion = feeds[i];
      Feed? exists;
      try {
        exists = await RelDB.get().feedsDAO.getFeedForServerID(feedsCompanion.serverID.value!);
      } catch (e) {}
      if (feedsCompanion is DeletedFeedsCompanion) {
        if (exists != null) {
          await FeedEntryHelper.deleteFeed(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get().feedsDAO.updateFeed(feedsCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().feedsDAO.addFeed(feedsCompanion);
        }
      }
      await UserEndHelper.setSynced("feed", feedsCompanion.serverID.value!);
    }
  }

  Future _syncInFeedEntries() async {
    List<FeedEntriesCompanion> feedEntries = await BackendAPI().feedsAPI.unsyncedFeedEntries();
    for (int i = 0; i < feedEntries.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'entry: ${i + 1}/${feedEntries.length}'));
      FeedEntriesCompanion feedEntriesCompanion = feedEntries[i];
      FeedEntry? exists;
      try {
        exists = await RelDB.get().feedsDAO.getFeedEntryForServerID(feedEntriesCompanion.serverID.value!);
      } catch (e) {}
      if (feedEntriesCompanion is DeletedFeedEntriesCompanion) {
        if (exists != null) {
          await FeedEntryHelper.deleteFeedEntry(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await FeedEntryHelper.updateFeedEntry(feedEntriesCompanion.copyWith(id: Value(exists.id)));
        } else {
          await FeedEntryHelper.addFeedEntry(feedEntriesCompanion);
        }
      }
      await UserEndHelper.setSynced("feedEntry", feedEntriesCompanion.serverID.value!);
    }
  }

  Future _syncInFeedMedias() async {
    List<FeedMediasCompanion> feedMedias = await BackendAPI().feedsAPI.unsyncedFeedMedias();
    for (int i = 0; i < feedMedias.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }

      add(SyncerBlocEventSyncing(true, 'media: ${i + 1}/${feedMedias.length}'));
      FeedMediasCompanion feedMediasCompanion = feedMedias[i];
      FeedMedia? exists;
      try {
        exists = await RelDB.get().feedsDAO.getFeedMediaForServerID(feedMediasCompanion.serverID.value!);
      } catch (e) {}
      if (feedMediasCompanion is DeletedFeedMediasCompanion) {
        if (exists != null) {
          await FeedEntryHelper.deleteFeedMedia(exists, addDeleted: false);
        }
      } else {
        String filePath =
            '${FeedMedias.makeFilePath()}.${feedMediasCompanion.filePath.value.split('.')[1].split('?')[0]}';
        String thumbnailPath =
            '${FeedMedias.makeFilePath(prefix: 'thumbnail_')}.${feedMediasCompanion.thumbnailPath.value.split('.')[1].split('?')[0]}';
        await BackendAPI()
            .feedsAPI
            .download(feedMediasCompanion.filePath.value, FeedMedias.makeAbsoluteFilePath(filePath));
        await BackendAPI()
            .feedsAPI
            .download(feedMediasCompanion.thumbnailPath.value, FeedMedias.makeAbsoluteFilePath(thumbnailPath));
        if (exists != null) {
          await _deleteFileIfExists(FeedMedias.makeAbsoluteFilePath(exists.filePath));
          await _deleteFileIfExists(FeedMedias.makeAbsoluteFilePath(exists.thumbnailPath));
          await RelDB.get().feedsDAO.updateFeedMedia(feedMediasCompanion.copyWith(
              id: Value(exists.id), filePath: Value(filePath), thumbnailPath: Value(thumbnailPath)));
        } else {
          await RelDB.get().feedsDAO.addFeedMedia(
              feedMediasCompanion.copyWith(filePath: Value(filePath), thumbnailPath: Value(thumbnailPath)));
        }
      }
      await UserEndHelper.setSynced("feedMedia", feedMediasCompanion.serverID.value!);
    }
  }

  Future _syncInDevices() async {
    List<DevicesCompanion> devices = await BackendAPI().feedsAPI.unsyncedDevices();
    for (int i = 0; i < devices.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'device: ${i + 1}/${devices.length}'));
      DevicesCompanion devicesCompanion = devices[i];
      Device? exists;
      try {
        exists = await RelDB.get().devicesDAO.getDeviceForServerID(devicesCompanion.serverID.value!);
      } catch (e) {}
      if (devicesCompanion is DeletedDevicesCompanion) {
        if (exists != null) {
          await DeviceHelper.deleteDevice(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get().devicesDAO.updateDevice(devicesCompanion.copyWith(id: Value(exists.id)));
        } else {
          int deviceID = await RelDB.get().devicesDAO.addDevice(devicesCompanion);
          String? auth = AppDB().getDeviceAuth(devices[i].identifier.value);
          // No await, that's intentional
          DeviceAPI.fetchAllParams(devicesCompanion.ip.value, deviceID, (adv) {}, auth: auth);
        }
      }
      await UserEndHelper.setSynced("device", devicesCompanion.serverID.value!);
    }
  }

  Future _syncInBoxes() async {
    List<BoxesCompanion> boxes = await BackendAPI().feedsAPI.unsyncedBoxes();
    for (int i = 0; i < boxes.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'box: ${i + 1}/${boxes.length}'));
      BoxesCompanion boxesCompanion = boxes[i];
      Box? exists;
      try {
        exists = await RelDB.get().plantsDAO.getBoxForServerID(boxesCompanion.serverID.value!);
      } catch (e) {}
      if (boxesCompanion is DeletedBoxesCompanion) {
        if (exists != null) {
          await PlantHelper.deleteBox(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get().plantsDAO.updateBox(boxesCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().plantsDAO.addBox(boxesCompanion);
        }
      }
      await UserEndHelper.setSynced("box", boxesCompanion.serverID.value!);
    }
  }

  Future _syncInPlants() async {
    List<PlantsCompanion> plants = await BackendAPI().feedsAPI.unsyncedPlants();
    for (int i = 0; i < plants.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'plant: ${i + 1}/${plants.length}'));
      PlantsCompanion plantsCompanion = plants[i];
      Plant? exists;
      try {
        exists = await RelDB.get().plantsDAO.getPlantForServerID(plantsCompanion.serverID.value!);
      } catch (e) {}
      if (plantsCompanion is DeletedPlantsCompanion) {
        if (exists != null) {
          await PlantHelper.deletePlant(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get().plantsDAO.updatePlant(plantsCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().plantsDAO.addPlant(plantsCompanion);
        }
      }
      await UserEndHelper.setSynced("plant", plantsCompanion.serverID.value!);
    }
  }

  Future _syncInTimelapses() async {
    List<TimelapsesCompanion> timelapses = await BackendAPI().feedsAPI.unsyncedTimelapses();
    for (int i = 0; i < timelapses.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'timelapse: ${i + 1}/${timelapses.length}'));
      TimelapsesCompanion timelapsesCompanion = timelapses[i];
      Timelapse? exists;
      try {
        exists = await RelDB.get().plantsDAO.getTimelapseForServerID(timelapsesCompanion.serverID.value!);
      } catch (e) {}
      if (timelapsesCompanion is DeletedTimelapsesCompanion) {
        if (exists != null) {
          await PlantHelper.deleteTimelapse(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get().plantsDAO.updateTimelapse(timelapsesCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().plantsDAO.addTimelapse(timelapsesCompanion);
        }
      }
      await UserEndHelper.setSynced("timelapse", timelapsesCompanion.serverID.value!);
    }
  }

  Future _syncInChecklistSeeds() async {
    List<ChecklistSeedsCompanion> checklistSeeds = await BackendAPI().checklistAPI.unsyncedChecklistSeeds();
    for (int i = 0; i < checklistSeeds.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'timelapse: ${i + 1}/${checklistSeeds.length}'));
      ChecklistSeedsCompanion checklistSeedsCompanion = checklistSeeds[i];
      ChecklistSeed? exists;
      try {
        exists = await RelDB.get().checklistsDAO.getChecklistSeedForServerIDs(
            checklistSeedsCompanion.serverID.value!, checklistSeedsCompanion.checklistServerID.value!);
      } catch (e) {}
      if (checklistSeedsCompanion is DeletedChecklistSeedsCompanion) {
        if (exists != null) {
          await ChecklistHelper.deleteChecklistSeed(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get().checklistsDAO.updateChecklistSeed(checklistSeedsCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().checklistsDAO.addChecklistSeed(checklistSeedsCompanion);
        }
      }
      await UserEndHelper.setSynced("checklistseed", checklistSeedsCompanion.serverID.value!);
    }
  }

  Future _syncInChecklists() async {
    List<ChecklistsCompanion> checklists = await BackendAPI().checklistAPI.unsyncedChecklists();
    for (int i = 0; i < checklists.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'checklist: ${i + 1}/${checklists.length}'));
      ChecklistsCompanion checklistsCompanion = checklists[i];
      Checklist? exists;
      try {
        exists = await RelDB.get().checklistsDAO.getChecklistForServerID(checklistsCompanion.serverID.value!);
      } catch (e) {}
      if (checklistsCompanion is DeletedChecklistsCompanion) {
        if (exists != null) {
          await ChecklistHelper.deleteChecklist(exists, addDeleted: false);
        }
      } else {
        if (exists != null) {
          await RelDB.get().checklistsDAO.updateChecklist(checklistsCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().checklistsDAO.addChecklist(checklistsCompanion);
        }
      }
      await UserEndHelper.setSynced("checklist", checklistsCompanion.serverID.value!);
    }
  }

  Future _syncInChecklistLogs() async {
    List<ChecklistLogsCompanion> checklistLogs = await BackendAPI().checklistAPI.unsyncedChecklistLogs();
    for (int i = 0; i < checklistLogs.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      add(SyncerBlocEventSyncing(true, 'checklist log: ${i + 1}/${checklistLogs.length}'));
      ChecklistLogsCompanion checklistLogsCompanion = checklistLogs[i];
      ChecklistLog? exists;
      try {
        exists = await RelDB.get().checklistsDAO.getChecklistLogForServerID(checklistLogsCompanion.serverID.value!);
      } catch (e) {}
      if (checklistLogsCompanion is DeletedChecklistsCompanion) {
        if (exists != null) {
          await ChecklistHelper.deleteChecklistLog(exists);
        }
      } else {
        if (exists != null) {
          await RelDB.get().checklistsDAO.updateChecklistLog(checklistLogsCompanion.copyWith(id: Value(exists.id)));
        } else {
          await RelDB.get().checklistsDAO.addChecklistLog(checklistLogsCompanion);
        }
      }
      await UserEndHelper.setSynced("checklistlog", checklistLogsCompanion.serverID.value!);
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
    await _syncOutChecklists();
    await _syncOutChecklistSeeds();
    await _syncOutChecklistLogs();
  }

  Future _syncOutDeletes() async {
    List<Delete> deletes = await RelDB.get().deletesDAO.getDeletes();
    if (deletes.length == 0) {
      return;
    }
    await BackendAPI().feedsAPI.sendDeletes(deletes);
    await RelDB.get().deletesDAO.removeDeletes(deletes);
  }

  Future _syncOutFeeds() async {
    List<Feed> feeds = await RelDB.get().feedsDAO.getUnsyncedFeeds();
    for (int i = 0; i < feeds.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Feed feed = feeds[i];
      await BackendAPI().feedsAPI.syncFeed(feed);
    }
  }

  Future _syncOutFeedEntries() async {
    List<FeedEntry> feedEntries = await RelDB.get().feedsDAO.getUnsyncedFeedEntries();
    for (int i = 0; i < feedEntries.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      FeedEntry feedEntry = feedEntries[i];
      await BackendAPI().feedsAPI.syncFeedEntry(feedEntry);
      await _syncOutFeedMedias(feedEntry.id);
    }
  }

  Future _syncOutOrphanedFeedMedias() async {
    List<FeedMedia> feedMedias = await RelDB.get().feedsDAO.getOrphanedFeedMedias();
    for (int i = 0; i < feedMedias.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      FeedMedia feedMedia = feedMedias[i];
      await BackendAPI().feedsAPI.syncFeedMedia(feedMedia);
    }
  }

  Future _syncOutFeedMedias(int feedEntryID) async {
    List<FeedMedia> feedMedias = await RelDB.get().feedsDAO.getUnsyncedFeedMedias(feedEntryID);
    for (int i = 0; i < feedMedias.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      FeedMedia feedMedia = feedMedias[i];
      await BackendAPI().feedsAPI.syncFeedMedia(feedMedia);
    }
  }

  Future _syncOutDevices() async {
    List<Device> devices = await RelDB.get().devicesDAO.getUnsyncedDevices();
    for (int i = 0; i < devices.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Device device = devices[i];
      await BackendAPI().feedsAPI.syncDevice(device);
    }
  }

  Future _syncOutBoxes() async {
    List<Box> boxes = await RelDB.get().plantsDAO.getUnsyncedBoxes();
    for (int i = 0; i < boxes.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Box box = boxes[i];
      await BackendAPI().feedsAPI.syncBox(box);
    }
  }

  Future _syncOutPlants() async {
    List<Plant> plants = await RelDB.get().plantsDAO.getUnsyncedPlants();
    for (int i = 0; i < plants.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Plant plant = plants[i];
      await BackendAPI().feedsAPI.syncPlant(plant);
    }
  }

  Future _syncOutTimelapses() async {
    List<Timelapse> timelapses = await RelDB.get().plantsDAO.getUnsyncedTimelapses();
    for (int i = 0; i < timelapses.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Timelapse timelapse = timelapses[i];
      await BackendAPI().feedsAPI.syncTimelapse(timelapse);
    }
  }

  Future _syncOutChecklistSeeds() async {
    List<ChecklistSeed> checklistSeeds = await RelDB.get().checklistsDAO.getUnsyncedChecklistSeeds();
    for (int i = 0; i < checklistSeeds.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      ChecklistSeed checklistSeed = checklistSeeds[i];
      await BackendAPI().checklistAPI.syncChecklistSeed(checklistSeed);
    }
  }

  Future _syncOutChecklists() async {
    List<Checklist> checklists = await RelDB.get().checklistsDAO.getUnsyncedChecklists();
    for (int i = 0; i < checklists.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      Checklist checklist = checklists[i];
      String? serverID = await BackendAPI().checklistAPI.syncChecklist(checklist);
      if (serverID != null) {
        List<ChecklistSeed> checklistSeeds = await RelDB.get().checklistsDAO.getChecklistSeeds(checklist.id);
        for (int j = 0; j < checklistSeeds.length; ++j) {
          await RelDB.get()
              .checklistsDAO
              .updateChecklistSeed(checklistSeeds[j].copyWith(checklistServerID: serverID).toCompanion(false));
        }
      }
    }
  }

  Future _syncOutChecklistLogs() async {
    List<ChecklistLog> checklistLogs = await RelDB.get().checklistsDAO.getUnsyncedChecklistLogs();
    for (int i = 0; i < checklistLogs.length; ++i) {
      if (_usingWifi == false && AppDB().getAppData().syncOverGSM == false) {
        throw 'Can\'t sync over GSM';
      }
      ChecklistLog checklistLog = checklistLogs[i];
      await BackendAPI().checklistAPI.syncChecklistLog(checklistLog);
    }
  }

  Future _deleteFileIfExists(String filePath) async {
    final File file = File(filePath);
    try {
      await file.delete();
    } catch (e, trace) {
      Logger.logError(e, trace, data: {"filePath": filePath});
    }
  }

  @override
  Future<void> close() async {
    _connectivity.cancel();
    _timerOut?.cancel();
    _timerIn?.cancel();
    return super.close();
  }
}
