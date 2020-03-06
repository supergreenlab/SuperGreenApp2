
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_cards_factory.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieButtonYesReceived extends TowelieButton {
  static Map<String, dynamic> createButton() {
    return {
      'ID': 'YES_RECEIVED',
      'title': 'Yes',
    };
  }

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'YES_RECEIVED') {
      await TowelieCardsFactory.createCreateBoxCard(event.feed);
      await removeButtons(event.feedEntry);
    }
  }
}
