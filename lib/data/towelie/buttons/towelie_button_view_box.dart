import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/data/towelie/buttons/towelie_button.dart';
import 'package:super_green_app/data/towelie/towelie_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';

class TowelieButtonViewBox extends TowelieButton {
  static Map<String, dynamic> createBox(Box box) => {
        'ID': 'VIEW_BOX',
        'title': 'View box',
        'boxID': box.id,
      };

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'VIEW_BOX') {
      final bdb = RelDB.get().boxesDAO;
      Box box = await bdb.getBox(event.params['boxID']);
      yield TowelieBlocStateHomeNavigation(HomeNavigateToBoxFeedEvent(box));
    }
  }
}
