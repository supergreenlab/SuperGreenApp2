import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';

abstract class BoxInfosBlocEvent extends Equatable {}

class BoxInfosBlocEventCreateBox extends BoxInfosBlocEvent {
  final String name;
  final Device device;
  final int deviceBox;
  BoxInfosBlocEventCreateBox(this.name, {this.device, this.deviceBox});

  @override
  List<Object> get props => [name, device, deviceBox];
}

class BoxInfosBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class BoxInfosBlocStateDone extends BoxInfosBlocState {
  final Box box;
  final Device device;
  final int deviceBox;
  BoxInfosBlocStateDone(this.box, {this.device, this.deviceBox});

  @override
  List<Object> get props => [box, device, deviceBox];
}

class BoxInfosBloc extends Bloc<BoxInfosBlocEvent, BoxInfosBlocState> {
  @override
  BoxInfosBlocState get initialState => BoxInfosBlocState();

  @override
  Stream<BoxInfosBlocState> mapEventToState(BoxInfosBlocEvent event) async* {
    if (event is BoxInfosBlocEventCreateBox) {
      final bdb = RelDB.get().boxesDAO;
      final fdb = RelDB.get().feedsDAO;
      final feed = FeedsCompanion.insert(name: event.name);
      final feedID = await fdb.addFeed(feed);
      BoxesCompanion box;
      if (event.device == null || event.deviceBox == null) {
        box = BoxesCompanion.insert(feed: feedID, name: event.name);
      } else {
        box = BoxesCompanion.insert(
            feed: feedID,
            name: event.name,
            device: Value(event.device.id),
            deviceBox: Value(event.deviceBox));
      }
      await fdb.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_TOWELIE_INFO',
        feed: feedID,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({
          'text': SGLLocalizations.current.towelieWelcomeBox,
        })),
      ));
      final boxID = await bdb.addBox(box);
      final b = await bdb.getBox(boxID);
      yield BoxInfosBlocStateDone(b,
          device: event.device, deviceBox: event.deviceBox);
    }
  }
}
