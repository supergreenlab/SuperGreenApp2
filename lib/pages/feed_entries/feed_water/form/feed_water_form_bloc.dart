import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedWaterFormBlocEvent extends Equatable {}

class FeedWaterFormBlocEventCreate extends FeedWaterFormBlocEvent {
  final bool tooDry;
  final double volume;
  final bool nutrient;

  FeedWaterFormBlocEventCreate(this.tooDry, this.volume, this.nutrient);

  @override
  List<Object> get props => [tooDry, volume, nutrient];
}

class FeedWaterFormBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeedWaterFormBlocStateDone extends FeedWaterFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedWaterFormBloc
    extends Bloc<FeedWaterFormBlocEvent, FeedWaterFormBlocState> {
  final MainNavigateToFeedWaterFormEvent _args;

  @override
  FeedWaterFormBlocState get initialState => FeedWaterFormBlocState();

  FeedWaterFormBloc(this._args);

  @override
  Stream<FeedWaterFormBlocState> mapEventToState(
      FeedWaterFormBlocEvent event) async* {
    if (event is FeedWaterFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_WATER',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({
          'tooDry': event.tooDry,
          'volume': event.volume,
          'nutrient': event.nutrient,
        })),
      ));
      yield FeedWaterFormBlocStateDone();
    }
  }
}
