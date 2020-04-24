import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_button.dart';

const _id = 'PUSH_ROUTE';

class TowelieButtonPushRouteMeasure extends TowelieButton {
  @override
  String get id => _id;

  static Map<String, dynamic> createButton(String title, int plantID) =>
      TowelieButton.createButton(_id, {
        'title': title,
        'plantID': plantID,
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    int plantID = event.params['plantID'];
    Plant plant = await RelDB.get().plantsDAO.getPlant(plantID);
    yield TowelieBlocStateMainNavigation(
        MainNavigateToFeedMeasureFormEvent(plant));
    if (event.feedEntry != null) {
      await selectButtons(event.feedEntry, selectedButtonID: id);
    }
  }
}
