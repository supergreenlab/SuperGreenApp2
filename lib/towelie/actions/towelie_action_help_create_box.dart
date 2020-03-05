import 'package:super_green_app/towelie/actions/towelie_action.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionHelpCreateBox extends TowelieAction {
  @override
  Stream<TowelieBlocState> eventReceived(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventRoute && event.settings.name == '/box/new') {
      yield TowelieBlocStateHelper(event.settings, 'Lol de ouf');
    }
  }
}