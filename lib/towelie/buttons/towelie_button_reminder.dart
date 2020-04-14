import 'package:super_green_app/local_notification/local_notification.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_button.dart';

const _id = 'REMINDER';

abstract class TowelieButtonReminder extends TowelieButton {
  @override
  String get id => _id;

  static Map<String, dynamic> createButton(
          String title,
          String notificationID,
          String notificationTitle,
          String notificationBody,
          int afterMinutes) =>
      TowelieButton.createButton(_id, {
        'title': title,
        'notificationID': notificationID,
        'notificationTitle': notificationTitle,
        'notificationBody': notificationBody,
        'afterMinutes': afterMinutes,
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    yield TowelieBlocStateLocalNotification(LocalNotificationBlocEventReminder(
        event.params['notificationId'],
        event.params['afterMinutes'],
        event.params['notificationTitle'],
        event.params['notificationBody']));
    if (event.feedEntry != null) {
      await removeButtons(event.feedEntry,
          selector: (params) =>
              params['notificationID'] == event.params['notificationID']);
    }
  }
}
