import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final int rand = Random().nextInt(1 << 32);
  final Map<String, dynamic> params;
  final Feed feed;
  final FeedEntry feedEntry;

  TowelieBlocEventCardButton(this.params, this.feed, this.feedEntry);

  @override
  List<Object> get props => [rand, params, feed, feedEntry];
}

class TowelieBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class TowelieBlocStateMainNavigation extends TowelieBlocState {
  final int rand = Random().nextInt(1 << 32);
  final MainNavigatorEvent mainNavigatorEvent;

  TowelieBlocStateMainNavigation(this.mainNavigatorEvent);

  @override
  List<Object> get props => [rand, mainNavigatorEvent];
}

class TowelieBlocStateHomeNavigation extends TowelieBlocState {
  final int rand = Random().nextInt(1 << 32);
  final HomeNavigatorEvent homeNavigatorEvent;

  TowelieBlocStateHomeNavigation(this.homeNavigatorEvent);

  @override
  List<Object> get props => [rand, homeNavigatorEvent];
}

class TowelieBloc extends Bloc<TowelieBlocEvent, TowelieBlocState> {
  @override
  TowelieBlocState get initialState => TowelieBlocState();

  @override
  Stream<TowelieBlocState> mapEventToState(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventAppInit) {
      final fdb = RelDB.get().feedsDAO;
      int feedID =
          await fdb.addFeed(FeedsCompanion(name: Value("SuperGreenLab")));
      Feed feed = await fdb.getFeed(feedID);
      await _welcomeAppCard(feed);
    } else if (event is TowelieBlocEventBoxCreated) {
      final fdb = RelDB.get().feedsDAO;
      final bdb = RelDB.get().boxesDAO;
      Feed feed = await fdb.getFeed(event.box.feed);
      _welcomeBoxCard(feed);
      int nBoxes = await bdb.nBoxes().getSingle();
      if (nBoxes == 1) {
        Feed sglFeed = await fdb.getFeed(1);
        await _boxCreatedCard(sglFeed, event.box);
      }
      yield TowelieBlocStateHomeNavigation(
          HomeNavigateToBoxFeedEvent(event.box));
    } else if (event is TowelieBlocEventCardButton) {
      if (event.params['ID'] == 'NO_SGL_BUNDLE') {
        await _noSGLBundleCard(event.feed);
        await _removeButtons(event.feedEntry);
      } else if (event.params['ID'] == 'GOT_SGL_BUNDLE') {
        await _gotSGLBundleCard(event.feed);
        await _removeButtons(event.feedEntry);
      } else if (event.params['ID'] == 'YES_RECEIVED') {
        await _createBoxCard(event.feed);
        await _removeButtons(event.feedEntry);
      } else if (event.params['ID'] == 'NOT_RECEIVED_YET') {
        launch('https://www.supergreenlab.com/discord');
      } else if (event.params['ID'] == 'I_WANT_ONE') {
        launch('https://www.supergreenlab.com');
      } else if (event.params['ID'] == 'I_ORDERED_ONE') {
        await _gotSGLBundleCard(event.feed);
        await _removeButtons(event.feedEntry);
      } else if (event.params['ID'] == 'NO_THANKS') {
      } else if (event.params['ID'] == 'CREATE_BOX') {
        yield TowelieBlocStateMainNavigation(MainNavigateToNewBoxInfosEvent());
      } else if (event.params['ID'] == 'VIEW_BOX') {
        final bdb = RelDB.get().boxesDAO;
        Box box = await bdb.getBox(event.params['boxID']);
        yield TowelieBlocStateHomeNavigation(
            HomeNavigateToBoxFeedEvent(box));
      }
    }
  }

  _welcomeAppCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeApp,
        'buttons': [
          {
            'ID': 'GOT_SGL_BUNDLE',
            'title': 'Yes I got one!',
          },
          {
            'ID': 'NO_SGL_BUNDLE',
            'title': 'No I don\'t.',
          },
        ],
      })),
    ));
  }

  _noSGLBundleCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeAppNoBundle,
        'buttons': [
          {
            'ID': 'I_WANT_ONE',
            'title': 'I want one!',
          },
          {
            'ID': 'I_ORDERED_ONE',
            'title': 'I ordered one!',
          },
          {
            'ID': 'NO_THANKS',
            'title': 'No, thanks.',
          },
        ],
      })),
    ));
  }

  _gotSGLBundleCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeAppHasBundle,
        'buttons': [
          {
            'ID': 'YES_RECEIVED',
            'title': 'Yes',
          },
          {
            'ID': 'NOT_RECEIVED_YET',
            'title': 'No',
          },
        ],
      })),
    ));
  }

  _createBoxCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieCreateBox,
        'buttons': [
          {
            'ID': 'CREATE_BOX',
            'title': 'Create box',
          },
        ],
      })),
    ));
  }

  _boxCreatedCard(Feed feed, Box box) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieBoxCreated,
        'buttons': [
          {
            'ID': 'VIEW_BOX',
            'title': 'View box',
            'boxID': box.id,
          },
        ]
      })),
    ));
  }

  _welcomeBoxCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeBox,
        'buttons': [
        ],
      })),
    ));
  }

  _removeButtons(FeedEntry feedEntry) async {
    final fdb = RelDB.get().feedsDAO;
    final Map<String, dynamic> params = JsonDecoder().convert(feedEntry.params);
    params['buttons'] = [];
    await fdb.updateFeedEntry(feedEntry
        .createCompanion(true)
        .copyWith(params: Value(JsonEncoder().convert(params))));
  }
}
