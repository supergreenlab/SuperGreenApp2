

import 'package:super_green_app/towelie/buttons/towelie_button.dart';
import 'package:super_green_app/towelie/cards/towelie_cards_factory.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieButtonGotSGLBundle extends TowelieButton {
  static Map<String, dynamic> createButton() {
    return {
      'ID': 'GOT_SGL_BUNDLE',
      'title': 'Yes I got one!',
    };
  }

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'GOT_SGL_BUNDLE') {
      await TowelieCardsFactory.createGotSGLBundleCard(event.feed);
      await removeButtons(event.feedEntry);
    }
  }
}
