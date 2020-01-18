import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class MainNavigatorEvent extends Equatable {}

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
  final Box box;

  MainNavigateToSelectBoxDeviceEvent(this.box);

  @override
  List<Object> get props => [box];
}

class MainNavigateToSelectBoxDeviceBoxEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToSelectBoxDeviceBoxEvent(this.box);

  @override
  List<Object> get props => [box];
}

class MainNavigateToNewDeviceEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToNewDeviceEvent(this.box);

  @override
  List<Object> get props => [box];
}

class MainNavigateToExistingDeviceEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToExistingDeviceEvent(this.box);

  @override
  List<Object> get props => [box];
}

class MainNavigateToDeviceSetupEvent extends MainNavigatorEvent {
  final ip;
  final Box box;

  MainNavigateToDeviceSetupEvent(this.box, this.ip);

  @override
  List<Object> get props => [ip];
}

class MainNavigateToDeviceNameEvent extends MainNavigatorEvent {
  final Box box;
  final Device device;
  MainNavigateToDeviceNameEvent(this.box, this.device);

  @override
  List<Object> get props => [box, device];
}

class MainNavigateToDeviceDoneEvent extends MainNavigatorEvent {
  final Box box;
  final Device device;
  MainNavigateToDeviceDoneEvent(this.box, this.device);

  @override
  List<Object> get props => [box, device];
}

class MainNavigateToFeedFormEvent extends MainNavigatorEvent {
  final bool fromTip;

  MainNavigateToFeedFormEvent(this.fromTip);

  @override
  List<Object> get props => [fromTip];
}

class MainNavigateToFeedLightFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedLightFormEvent(this.box, {fromTip = false})
      : super(fromTip);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedWaterFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedWaterFormEvent(this.box, {fromTip = false})
      : super(fromTip);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedVentilationFormEvent
    extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedVentilationFormEvent(this.box, {fromTip = false})
      : super(fromTip);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedMediaFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedMediaFormEvent(this.box, {fromTip = false})
      : super(fromTip);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedDefoliationFormEvent
    extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedDefoliationFormEvent(this.box, {fromTip = false})
      : super(fromTip);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedScheduleFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedScheduleFormEvent(this.box, {fromTip = false})
      : super(fromTip);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedToppingFormEvent extends MainNavigateToFeedFormEvent {
  final Box box;

  MainNavigateToFeedToppingFormEvent(this.box, {fromTip = false})
      : super(fromTip);

  @override
  List<Object> get props => [];
}

class MainNavigateToTipEvent extends MainNavigatorEvent {
  final MainNavigateToFeedFormEvent nextRoute;

  MainNavigateToTipEvent(this.nextRoute);

  @override
  List<Object> get props => [];
}

class MainNavigatorActionPop extends MainNavigatorEvent {
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
    if (event is MainNavigatorActionPop) {
      _navigatorKey.currentState.pop();
    } else if (event is MainNavigateToHomeEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/home', arguments: event);
    } else if (event is MainNavigateToNewBoxInfosEvent) {
      _navigatorKey.currentState.pushNamed('/box/new', arguments: event);
    } else if (event is MainNavigateToSelectBoxDeviceEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/box/device', arguments: event);
    } else if (event is MainNavigateToSelectBoxDeviceBoxEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/box/device/box', arguments: event);
    } else if (event is MainNavigateToNewDeviceEvent) {
      _navigatorKey.currentState.pushNamed('/device/new', arguments: event);
    } else if (event is MainNavigateToExistingDeviceEvent) {
      _navigatorKey.currentState.pushNamed('/device/add', arguments: event);
    } else if (event is MainNavigateToDeviceSetupEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/device/load', arguments: event);
    } else if (event is MainNavigateToDeviceNameEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/device/name', arguments: event);
    } else if (event is MainNavigateToDeviceDoneEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/device/done', arguments: event);
    } else if (event is MainNavigateToFeedDefoliationFormEvent) {
      _pushFeedFormTip('/feed/form/defoliation', event);
    } else if (event is MainNavigateToFeedLightFormEvent) {
      _pushFeedFormTip('/feed/form/light', event);
    } else if (event is MainNavigateToFeedMediaFormEvent) {
      _pushFeedFormTip('/feed/form/media', event);
    } else if (event is MainNavigateToFeedScheduleFormEvent) {
      _pushFeedFormTip('/feed/form/schedule', event);
    } else if (event is MainNavigateToFeedToppingFormEvent) {
      _pushFeedFormTip('/feed/form/topping', event);
    } else if (event is MainNavigateToFeedVentilationFormEvent) {
      _pushFeedFormTip('/feed/form/ventilation', event);
    } else if (event is MainNavigateToFeedWaterFormEvent) {
      _pushFeedFormTip('/feed/form/water', event);
    } else if (event is MainNavigateToTipEvent) {
      _navigatorKey.currentState.pushNamed('/tip', arguments: event);
    }
  }

  void _pushFeedFormTip(String url, MainNavigateToFeedFormEvent event) {
    if (event.fromTip) {
      _navigatorKey.currentState.pushReplacementNamed(url, arguments: event);
      return;
    }
    _navigatorKey.currentState.pushNamed(url, arguments: event);
  }
}
