import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_guardian/ui/screens/splash_screen.dart';
import 'package:health_guardian/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/settings_provider.dart';

class AigisApp extends StatelessWidget {
  const AigisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer<SettingsProvider>(
          builder: (context, settings, _) {
            return MaterialApp(
              title: 'AIGIS',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
