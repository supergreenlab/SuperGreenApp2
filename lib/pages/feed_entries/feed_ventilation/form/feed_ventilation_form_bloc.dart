import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedVentilationFormBlocEvent extends Equatable {}

class FeedVentilationFormBlocEventLoadVentilations
    extends FeedVentilationFormBlocEvent {
  FeedVentilationFormBlocEventLoadVentilations();

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocEventCreate extends FeedVentilationFormBlocEvent {
  final int blowerDay;
  final int blowerNight;

  FeedVentilationFormBlocEventCreate(this.blowerDay, this.blowerNight);

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocBlowerDayChangedEvent
    extends FeedVentilationFormBlocEvent {
  final int blowerDay;

  FeedVentilationFormBlocBlowerDayChangedEvent(this.blowerDay);

  @override
  List<Object> get props => [blowerDay];
}

class FeedVentilationFormBlocBlowerNightChangedEvent
    extends FeedVentilationFormBlocEvent {
  final int blowerNight;

  FeedVentilationFormBlocBlowerNightChangedEvent(this.blowerNight);

  @override
  List<Object> get props => [blowerNight];
}

class FeedVentilationFormBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocStateVentilationLoaded
    extends FeedVentilationFormBlocState {
  final int initialBlowerDay;
  final int initialBlowerNight;
  final int blowerDay;
  final int blowerNight;

  FeedVentilationFormBlocStateVentilationLoaded(this.initialBlowerDay,
      this.initialBlowerNight, this.blowerDay, this.blowerNight);

  @override
  List<Object> get props =>
      [initialBlowerDay, initialBlowerNight, blowerDay, blowerNight];
}

class FeedVentilationFormBlocStateDone extends FeedVentilationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBloc
    extends Bloc<FeedVentilationFormBlocEvent, FeedVentilationFormBlocState> {
  final MainNavigateToFeedVentilationFormEvent _args;

  Device _device;
  Param _blowerDay;
  Param _blowerNight;
  int _initialBlowerDay;
  int _initialBlowerNight;

  @override
  FeedVentilationFormBlocState get initialState =>
      FeedVentilationFormBlocState();

  FeedVentilationFormBloc(this._args) {
    add(FeedVentilationFormBlocEventLoadVentilations());
  }

  @override
  Stream<FeedVentilationFormBlocState> mapEventToState(
      FeedVentilationFormBlocEvent event) async* {
    if (event is FeedVentilationFormBlocEventLoadVentilations) {
      final db = RelDB.get();
      _device = await db.devicesDAO.getDevice(_args.box.device);
      _blowerDay = await db.devicesDAO
          .getParam(_device.id, "BOX_${_args.box.deviceBox}_BLOWER_DAY");
      _initialBlowerDay = _blowerDay.ivalue;
      _blowerNight = await db.devicesDAO
          .getParam(_device.id, "BOX_${_args.box.deviceBox}_BLOWER_NIGHT");
      _initialBlowerNight = _blowerNight.ivalue;
      yield FeedVentilationFormBlocStateVentilationLoaded(_initialBlowerDay,
          _initialBlowerNight, _blowerDay.ivalue, _blowerNight.ivalue);
    } else if (event is FeedVentilationFormBlocBlowerDayChangedEvent) {
      _blowerDay = _blowerDay.copyWith(ivalue: event.blowerDay);
      await DeviceHelper.updateIntParam(
          _device, _blowerDay, (event.blowerDay).toInt());
      yield FeedVentilationFormBlocStateVentilationLoaded(_initialBlowerDay,
          _initialBlowerNight, _blowerDay.ivalue, _blowerNight.ivalue);
    } else if (event is FeedVentilationFormBlocBlowerNightChangedEvent) {
      _blowerNight = _blowerDay.copyWith(ivalue: event.blowerNight);
      await DeviceHelper.updateIntParam(
          _device, _blowerNight, (event.blowerNight).toInt());
      yield FeedVentilationFormBlocStateVentilationLoaded(_initialBlowerDay,
          _initialBlowerNight, _blowerDay.ivalue, _blowerNight.ivalue);
    } else if (event is FeedVentilationFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_VENTILATION',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({
          'initialValues': {
            'blowerDay': _initialBlowerDay,
            'blowerNight': _initialBlowerNight
          },
          'values': {
            'blowerDay': event.blowerDay,
            'blowerNight': event.blowerNight
          }
        })),
      ));
      yield FeedVentilationFormBlocStateDone();
    }
  }
}
