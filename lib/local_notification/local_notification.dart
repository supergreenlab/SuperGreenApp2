import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static LocalNotification _instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory LocalNotification.get() {
    if (_instance == null) {
      _instance = LocalNotification();
    }
    return _instance;
  }

  LocalNotification();

  Future init() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print('onDidReceiveLocalNotification');
    if (payload != null) {
      print('notification payload: $id $title $body $payload');
    }
  }

  Future _onSelectNotification(String payload) async {
    print('onSelectNotification');
    if (payload != null) {
      print('notification payload: $payload');
    }
  }

  Future<bool> checkPermissions() async {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ?? true;
  }

  Future scheduleNotification(int afterMinutes) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(minutes: afterMinutes));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics, 
        androidAllowWhileIdle: true);
  }
}
