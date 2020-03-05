import 'package:super_green_app/towelie/buttons/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class TowelieButtonNotReceived extends TowelieButton {
  static Map<String, dynamic> createButton() {
    return {
      'ID': 'NOT_RECEIVED_YET',
      'title': 'No',
    };
  }

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'NOT_RECEIVED_YET') {
      launch('https://www.supergreenlab.com/discord');
    }
  }
}
