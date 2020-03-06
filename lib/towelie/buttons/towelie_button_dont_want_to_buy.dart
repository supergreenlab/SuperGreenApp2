
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_cards_factory.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieButtonDontWantToBuy extends TowelieButton {
  static Map<String, dynamic> createButton() {
    return {
      'ID': 'NO_THANKS',
      'title': 'No, thanks.',
    };
  }

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'NO_THANKS') {
      await TowelieCardsFactory.createCreateBoxCard(event.feed);
      await removeButtons(event.feedEntry);
    }
  }
}
