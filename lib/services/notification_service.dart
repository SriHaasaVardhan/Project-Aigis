import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'emergency_channel',
          channelName: 'Emergency Alerts',
          channelDescription: 'Notifications for emergency situations',
          defaultColor: const Color(0xFFE91E63),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'health_channel',
          channelName: 'Health Monitoring',
          channelDescription: 'Health monitoring alerts and updates',
          defaultColor: const Color(0xFF2196F3),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'reminder_channel',
          channelName: 'Reminders',
          channelDescription: 'Medicine and appointment reminders',
          defaultColor: const Color(0xFF4CAF50),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
    );
  }

  Future<void> showEmergencyNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'emergency_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        category: NotificationCategory.Alarm,
        showWhen: true,
        autoDismissible: false,
        backgroundColor: const Color(0xFFE91E63),
      ),
    );
  }

  Future<void> showHealthNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'health_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        showWhen: true,
        backgroundColor: const Color(0xFF2196F3),
      ),
    );
  }

  Future<void> showReminderNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: 'reminder_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        showWhen: true,
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
