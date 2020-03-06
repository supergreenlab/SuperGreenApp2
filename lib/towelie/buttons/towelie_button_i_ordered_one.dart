
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_cards_factory.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieButtonIOrderedOne extends TowelieButton {
  static Map<String, dynamic> createButton() {
    return {
      'ID': 'I_ORDERED_ONE',
      'title': 'I ordered one!',
    };
  }

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'I_ORDERED_ONE') {
      await TowelieCardsFactory.createGotSGLBundleCard(event.feed);
      await removeButtons(event.feedEntry);
    }
  }
}
