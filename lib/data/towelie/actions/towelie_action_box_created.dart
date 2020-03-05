
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/data/towelie/actions/towelie_action.dart';
import 'package:super_green_app/data/towelie/cards/towelie_cards_factory.dart';
import 'package:super_green_app/data/towelie/towelie_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';

class TowelieActionBoxCreated extends TowelieAction {
  @override
  Stream<TowelieBlocState> eventReceived(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventBoxCreated) {
      final fdb = RelDB.get().feedsDAO;
      final bdb = RelDB.get().boxesDAO;
      Feed feed = await fdb.getFeed(event.box.feed);
      await TowelieCardsFactory.createWelcomeBoxCard(feed);
      int nBoxes = await bdb.nBoxes().getSingle();
      if (nBoxes == 1) {
        Feed sglFeed = await fdb.getFeed(1);
        await TowelieCardsFactory.createBoxCreatedCard(sglFeed, event.box);
      }
      yield TowelieBlocStateHomeNavigation(
          HomeNavigateToBoxFeedEvent(event.box));
    }
  }
}
