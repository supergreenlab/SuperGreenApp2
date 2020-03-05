import 'package:super_green_app/data/towelie/buttons/towelie_button.dart';
import 'package:super_green_app/data/towelie/towelie_bloc.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

class TowelieButtonCreateBox extends TowelieButton {
  static Map<String, dynamic> createButton() {
    return {
      'ID': 'CREATE_BOX',
      'title': 'Create box',
    };
  }

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventCardButtonPressed event) async* {
    if (event.params['ID'] == 'CREATE_BOX') {
      yield TowelieBlocStateMainNavigation(MainNavigateToNewBoxInfosEvent());
    }
  }
}
