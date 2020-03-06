
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/towelie/towelie_action.dart';
import 'package:super_green_app/towelie/towelie_cards_factory.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionAppInit extends TowelieAction {
  @override
  Stream<TowelieBlocState> eventReceived(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventAppInit) {
      final fdb = RelDB.get().feedsDAO;
      int feedID =
          await fdb.addFeed(FeedsCompanion(name: Value("SuperGreenLab")));
      Feed feed = await fdb.getFeed(feedID);
      await TowelieCardsFactory.createWelcomeAppCard(feed);
    }
  }
}
