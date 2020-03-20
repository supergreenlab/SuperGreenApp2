import 'package:flutter/material.dart';
import 'package:super_green_app/local_notification/local_notification.dart';
import 'package:super_green_app/towelie/towelie_action_help.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

class TowelieActionHelpNotification extends TowelieActionHelp {

  static String id = 'NOTIFICATION';

  String get triggerID => id;

  Stream<TowelieBlocState> idTrigger(TowelieBlocEventTrigger event) async* {
    LocalNotificationBlocStateNotification parameters = event.parameters;
    yield TowelieBlocStateHelper(
        RouteSettings(name: event.currentRoute, arguments: null), parameters.body);
  }
}
