import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedLightFormBlocEvent extends Equatable {}

class FeedLightFormBlocEventLoadLights extends FeedLightFormBlocEvent {
  FeedLightFormBlocEventLoadLights();

  @override
  List<Object> get props => [];
}

class FeedLightFormBlocEventCreate extends FeedLightFormBlocEvent {
  final List<double> values;

  FeedLightFormBlocEventCreate(this.values);

  @override
  List<Object> get props => [values];
}

class FeedLightFormBlocValueChangedEvent extends FeedLightFormBlocEvent {
  final int i;
  final double value;

  FeedLightFormBlocValueChangedEvent(this.i, this.value);

  @override
  List<Object> get props => [i, value];
}

abstract class FeedLightFormBlocState extends Equatable {}

class FeedLightFormBlocStateIdle extends FeedLightFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedLightFormBlocStateLightsLoaded extends FeedLightFormBlocState {
  final List<double> values;

  FeedLightFormBlocStateLightsLoaded(this.values);

  @override
  List<Object> get props => [values];
}

class FeedLightFormBlocStateDone extends FeedLightFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedLightFormBloc
    extends Bloc<FeedLightFormBlocEvent, FeedLightFormBlocState> {
  final MainNavigateToFeedLightFormEvent _args;

  Device _device;
  List<Param> _lightParams;
  List<double> _initialValues;

  @override
  FeedLightFormBlocState get initialState => FeedLightFormBlocStateIdle();

  FeedLightFormBloc(this._args) {
    add(FeedLightFormBlocEventLoadLights());
  }

  @override
  Stream<FeedLightFormBlocState> mapEventToState(
      FeedLightFormBlocEvent event) async* {
    if (event is FeedLightFormBlocEventLoadLights) {
      final db = RelDB.get();
      _device = await db.devicesDAO.getDevice(_args.box.device);
      Module lightModule = await db.devicesDAO.getModule(_device.id, "led");
      _lightParams = List(lightModule.arrayLen);
      for (int i = 0; i < lightModule.arrayLen; ++i) {
        Param box = await db.devicesDAO.getParam(_device.id, "LED_${i}_BOX");
        if (box.ivalue == _args.box.deviceBox) {
          _lightParams[i] =
              await db.devicesDAO.getParam(_device.id, "LED_${i}_DIM");
        }
      }
      List<double> values = _lightParams.map((l) => l.ivalue.toDouble()).toList();
      _initialValues = values;
      yield FeedLightFormBlocStateLightsLoaded(values);
    } else if (event is FeedLightFormBlocValueChangedEvent) {
      await DeviceHelper.updateIntParam(_device, _lightParams[event.i], (event.value).toInt());
    } else if (event is FeedLightFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_LIGHT',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: JsonEncoder().convert({'initialValues': _initialValues, 'values': event.values}),
      ));
      yield FeedLightFormBlocStateDone();
    }
  }
}
