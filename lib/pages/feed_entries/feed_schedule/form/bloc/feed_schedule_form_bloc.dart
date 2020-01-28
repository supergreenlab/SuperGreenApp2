import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedScheduleFormBlocEvent extends Equatable {}

class FeedScheduleFormBlocEventInit extends FeedScheduleFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedScheduleFormBlocEventSetSchedule extends FeedScheduleFormBlocEvent {
  final String schedule;

  FeedScheduleFormBlocEventSetSchedule(this.schedule);

  @override
  List<Object> get props => [schedule];
}

class FeedScheduleFormBlocEventCreate extends FeedScheduleFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedScheduleFormBlocState extends Equatable {
  final String schedule;
  final Map<String, dynamic> schedules;

  FeedScheduleFormBlocState(this.schedule, this.schedules);

  @override
  List<Object> get props => [schedule, schedules];
}

class FeedScheduleFormBlocStateDone extends FeedScheduleFormBlocState {
  FeedScheduleFormBlocStateDone(String schedule, Map<String, dynamic> schedules) : super(schedule, schedules);

  @override
  List<Object> get props => [];
}

class FeedScheduleFormBloc
    extends Bloc<FeedScheduleFormBlocEvent, FeedScheduleFormBlocState> {
  Device _device;

  String _schedule = '';
  Map<String, dynamic> _schedules = {};

  String _initialSchedule;
  Map<String, dynamic> _initialSchedules;

  final MainNavigateToFeedScheduleFormEvent _args;

  @override
  FeedScheduleFormBlocState get initialState => FeedScheduleFormBlocState(_schedule, _schedules);

  FeedScheduleFormBloc(this._args) {
    add(FeedScheduleFormBlocEventInit());
  }

  @override
  Stream<FeedScheduleFormBlocState> mapEventToState(
      FeedScheduleFormBlocEvent event) async* {
    if (event is FeedScheduleFormBlocEventInit) {
      final db = RelDB.get();
      _device = await db.devicesDAO.getDevice(_args.box.device);
      final Map<String, dynamic> settings = db.boxesDAO.boxSettings(_args.box);
      _initialSchedule = _schedule = settings['schedule'];
      _initialSchedules = _schedules = settings['schedules'];
      yield FeedScheduleFormBlocState(_schedule, _schedules);
    } else if (event is FeedScheduleFormBlocEventSetSchedule) {
      _schedule = event.schedule;
      yield FeedScheduleFormBlocState(_schedule, _schedules);
    } else if (event is FeedScheduleFormBlocEventCreate) {
      final db = RelDB.get();
      
      Param onHour = await db.devicesDAO.getParam(_device.id, 'BOX_${_args.box.deviceBox}_ON_HOUR');
      await DeviceHelper.updateIntParam(_device, onHour, _schedules[_schedule]['ON_HOUR']);
      Param offHour = await db.devicesDAO.getParam(_device.id, 'BOX_${_args.box.deviceBox}_OFF_HOUR');
      await DeviceHelper.updateIntParam(_device, offHour, _schedules[_schedule]['OFF_HOUR']);

      final Map<String, dynamic> settings = db.boxesDAO.boxSettings(_args.box);
      settings['schedule'] = _schedule;
      settings['schedules'] = _schedules;
      await db.boxesDAO.updateBox(_args.box.id, BoxesCompanion(settings: Value(JsonEncoder().convert(settings))));

      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_SCHEDULE',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({
          'initialSchedule': _initialSchedule,
          'initialSchedules': _initialSchedules,
          'schedule': _schedule,
          'schedules': _schedules,
        })),
      ));
      yield FeedScheduleFormBlocStateDone(_schedule, _schedules);
    }
  }
}
