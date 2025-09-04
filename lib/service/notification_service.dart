import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final notifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return; // prevent khởi tạo lần nữa

    //Prepare android init setting
    const AndroidInitializationSettings initSetupAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initSetupIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: initSetupAndroid,
      iOS: initSetupIOS,
    );

    await notifications.initialize(initSettings);
    _isInitialized = true;
  }

  //Notification Details Setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Show Notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await notifications.show(
      id,
      title,
      body,
      notificationDetails(),
      payload: payload,
    );
  }

  // ON NOTI TAP
}
