import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedScheduleFormBlocEvent extends Equatable {}

class FeedScheduleFormBlocEventInit extends FeedScheduleFormBlocEvent {
  @override
  List<Object> get props => [];
}

class FeedScheduleFormBlocEventCreate extends FeedScheduleFormBlocEvent {
  final String schedule;

  FeedScheduleFormBlocEventCreate(this.schedule);

  @override
  List<Object> get props => [schedule];
}

abstract class FeedScheduleFormBlocState extends Equatable {}

class FeedScheduleFormBlocStateIdle extends FeedScheduleFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedScheduleFormBlocStateData extends FeedScheduleFormBlocState {
  final String schedule;
  final Map<String, dynamic> schedules;

  FeedScheduleFormBlocStateData(this.schedule, this.schedules);

  @override
  List<Object> get props => [];
}

class FeedScheduleFormBlocStateDone extends FeedScheduleFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedScheduleFormBloc
    extends Bloc<FeedScheduleFormBlocEvent, FeedScheduleFormBlocState> {
  final MainNavigateToFeedScheduleFormEvent _args;

  @override
  FeedScheduleFormBlocState get initialState => FeedScheduleFormBlocStateIdle();

  FeedScheduleFormBloc(this._args) {
    add(FeedScheduleFormBlocEventInit());
  }

  @override
  Stream<FeedScheduleFormBlocState> mapEventToState(
      FeedScheduleFormBlocEvent event) async* {
    if (event is FeedScheduleFormBlocEventInit) {
      final db = RelDB.get();
      final Map<String, dynamic> settings = db.boxesDAO.boxSettings(_args.box);
      yield FeedScheduleFormBlocStateData(settings['schedule'], settings['schedules']);
    } else if (event is FeedScheduleFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_SCHEDULE',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({})),
      ));
      yield FeedScheduleFormBlocStateDone();
    }
  }
}
