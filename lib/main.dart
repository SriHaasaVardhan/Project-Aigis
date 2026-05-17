import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/core/app.dart';
import 'package:health_guardian/providers/emergency_provider.dart';
import 'package:health_guardian/providers/health_monitor_provider.dart';
import 'package:health_guardian/providers/settings_provider.dart';
import 'package:health_guardian/providers/auth_provider.dart';
import 'package:health_guardian/providers/medicine_provider.dart';
import 'package:health_guardian/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize services
  await NotificationService().initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
        ChangeNotifierProvider(create: (_) => HealthMonitorProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
      ],
      child: const AigisApp(),
    ),
  );
}
