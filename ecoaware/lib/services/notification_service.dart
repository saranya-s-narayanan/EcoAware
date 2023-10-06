/** class to accomodate methods related to setting up
 * and cancel notifications from the app
 */
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /** Method to initialize the notification service elements
   */
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  /** Method to turn the notification setting ON to continue
   * receiving push notification from the app
   */
  Future<void> turnOnNotifications() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'hourly_notification_channel',
      'Hourly Notification Channel',
      icon: "@mipmap/ic_launcher",
      channelDescription: 'Channel for Hourly Notifications',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0, // Notification ID
      'EcoAware',
      'Carbon footprint calculator reminder!',
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  /** Method to stop receiving push notifications from the app
   */
  Future<void> cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}