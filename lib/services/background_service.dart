import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  Future<void> initialize() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        autoStart: false,
        isForegroundMode: true,
        autoStartOnBoot: true,
        onStart: onStart,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Background monitoring logic
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      // Perform background health checks
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          service.setForegroundNotificationInfo(
            title: 'Health Guardian',
            content: 'Monitoring your health - ${DateTime.now().toString().substring(11, 19)}',
          );
        }
      }
      
      // Add background monitoring logic here
      // - Check health data
      // - Detect emergencies
      // - Send alerts if needed
    });
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  Future<void> startService() async {
    await FlutterBackgroundService().startService();
  }

  Future<void> stopService() async {
    FlutterBackgroundService().invoke('stopService');
  }

  Future<bool> isServiceRunning() async {
    return await FlutterBackgroundService().isRunning();
  }
}
