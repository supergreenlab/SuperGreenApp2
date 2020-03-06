
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_cards_factory.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieButtonNoSGLBundle extends TowelieButton {
  static Map<String, dynamic> createButton() {
    return {
      'ID': 'NO_SGL_BUNDLE',
      'title': 'No I don\'t.',
    };
  }

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'NO_SGL_BUNDLE') {
      await TowelieCardsFactory.createNoSGLBundleCard(event.feed);
      await removeButtons(event.feedEntry);
    }
  }
}
