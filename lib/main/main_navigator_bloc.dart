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

class MainNavigateToHomeBoxEvent extends MainNavigatorEvent {
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

class MainNavigateToFeedLightFormEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToFeedLightFormEvent(this.box);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedWaterFormEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToFeedWaterFormEvent(this.box);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedVentilationFormEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToFeedVentilationFormEvent(this.box);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedMediaFormEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToFeedMediaFormEvent(this.box);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedDefoliationFormEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToFeedDefoliationFormEvent(this.box);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedScheduleFormEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToFeedScheduleFormEvent(this.box);

  @override
  List<Object> get props => [];
}

class MainNavigateToFeedToppingFormEvent extends MainNavigatorEvent {
  final Box box;

  MainNavigateToFeedToppingFormEvent(this.box);

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
    } else if (event is MainNavigateToHomeEvent ||
        event is MainNavigateToHomeBoxEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/home', arguments: event);
    } else if (event is MainNavigateToNewBoxInfosEvent) {
      _navigatorKey.currentState.pushNamed('/box/new', arguments: event);
    } else if (event is MainNavigateToSelectBoxDeviceEvent) {
      _navigatorKey.currentState
          .pushReplacementNamed('/box/device', arguments: event);
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
      _navigatorKey.currentState
          .pushNamed('/feed/form/defoliation', arguments: event);
    } else if (event is MainNavigateToFeedLightFormEvent) {
      _navigatorKey.currentState
          .pushNamed('/feed/form/light', arguments: event);
    } else if (event is MainNavigateToFeedMediaFormEvent) {
      _navigatorKey.currentState
          .pushNamed('/feed/form/media', arguments: event);
    } else if (event is MainNavigateToFeedScheduleFormEvent) {
      _navigatorKey.currentState
          .pushNamed('/feed/form/schedule', arguments: event);
    } else if (event is MainNavigateToFeedToppingFormEvent) {
      _navigatorKey.currentState
          .pushNamed('/feed/form/topping', arguments: event);
    } else if (event is MainNavigateToFeedVentilationFormEvent) {
      _navigatorKey.currentState
          .pushNamed('/feed/form/ventilation', arguments: event);
    } else if (event is MainNavigateToFeedWaterFormEvent) {
      _navigatorKey.currentState
          .pushNamed('/feed/form/water', arguments: event);
    }
  }
}
