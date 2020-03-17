/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
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

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

class MainNavigatorEvent extends Equatable {
  final void Function(Future<dynamic> future) futureFn;

  MainNavigatorEvent({this.futureFn});

  @override
  List<Object> get props => [futureFn];
}

class MainNavigateToHomeEvent extends MainNavigatorEvent {
  MainNavigateToHomeEvent();

  @override
  List<Object> get props => [];
}

class MainNavigateToHomeBoxEvent extends MainNavigateToHomeEvent {
  final Box box;

  MainNavigateToHomeBoxEvent(this.box);

  @override
  List<Object> get props => [box];
}

class MainNavigateToNewBoxInfosEvent extends MainNavigatorEvent {
  @override
  List<Object> get props => [];
}

class MainNavigateToSelectBoxDeviceEvent extends MainNavigatorEvent {
  MainNavigateToSelectBoxDeviceEvent({futureFn}) : super(futureFn: futureFn);
}

class MainNavigateToSelectBoxDeviceBoxEvent extends MainNavigatorEvent {
  final Device device;

  MainNavigateToSelectBoxDeviceBoxEvent(this.device, {futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}

class MainNavigateToSelectBoxNewDeviceBoxEvent extends MainNavigatorEvent {
  final Device device;

  MainNavigateToSelectBoxNewDeviceBoxEvent(this.device, {futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}

class MainNavigateToAddDeviceEvent extends MainNavigatorEvent {
  MainNavigateToAddDeviceEvent({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToNewDeviceEvent extends MainNavigatorEvent {
  MainNavigateToNewDeviceEvent({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToExistingDeviceEvent extends MainNavigatorEvent {
  MainNavigateToExistingDeviceEvent({futureFn}) : super(futureFn: futureFn);

  @override
  List<Object> get props => [];
}

class MainNavigateToDeviceSetupEvent extends MainNavigatorEvent {
  final ip;

  MainNavigateToDeviceSetupEvent(this.ip, {futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [ip];
}

class MainNavigateToDeviceNameEvent extends MainNavigatorEvent {
  final Device device;
  MainNavigateToDeviceNameEvent(this.device, {futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}

class MainNavigateToDeviceTestEvent extends MainNavigatorEvent {
  final Device device;
  MainNavigateToDeviceTestEvent(this.device, {futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [device];
}

class MainNavigateToFeedFormEvent extends MainNavigatorEvent {
  final bool pushAsReplacement;

  MainNavigateToFeedFormEvent(this.pushAsReplacement);

  @override
  List<Object> get props => [pushAsReplacement];
}

class MainNavigateToFeedLightFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedLightFormEvent(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
}

class MainNavigateToFeedWaterFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedWaterFormEvent(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
}

class MainNavigateToFeedVentilationFormEvent
    extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedVentilationFormEvent(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
}

class MainNavigateToFeedMediaFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedMediaFormEvent(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
}

class MainNavigateToFeedMeasureFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedMeasureFormEvent(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
}

class MainNavigateToFeedCareCommonFormEvent
    extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedCareCommonFormEvent(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
}

class MainNavigateToFeedDefoliationFormEvent
    extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedDefoliationFormEvent(Box box, {pushAsReplacement = false})
      : super(box, pushAsReplacement: pushAsReplacement);
}

class MainNavigateToFeedToppingFormEvent
    extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedToppingFormEvent(Box box, {pushAsReplacement = false})
      : super(box, pushAsReplacement: pushAsReplacement);
}

class MainNavigateToFeedFimmingFormEvent
    extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedFimmingFormEvent(Box box, {pushAsReplacement = false})
      : super(box, pushAsReplacement: pushAsReplacement);
}

class MainNavigateToFeedBendingFormEvent
    extends MainNavigateToFeedCareCommonFormEvent {
  MainNavigateToFeedBendingFormEvent(Box box, {pushAsReplacement = false})
      : super(box, pushAsReplacement: pushAsReplacement);
}

class MainNavigateToFeedScheduleFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedScheduleFormEvent(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
}

class MainNavigateToTipEvent extends MainNavigatorEvent {
  final MainNavigateToFeedFormEvent nextRoute;

  MainNavigateToTipEvent(this.nextRoute);

  @override
  List<Object> get props => [nextRoute];
}

class MainNavigateToImageCaptureEvent extends MainNavigatorEvent {
  final bool videoEnabled;
  final String overlayPath;

  MainNavigateToImageCaptureEvent(
      {Function(Future<Object> f) futureFn,
      this.videoEnabled=true,
      this.overlayPath})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [videoEnabled, overlayPath, futureFn];
}


class MainNavigateToImageCapturePlaybackEvent extends MainNavigatorEvent {
  final String cancelButton;
  final String okButton;

  final int rand = Random().nextInt(1 << 32);
  final String filePath;
  final String overlayPath;

  MainNavigateToImageCapturePlaybackEvent(this.filePath,
      {Function(Future<Object> f) futureFn,
      this.cancelButton = 'RETAKE',
      this.okButton = 'NEXT',
      this.overlayPath})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [rand, futureFn, filePath];
}

class MainNavigateToDeviceWifiEvent extends MainNavigatorEvent {
  final Device device;

  MainNavigateToDeviceWifiEvent(this.device, {futureFn})
      : super(futureFn: futureFn);

  @override
  List<Object> get props => [futureFn, device];
}

class MainNavigateToFullscreenMedia extends MainNavigatorEvent {
  final FeedMedia feedMedia;

  MainNavigateToFullscreenMedia(this.feedMedia);

  @override
  List<Object> get props => [feedMedia];
}

class MainNavigateToFullscreenPicture extends MainNavigatorEvent {
  final String path;

  MainNavigateToFullscreenPicture(this.path);

  @override
  List<Object> get props => [path];
}

class MainNavigateToTimelapseHowto extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToTimelapseHowto(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
}

class MainNavigateToTimelapseSetup extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToTimelapseSetup(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
}

class MainNavigateToTimelapseViewer extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToTimelapseViewer(this.box, {pushAsReplacement = false})
      : super(pushAsReplacement);

  @override
  List<Object> get props => [box];
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

class MainNavigatorBloc extends Bloc<MainNavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> _navigatorKey;
  MainNavigatorBloc(this._navigatorKey);

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(MainNavigatorEvent event) async* {
    Future future;
    if (event is MainNavigatorActionPop) {
      if (event.mustPop) {
        _navigatorKey.currentState.pop(event.param);
      } else {
        _navigatorKey.currentState.maybePop(event.param);
      }
    } else if (event is MainNavigatorActionPopToRoute) {
      _navigatorKey.currentState.popUntil((r) {
        if (r.settings.name == event.route) {
          return true;
        }
        return false;
      });
    } else if (event is MainNavigatorActionPopToRoot) {
      _navigatorKey.currentState.popUntil((route) => route.isFirst);
    } else if (event is MainNavigateToHomeEvent) {
      future = _navigatorKey.currentState
          .pushReplacementNamed('/home', arguments: event);
    } else if (event is MainNavigateToNewBoxInfosEvent) {
      future =
          _navigatorKey.currentState.pushNamed('/box/new', arguments: event);
    } else if (event is MainNavigateToSelectBoxDeviceEvent) {
      future =
          _navigatorKey.currentState.pushNamed('/box/device', arguments: event);
    } else if (event is MainNavigateToSelectBoxDeviceBoxEvent) {
      future = _navigatorKey.currentState
          .pushNamed('/box/device/box', arguments: event);
    } else if (event is MainNavigateToSelectBoxNewDeviceBoxEvent) {
      future = _navigatorKey.currentState
          .pushNamed('/box/device/new', arguments: event);
    } else if (event is MainNavigateToAddDeviceEvent) {
      future =
          _navigatorKey.currentState.pushNamed('/device/add', arguments: event);
    } else if (event is MainNavigateToNewDeviceEvent) {
      future =
          _navigatorKey.currentState.pushNamed('/device/new', arguments: event);
    } else if (event is MainNavigateToExistingDeviceEvent) {
      future = _navigatorKey.currentState
          .pushNamed('/device/existing', arguments: event);
    } else if (event is MainNavigateToDeviceSetupEvent) {
      future = _navigatorKey.currentState
          .pushNamed('/device/load', arguments: event);
    } else if (event is MainNavigateToDeviceNameEvent) {
      future = _navigatorKey.currentState
          .pushNamed('/device/name', arguments: event);
    } else if (event is MainNavigateToDeviceTestEvent) {
      future = _navigatorKey.currentState
          .pushNamed('/device/test', arguments: event);
    } else if (event is MainNavigateToDeviceWifiEvent) {
      future = _navigatorKey.currentState
          .pushNamed('/device/wifi', arguments: event);
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
    } else if (event is MainNavigateToFeedFimmingFormEvent) {
      future = _pushOrReplace('/feed/form/fimming', event);
    } else if (event is MainNavigateToFeedBendingFormEvent) {
      future = _pushOrReplace('/feed/form/bending', event);
    } else if (event is MainNavigateToFeedVentilationFormEvent) {
      future = _pushOrReplace('/feed/form/ventilation', event);
    } else if (event is MainNavigateToFeedWaterFormEvent) {
      future = _pushOrReplace('/feed/form/water', event);
    } else if (event is MainNavigateToTipEvent) {
      future = _navigatorKey.currentState.pushNamed('/tip', arguments: event);
    } else if (event is MainNavigateToImageCaptureEvent) {
      future =
          _navigatorKey.currentState.pushNamed('/capture', arguments: event);
    } else if (event is MainNavigateToImageCapturePlaybackEvent) {
      future = _navigatorKey.currentState
          .pushNamed('/capture/playback', arguments: event);
    } else if (event is MainNavigateToFullscreenMedia) {
      future = future =
          _navigatorKey.currentState.pushNamed('/media', arguments: event);
    } else if (event is MainNavigateToFullscreenPicture) {
      future = future =
          _navigatorKey.currentState.pushNamed('/media', arguments: event);
    } else if (event is MainNavigateToTimelapseHowto) {
      future = future =
          _navigatorKey.currentState.pushNamed('/timelapse/howto', arguments: event);
    } else if (event is MainNavigateToTimelapseSetup) {
      future = future =
          _navigatorKey.currentState.pushNamed('/timelapse/setup', arguments: event);
    } else if (event is MainNavigateToTimelapseViewer) {
      future = future =
          _navigatorKey.currentState.pushNamed('/timelapse/viewer', arguments: event);
    }
    if (event.futureFn != null) {
      event.futureFn(future);
    }
  }

  Future _pushOrReplace(String url, MainNavigateToFeedFormEvent event) {
    if (event.pushAsReplacement) {
      return _navigatorKey.currentState
          .pushReplacementNamed(url, arguments: event);
    }
    return _navigatorKey.currentState.pushNamed(url, arguments: event);
  }

  FutureFn futureFn() {
    Completer f = Completer();
    Function(Future) futureFn = (Future<dynamic> fu) async {
      var o = await fu;
      f.complete(o);
    };

    return FutureFn(futureFn, f.future);
  }
}

class FutureFn {
  final Function(Future) futureFn;
  final Future<dynamic> future;

  FutureFn(this.futureFn, this.future);
}
