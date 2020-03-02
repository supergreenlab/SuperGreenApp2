import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';

abstract class TowelieBlocEvent extends Equatable {}

class TowelieBlocEventAppInit extends TowelieBlocEvent {
  TowelieBlocEventAppInit();

  @override
  List<Object> get props => [];
}

class TowelieBlocEventBoxCreated extends TowelieBlocEvent {
  final Box box;

  TowelieBlocEventBoxCreated(this.box);

  @override
  List<Object> get props => [box];
}

class TowelieBlocEventCardButton extends TowelieBlocEvent {
  final Map<String, dynamic> params;

  TowelieBlocEventCardButton(this.params);

  @override
  List<Object> get props => [params];
}

class TowelieBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class TowelieBloc extends Bloc<TowelieBlocEvent, TowelieBlocState> {
  @override
  TowelieBlocState get initialState => TowelieBlocState();

  @override
  Stream<TowelieBlocState> mapEventToState(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventAppInit) {
      final fdb = RelDB.get().feedsDAO;
      int feed =
          await fdb.addFeed(FeedsCompanion(name: Value("SuperGreenLab")));
      await fdb.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_TOWELIE_INFO',
        feed: feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({
          'text': SGLLocalizations.current.towelieWelcomeApp,
          'top_pic': 'assets/feed_card/logo_sgl.svg',
          'buttons': [
            {
              'ID': 'CREATE_BOX',
              'type': 'CREATE_BOX',
              'title': 'CREATE FIRST BOX',
            }
          ],
        })),
      ));
    } else if (event is TowelieBlocEventBoxCreated) {
      final fdb = RelDB.get().feedsDAO;
      await fdb.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_TOWELIE_INFO',
        feed: event.box.feed,
        date: DateTime.now(),
        params: Value(JsonEncoder().convert({
          'text': SGLLocalizations.current.towelieWelcomeBox,
        })),
      ));
    } else if (event is TowelieBlocEventCardButton) {}
  }
}
