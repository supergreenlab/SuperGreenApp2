import 'package:super_green_app/towelie/buttons/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class TowelieButtonIWantOne extends TowelieButton {
  static Map<String, dynamic> createButton() {
    return {
      'ID': 'I_WANT_ONE',
      'title': 'I want one!',
    };
  }

  @override
  Stream<TowelieBlocState> buttonPressed(TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'I_WANT_ONE') {
      launch('https://www.supergreenlab.com');
    }
  }
}
