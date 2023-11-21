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
import 'dart:math';
import 'dart:typed_data';

import 'package:super_green_app/misc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/device_daemon/device_reachable_listener_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/state/feed_entry_state.dart';
import 'package:super_green_app/pages/feeds/home/common/settings/plant_settings.dart';

class MainNavigatorEvent extends Equatable {
  final dynamic Function(Future<dynamic>? future)? futureFn;

  MainNavigatorEvent({this.futureFn});

  @override
  List<Object?> get props => [futureFn];
}

class MainNavigateToHomeEvent extends MainNavigatorEvent {
  final Plant? plant;
  final FeedEntry? feedEntry;
  final String? commentID;
  final String? replyTo;

  final Checklist? checklist;
  final ChecklistSeed? checklistSeed;

  MainNavigateToHomeEvent({this.plant, this.feedEntry, this.commentID, this.replyTo, this.checklist, this.checklistSeed,});

  @override
  List<Object?> get props => [plant, feedEntry, commentID, replyTo, checklistSeed,];
}

class MainNavigateToCreatePlantEvent extends MainNavigatorEvent {
  
  MainNavigateToCreatePlantEvent({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToSelectBoxEvent extends MainNavigatorEvent {
  MainNavigateToSelectBoxEvent({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToCreateBoxEvent extends MainNavigatorEvent {
  MainNavigateToCreateBoxEvent({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToMotorPortEvent extends MainNavigatorEvent {
  final Device device;
  final Box? box;

  MainNavigateToMotorPortEvent(this.device, this.box, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object?> get props => [device, box];
}

class MainNavigateToSelectDeviceEvent extends MainNavigatorEvent {
  MainNavigateToSelectDeviceEvent({futureFn}) : super(futureFn: futureFn);
}

class MainNavigateToSelectDeviceBoxEvent extends MainNavigatorEvent {
  final Device device;

  MainNavigateToSelectDeviceBoxEvent(this.device, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}

class MainNavigateToSelectNewDeviceBoxEvent extends MainNavigatorEvent {
  final Device device;
  final int boxID;

  MainNavigateToSelectNewDeviceBoxEvent(this.device, this.boxID, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [device, boxID];
}

class MainNavigateToAddDeviceEvent extends MainNavigatorEvent {
  MainNavigateToAddDeviceEvent({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToNewDeviceEvent extends MainNavigatorEvent {
  final bool popOnComplete;

  MainNavigateToNewDeviceEvent(this.popOnComplete, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [popOnComplete];
}

class MainNavigateToExistingDeviceEvent extends MainNavigatorEvent {
  MainNavigateToExistingDeviceEvent({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToDeviceSetupEvent extends MainNavigatorEvent {
  final ip;

  MainNavigateToDeviceSetupEvent(this.ip, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [ip];
}

class MainNavigateToDeviceNameEvent extends MainNavigatorEvent {
  final Device device;
  MainNavigateToDeviceNameEvent(this.device, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}

class MainNavigateToDevicePairingEvent extends MainNavigatorEvent {
  final Device device;
  MainNavigateToDevicePairingEvent(this.device, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}

class MainNavigateToDeviceTestEvent extends MainNavigatorEvent {
  final Device device;
  MainNavigateToDeviceTestEvent(this.device, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}

class MainNavigateToFeedFormEvent extends MainNavigatorEvent {
  final bool pushAsReplacement;

  MainNavigateToFeedFormEvent(this.pushAsReplacement, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object?> get props => [pushAsReplacement];
}

class MainNavigateToFeedLightFormEvent extends MainNavigateToFeedFormEvent implements DeviceNavigationArgHolder {
  final Box box;

  MainNavigateToFeedLightFormEvent(this.box, {pushAsReplacement = false, futureFn})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object> get props => [box];

  @override
  Future<Device> getDevice() {
    return RelDB.get().devicesDAO.getDevice(box.device!);
  }
}

class MainNavigateToFeedWaterFormEvent extends MainNavigateToFeedFormEvent {
  final Plant plant;

  MainNavigateToFeedWaterFormEvent(this.plant, {pushAsReplacement = false, futureFn})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object> get props => [plant];
}

class MainNavigateToFeedVentilationFormEvent extends MainNavigateToFeedFormEvent implements DeviceNavigationArgHolder {
  final Box box;

  MainNavigateToFeedVentilationFormEvent(this.box, {pushAsReplacement = false, futureFn})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object> get props => [box];

  @override
  Future<Device> getDevice() {
    return RelDB.get().devicesDAO.getDevice(box.device!);
  }
}

class MainNavigateToFeedMediaFormEvent extends MainNavigateToFeedFormEvent {
  final Plant? plant;
  final Box? box;

  MainNavigateToFeedMediaFormEvent({this.plant, this.box, pushAsReplacement = false, futureFn})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object?> get props => [plant, box];
}

class MainNavigateToFeedMeasureFormEvent extends MainNavigateToFeedFormEvent {
  final Plant plant;

  MainNavigateToFeedMeasureFormEvent(this.plant, {pushAsReplacement = false, futureFn})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object> get props => [plant];
}

class MainNavigateToFeedCareCommonFormEvent extends MainNavigateToFeedFormEvent {
  final Plant plant;

  MainNavigateToFeedCareCommonFormEvent(this.plant, {pushAsReplacement = false, futureFn})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object> get props => [plant];
}

class MainNavigateToFeedDefoliationFormEvent extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedDefoliationFormEvent(Plant plant, {pushAsReplacement = false, futureFn})
      : super(plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn);
}

class MainNavigateToFeedToppingFormEvent extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedToppingFormEvent(Plant plant, {pushAsReplacement = false, futureFn})
      : super(plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn);
}

class MainNavigateToFeedCloningFormEvent extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedCloningFormEvent(Plant plant, {pushAsReplacement = false, futureFn})
      : super(plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn);
}

class MainNavigateToFeedFimmingFormEvent extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedFimmingFormEvent(Plant plant, {pushAsReplacement = false, futureFn})
      : super(plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn);
}

class MainNavigateToFeedBendingFormEvent extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedBendingFormEvent(Plant plant, {pushAsReplacement = false, futureFn})
      : super(plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn);
}

class MainNavigateToFeedTransplantFormEvent extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedTransplantFormEvent(Plant plant, {pushAsReplacement = false, futureFn})
      : super(plant, pushAsReplacement: pushAsReplacement, futureFn: futureFn);
}

class MainNavigateToFeedScheduleFormEvent extends MainNavigateToFeedFormEvent implements DeviceNavigationArgHolder {
  final Box box;

  MainNavigateToFeedScheduleFormEvent(this.box, {pushAsReplacement = false, futureFn})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object> get props => [box];

  @override
  Future<Device> getDevice() {
    return RelDB.get().devicesDAO.getDevice(box.device!);
  }
}

class MainNavigateToFeedLifeEventFormEvent extends MainNavigateToFeedFormEvent {
  final Plant plant;
  final PlantPhases phase;

  MainNavigateToFeedLifeEventFormEvent(this.plant, this.phase, {pushAsReplacement = false, futureFn})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object> get props => [plant];
}

class MainNavigateToFeedNutrientMixFormEvent extends MainNavigateToFeedFormEvent {
  final Plant plant;

  MainNavigateToFeedNutrientMixFormEvent(this.plant, {pushAsReplacement = false, futureFn})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToCommentFormEvent extends MainNavigateToFeedFormEvent {
  final bool autoFocus;
  final FeedEntryStateLoaded feedEntry;
  final String? commentID;
  final String? replyTo;

  MainNavigateToCommentFormEvent(this.autoFocus, this.feedEntry,
      {pushAsReplacement = false, futureFn, this.commentID, this.replyTo})
      : super(pushAsReplacement, futureFn: futureFn);

  @override
  List<Object?> get props => [
        feedEntry,
        commentID,
        replyTo,
      ];
}

class MainNavigateToTipEvent extends MainNavigatorEvent {
  final List<String> paths;
  final String? tipID;
  final MainNavigateToFeedFormEvent? nextRoute;

  MainNavigateToTipEvent(this.tipID, this.paths, this.nextRoute, {Function(Future<dynamic>? f)? futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object?> get props => [this.tipID, this.paths, nextRoute];
}

class MainNavigateToImageCaptureEvent extends MainNavigatorEvent {
  final bool videoEnabled;
  final bool pickerEnabled;
  final String? overlayPath;

  MainNavigateToImageCaptureEvent(
      {Function(Future<dynamic>? f)? futureFn, this.videoEnabled = true, this.pickerEnabled = true, this.overlayPath})
      : super(futureFn: futureFn);

  @override
  List<Object?> get props => [videoEnabled, overlayPath, futureFn];
}

class MainNavigateToImageCapturePlaybackEvent extends MainNavigatorEvent {
  final String cancelButton;
  final String okButton;

  final int rand = Random().nextInt(1 << 32);
  final String filePath;
  final String? overlayPath;

  MainNavigateToImageCapturePlaybackEvent(this.filePath,
      {Function(Future<dynamic>? f)? futureFn, this.cancelButton = 'RETAKE', this.okButton = 'NEXT', this.overlayPath})
      : super(futureFn: futureFn);

  @override
  List<Object?> get props => [rand, futureFn, filePath];
}

class MainNavigateToDeviceWifiEvent extends MainNavigatorEvent {
  final Device device;

  MainNavigateToDeviceWifiEvent(this.device, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object?> get props => [futureFn, device];
}

class MainNavigateToFullscreenMedia extends MainNavigatorEvent {
  final String? overlayPath;
  final String thumbnailPath;
  final String filePath;
  final String? heroPath;
  final String? sliderTitle;

  MainNavigateToFullscreenMedia(this.thumbnailPath, this.filePath, {this.overlayPath, this.heroPath, this.sliderTitle});

  @override
  List<Object?> get props => [thumbnailPath, filePath, overlayPath, heroPath];
}

class MainNavigateToFullscreenPicture extends MainNavigatorEvent {
  final int id;
  final Uint8List image;

  MainNavigateToFullscreenPicture(this.id, this.image);

  @override
  List<Object> get props => [id, image];
}

class MainNavigateToTimelapseViewer extends MainNavigatorEvent {
  final Plant plant;

  MainNavigateToTimelapseViewer(this.plant) : super();

  @override
  List<Object> get props => [plant];
}

class MainNavigateToQRCodeViewer extends MainNavigatorEvent {
  final Plant plant;

  MainNavigateToQRCodeViewer(this.plant) : super();

  @override
  List<Object> get props => [plant];
}

class MainNavigateToSettingsAuth extends MainNavigatorEvent {
  MainNavigateToSettingsAuth({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToSettingsLogin extends MainNavigatorEvent {
  MainNavigateToSettingsLogin({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToSettingsCreateAccount extends MainNavigatorEvent {
  MainNavigateToSettingsCreateAccount({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToSettingsPlants extends MainNavigatorEvent {
  MainNavigateToSettingsPlants();

  @override
  List<Object> get props => [];
}

class MainNavigateToSettingsPlant extends MainNavigatorEvent {
  final Plant plant;

  MainNavigateToSettingsPlant(this.plant);

  @override
  List<Object> get props => [plant];
}

class MainNavigateToSettingsPlantAlerts extends MainNavigatorEvent {
  final Plant plant;

  MainNavigateToSettingsPlantAlerts(this.plant, {void Function(Future<dynamic>? future)? futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [plant];
}

class MainNavigateToSettingsBoxes extends MainNavigatorEvent {
  MainNavigateToSettingsBoxes();

  @override
  List<Object> get props => [];
}

class MainNavigateToSettingsBox extends MainNavigatorEvent {
  final Box box;

  MainNavigateToSettingsBox(this.box, {void Function(Future<dynamic>? future)? futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [box];
}

class MainNavigateToSettingsDevices extends MainNavigatorEvent {
  MainNavigateToSettingsDevices();

  @override
  List<Object> get props => [];
}

class MainNavigateToSettingsDevice extends MainNavigatorEvent {
  final Device device;

  MainNavigateToSettingsDevice(this.device);

  @override
  List<Object> get props => [device];
}

class MainNavigateToSettingsRemoteControl extends MainNavigatorEvent {
  final Device device;

  MainNavigateToSettingsRemoteControl(this.device);

  @override
  List<Object> get props => [device];
}

class MainNavigateToSettingsDeviceAuth extends MainNavigatorEvent {
  final Device device;

  MainNavigateToSettingsDeviceAuth(this.device);

  @override
  List<Object> get props => [device];
}

class MainNavigateToSettingsUpgradeDevice extends MainNavigatorEvent {
  final Device device;

  MainNavigateToSettingsUpgradeDevice(this.device, {void Function(Future<dynamic>? future)? futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}


class MainNavigateToRefreshParameters extends MainNavigatorEvent {
  final Device device;

  MainNavigateToRefreshParameters(this.device, {void Function(Future<dynamic>? future)? futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}

class MainNavigateToPublicPlant extends MainNavigatorEvent {
  final String id;
  final String? name;
  final String? feedEntryID;
  final String? commentID;
  final String? replyTo;

  MainNavigateToPublicPlant(this.id, {this.name, this.feedEntryID, this.commentID, this.replyTo});

  @override
  List<Object?> get props => [id, name, feedEntryID, commentID, replyTo];
}

class MainNavigateToBookmarks extends MainNavigatorEvent {
  MainNavigateToBookmarks();

  @override
  List<Object> get props => [];
}

class MainNavigateToSelectNewProductEvent extends MainNavigatorEvent {
  final List<Product> selectedProducts;
  final ProductCategoryID? categoryID;

  MainNavigateToSelectNewProductEvent(this.selectedProducts, {this.categoryID, futureFn}) : super(futureFn: futureFn);

  @override
  List<Object?> get props => [...super.props, selectedProducts];
}

class MainNavigateToProductInfosEvent extends MainNavigatorEvent {
  final ProductCategoryID productCategoryID;

  MainNavigateToProductInfosEvent(this.productCategoryID, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object?> get props => [...super.props, productCategoryID];
}

class MainNavigateToProductSupplierEvent extends MainNavigatorEvent {
  final List<Product> products;

  MainNavigateToProductSupplierEvent(this.products, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object?> get props => [...super.props, products];
}

class MainNavigateToProductTypeEvent extends MainNavigatorEvent {
  MainNavigateToProductTypeEvent({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object?> get props => super.props;
}

class MainNavigateToPlantPickerEvent extends MainNavigatorEvent {
  final List<Plant> preselectedPlants;
  final String title;

  MainNavigateToPlantPickerEvent(this.preselectedPlants, this.title, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object?> get props => [...super.props, preselectedPlants, title];
}

class MainNavigateToSelectPlantEvent extends MainNavigatorEvent {
  final String title;
  final bool noPublic;

  MainNavigateToSelectPlantEvent(this.title, this.noPublic, {futureFn}) : super(futureFn: futureFn);

  @override
  List<Object?> get props => [...super.props, title];
}

class MainNavigateToRemoteBoxEvent extends MainNavigatorEvent {
  final String id;

  MainNavigateToRemoteBoxEvent(this.id);

  @override
  List<Object> get props => [id];
}

class MainNavigateToFollowsFeedEvent extends MainNavigatorEvent {
  MainNavigateToFollowsFeedEvent();

  @override
  List<Object> get props => [];
}

class MainNavigateToChecklist extends MainNavigatorEvent {
  final Plant plant;
  final Box box;
  final Checklist checklist;

  MainNavigateToChecklist(this.plant, this.box, this.checklist);

  @override
  List<Object> get props => [plant, box, checklist,];
}

class MainNavigateToCreateChecklist extends MainNavigatorEvent {
  final Checklist checklist;
  final ChecklistSeed? checklistSeed;

  MainNavigateToCreateChecklist(this.checklist, {this.checklistSeed});

  @override
  List<Object?> get props => [checklist, checklistSeed,];
}

class MainNavigateToChecklistCollections extends MainNavigatorEvent {
  final Checklist checklist;

  MainNavigateToChecklistCollections(this.checklist);

  @override
  List<Object?> get props => [checklist];
}

class MainNavigatorActionPop extends MainNavigatorEvent {
  final dynamic param;
  final bool mustPop;

  MainNavigatorActionPop({this.param, this.mustPop = false});

  @override
  List<Object> get props => [param];
}

class MainNavigatorActionPopToRoute extends MainNavigatorEvent {
  final String route;
  final dynamic param;
  final bool mustPop;

  MainNavigatorActionPopToRoute(this.route, {this.param, this.mustPop = false});

  @override
  List<Object> get props => [param];
}

class MainNavigatorActionPopToRoot extends MainNavigatorEvent {
  MainNavigatorActionPopToRoot();

  @override
  List<Object> get props => [];
}

class MainNavigatorBloc extends LegacyBloc<MainNavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> _navigatorKey;
  MainNavigatorBloc(this._navigatorKey) : super(0);

  @override
  Stream<dynamic> mapEventToState(MainNavigatorEvent event) async* {
    Future? future;
    if (event is MainNavigatorActionPop) {
      if (event.mustPop) {
        _navigatorKey.currentState!.pop(event.param);
      } else {
        _navigatorKey.currentState!.maybePop(event.param);
      }
    } else if (event is MainNavigatorActionPopToRoute) {
      _navigatorKey.currentState!.popUntil((r) {
        if (r.settings.name == event.route) {
          return true;
        }
        return false;
      });
    } else if (event is MainNavigatorActionPopToRoot) {
      _navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } else if (event is MainNavigateToHomeEvent) {
      future = _navigatorKey.currentState!.pushReplacementNamed('/home', arguments: event);
    } else if (event is MainNavigateToCreatePlantEvent) {
      future = _navigatorKey.currentState!.pushNamed('/plant/new', arguments: event);
    } else if (event is MainNavigateToSelectBoxEvent) {
      future = _navigatorKey.currentState!.pushNamed('/plant/box', arguments: event);
    } else if (event is MainNavigateToCreateBoxEvent) {
      future = _navigatorKey.currentState!.pushNamed('/plant/box/new', arguments: event);
    }  else if (event is MainNavigateToSelectDeviceEvent) {
      future = _navigatorKey.currentState!.pushNamed('/box/device', arguments: event);
    } else if (event is MainNavigateToSelectDeviceBoxEvent) {
      future = _navigatorKey.currentState!.pushNamed('/box/device/box', arguments: event);
    } else if (event is MainNavigateToSelectNewDeviceBoxEvent) {
      future = _navigatorKey.currentState!.pushNamed('/box/device/box/new', arguments: event);
    } else if (event is MainNavigateToMotorPortEvent) {
      future = _navigatorKey.currentState!.pushNamed('/device/motors', arguments: event);
    } else if (event is MainNavigateToAddDeviceEvent) {
      future = _navigatorKey.currentState!.pushNamed('/device/add', arguments: event);
    } else if (event is MainNavigateToNewDeviceEvent) {
      future = _navigatorKey.currentState!.pushNamed('/device/new', arguments: event);
    } else if (event is MainNavigateToExistingDeviceEvent) {
      future = _navigatorKey.currentState!.pushNamed('/device/existing', arguments: event);
    } else if (event is MainNavigateToDeviceSetupEvent) {
      future = _navigatorKey.currentState!.pushNamed('/device/load', arguments: event);
    } else if (event is MainNavigateToDeviceNameEvent) {
      future = _navigatorKey.currentState!.pushNamed('/device/name', arguments: event);
    } else if (event is MainNavigateToDevicePairingEvent) {
      future = _navigatorKey.currentState!.pushNamed('/device/pairing', arguments: event);
    } else if (event is MainNavigateToDeviceTestEvent) {
      future = _navigatorKey.currentState!.pushNamed('/device/test', arguments: event);
    } else if (event is MainNavigateToDeviceWifiEvent) {
      future = _navigatorKey.currentState!.pushNamed('/device/wifi', arguments: event);
    } else if (event is MainNavigateToFeedLightFormEvent) {
      future = _pushOrReplace('/feed/form/light', event);
    } else if (event is MainNavigateToFeedMediaFormEvent) {
      future = _pushOrReplace('/feed/form/media', event);
    } else if (event is MainNavigateToFeedMeasureFormEvent) {
      future = _pushOrReplace('/feed/form/measure', event);
    } else if (event is MainNavigateToFeedScheduleFormEvent) {
      future = _pushOrReplace('/feed/form/schedule', event);
    } else if (event is MainNavigateToFeedToppingFormEvent) {
      future = _pushOrReplace('/feed/form/topping', event);
    } else if (event is MainNavigateToFeedDefoliationFormEvent) {
      future = _pushOrReplace('/feed/form/defoliation', event);
    } else if (event is MainNavigateToFeedCloningFormEvent) {
      future = _pushOrReplace('/feed/form/cloning', event);
    } else if (event is MainNavigateToFeedFimmingFormEvent) {
      future = _pushOrReplace('/feed/form/fimming', event);
    } else if (event is MainNavigateToFeedBendingFormEvent) {
      future = _pushOrReplace('/feed/form/bending', event);
    } else if (event is MainNavigateToFeedTransplantFormEvent) {
      future = _pushOrReplace('/feed/form/transplant', event);
    } else if (event is MainNavigateToFeedVentilationFormEvent) {
      future = _pushOrReplace('/feed/form/ventilation', event);
    } else if (event is MainNavigateToFeedWaterFormEvent) {
      future = _pushOrReplace('/feed/form/water', event);
    } else if (event is MainNavigateToFeedLifeEventFormEvent) {
      future = _pushOrReplace('/feed/form/lifeevents', event);
    } else if (event is MainNavigateToFeedNutrientMixFormEvent) {
      future = _pushOrReplace('/feed/form/nutrient', event);
    } else if (event is MainNavigateToCommentFormEvent) {
      future = _pushOrReplace('/feed/form/comment', event);
    } else if (event is MainNavigateToTipEvent) {
      future = _navigatorKey.currentState!.pushNamed('/tip', arguments: event);
    } else if (event is MainNavigateToImageCaptureEvent) {
      future = _navigatorKey.currentState!.pushNamed('/capture', arguments: event);
    } else if (event is MainNavigateToImageCapturePlaybackEvent) {
      future = _navigatorKey.currentState!.pushNamed('/capture/playback', arguments: event);
    } else if (event is MainNavigateToFullscreenMedia) {
      future = _navigatorKey.currentState!.pushNamed('/media', arguments: event);
    } else if (event is MainNavigateToFullscreenPicture) {
      future = _navigatorKey.currentState!.pushNamed('/picture', arguments: event);
    } else if (event is MainNavigateToTimelapseViewer) {
      future = _navigatorKey.currentState!.pushNamed('/timelapse/viewer', arguments: event);
    } else if (event is MainNavigateToQRCodeViewer) {
      future = _navigatorKey.currentState!.pushNamed('/qrcode/viewer', arguments: event);
    } else if (event is MainNavigateToSettingsAuth) {
      future = _navigatorKey.currentState!.pushNamed('/settings/auth', arguments: event);
    } else if (event is MainNavigateToSettingsLogin) {
      future = _navigatorKey.currentState!.pushNamed('/settings/login', arguments: event);
    } else if (event is MainNavigateToSettingsCreateAccount) {
      future = _navigatorKey.currentState!.pushNamed('/settings/createaccount', arguments: event);
    } else if (event is MainNavigateToSettingsPlants) {
      future = _navigatorKey.currentState!.pushNamed('/settings/plants', arguments: event);
    } else if (event is MainNavigateToSettingsPlant) {
      future = _navigatorKey.currentState!.pushNamed('/settings/plant', arguments: event);
    } else if (event is MainNavigateToSettingsPlantAlerts) {
      future = _navigatorKey.currentState!.pushNamed('/settings/plant/alerts', arguments: event);
    } else if (event is MainNavigateToSettingsBoxes) {
      future = _navigatorKey.currentState!.pushNamed('/settings/boxes', arguments: event);
    } else if (event is MainNavigateToSettingsBox) {
      future = _navigatorKey.currentState!.pushNamed('/settings/box', arguments: event);
    } else if (event is MainNavigateToSettingsDevices) {
      future = _navigatorKey.currentState!.pushNamed('/settings/devices', arguments: event);
    } else if (event is MainNavigateToSettingsDevice) {
      future = _navigatorKey.currentState!.pushNamed('/settings/device', arguments: event);
    } else if (event is MainNavigateToSettingsRemoteControl) {
      future = _navigatorKey.currentState!.pushNamed('/settings/device/remote', arguments: event);
    } else if (event is MainNavigateToSettingsDeviceAuth) {
      future = _navigatorKey.currentState!.pushNamed('/settings/device/auth', arguments: event);
    } else if (event is MainNavigateToSettingsUpgradeDevice) {
      future = _navigatorKey.currentState!.pushNamed('/settings/device/upgrade', arguments: event);
    } else if (event is MainNavigateToRefreshParameters) {
      future = _navigatorKey.currentState!.pushNamed('/device/refresh', arguments: event);
    } else if (event is MainNavigateToPublicPlant) {
      future = _navigatorKey.currentState!.pushNamed('/public/plant', arguments: event);
    } else if (event is MainNavigateToBookmarks) {
      future = _navigatorKey.currentState!.pushNamed('/bookmarks', arguments: event);
    } else if (event is MainNavigateToSelectNewProductEvent) {
      future = _navigatorKey.currentState!.pushNamed('/product/select', arguments: event);
    } else if (event is MainNavigateToProductInfosEvent) {
      future = _navigatorKey.currentState!.pushNamed('/product/new/infos', arguments: event);
    } else if (event is MainNavigateToProductTypeEvent) {
      future = _navigatorKey.currentState!.pushNamed('/product/new/type', arguments: event);
    } else if (event is MainNavigateToProductSupplierEvent) {
      future = _navigatorKey.currentState!.pushNamed('/product/new/supplier', arguments: event);
    } else if (event is MainNavigateToPlantPickerEvent) {
      future = _navigatorKey.currentState!.pushNamed('/plantpicker', arguments: event);
    } else if (event is MainNavigateToSelectPlantEvent) {
      future = _navigatorKey.currentState!.pushNamed('/selectplant', arguments: event);
    } else if (event is MainNavigateToRemoteBoxEvent) {
      future = _navigatorKey.currentState!.pushNamed('/public/box', arguments: event);
    } else if (event is MainNavigateToFollowsFeedEvent) {
      future = _navigatorKey.currentState!.pushNamed('/public/follows', arguments: event);
    } else if (event is MainNavigateToChecklist) {
      future = _navigatorKey.currentState!.pushNamed('/checklist', arguments: event);
    } else if (event is MainNavigateToCreateChecklist) {
      future = _navigatorKey.currentState!.pushNamed('/checklist/create', arguments: event);
    } else if (event is MainNavigateToChecklistCollections) {
      future = _navigatorKey.currentState!.pushNamed('/checklist/collections', arguments: event);
    }
    if (event.futureFn != null) {
      event.futureFn!(future);
    }
  }

  Future _pushOrReplace(String url, MainNavigateToFeedFormEvent event) {
    if (event.pushAsReplacement) {
      return _navigatorKey.currentState!.pushReplacementNamed(url, arguments: event);
    }
    return _navigatorKey.currentState!.pushNamed(url, arguments: event);
  }

  FutureFn futureFn() {
    Completer f = Completer();
    Function(Future?) futureFn = (Future<dynamic>? fu) async {
      var o = await fu;
      f.complete(o);
    };

    return FutureFn(futureFn, f.future);
  }
}

class FutureFn {
  final Function(Future?) futureFn;
  final Future<dynamic> future;

  FutureFn(this.futureFn, this.future);
}
