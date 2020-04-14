import 'package:super_green_app/local_notification/local_notification.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_button.dart';

const _id = 'REMINDER';

class TowelieButtonReminder extends TowelieButton {
  @override
  String get id => _id;

  static Map<String, dynamic> createButton(
          String title,
          int notificationID,
          String notificationTitle,
          String notificationBody,
          String notificationPayload,
          int afterMinutes) =>
      TowelieButton.createButton(_id, {
        'title': title,
        'notificationID': notificationID,
        'notificationTitle': notificationTitle,
        'notificationBody': notificationBody,
        'notificationPayload': notificationPayload,
        'afterMinutes': afterMinutes,
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    yield TowelieBlocStateLocalNotification(LocalNotificationBlocEventReminder(
        event.params['notificationID'],
        event.params['afterMinutes'],
        event.params['notificationTitle'],
        event.params['notificationBody'],
        event.params['notificationPayload']));
    if (event.feedEntry != null) {
      await removeButtons(event.feedEntry,
          selector: (params) =>
              params['afterMinutes'] == event.params['afterMinutes']);
    }
  }
}
