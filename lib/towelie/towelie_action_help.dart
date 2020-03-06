import 'package:super_green_app/towelie/towelie_action.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

abstract class TowelieActionHelp extends TowelieAction {
  String get route;

  Stream<TowelieBlocState> trigger(TowelieBlocEventRoute event);

  @override
  Stream<TowelieBlocState> eventReceived(TowelieBlocEvent event) async* {
    if (event is TowelieBlocEventRoute && event.settings.name == route) {
      yield* trigger(event);
    } else if (event is TowelieBlocEventRoutePop &&
        event.settings.name == route) {
      yield TowelieBlocStateHelperPop(event.settings);
    }
  }
}
