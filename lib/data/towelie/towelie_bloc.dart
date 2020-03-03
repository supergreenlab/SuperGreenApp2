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
      Feed feed = await fdb.getFeed(event.box.feed);
      await _boxCreatedCard(feed);
      yield TowelieBlocStateHomeNavigation(
          HomeNavigateToBoxFeedEvent(event.box));
    } else if (event is TowelieBlocEventCardButton) {
      if (event.params['ID'] == 'NO_SGL_BUNDLE') {
        await _noSGLBundleCard(event.feed);
      } else if (event.params['ID'] == 'GOT_SGL_BUNDLE') {
        await _gotSGLBundleCard(event.feed);
      } else if (event.params['ID'] == 'YES_RECEIVED') {
      } else if (event.params['ID'] == 'NOT_RECEIVED_YET') {
        launch('https://www.supergreenlab.com/discord');
      } else if (event.params['ID'] == 'I_WANT_ONE') {
        launch('https://www.supergreenlab.com');
      } else if (event.params['ID'] == 'I_ORDERED_ONE') {
        await _gotSGLBundleCard(event.feed);
      } else if (event.params['ID'] == 'NO_THANKS') {
      } else if (event.params['ID'] == 'CREATE_BOX') {
        yield TowelieBlocStateMainNavigation(MainNavigateToNewBoxInfosEvent());
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
        'top_pic': 'assets/feed_card/logo_sgl.svg',
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
        'top_pic': 'assets/feed_card/logo_sgl.svg',
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
        'top_pic': 'assets/feed_card/logo_sgl.svg',
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

  _boxCreatedCard(Feed feed) async {
    final fdb = RelDB.get().feedsDAO;
    await fdb.addFeedEntry(FeedEntriesCompanion.insert(
      type: 'FE_TOWELIE_INFO',
      feed: feed.id,
      date: DateTime.now(),
      params: Value(JsonEncoder().convert({
        'text': SGLLocalizations.current.towelieWelcomeBox,
      })),
    ));
  }
}
