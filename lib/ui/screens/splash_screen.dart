import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_guardian/ui/screens/login_screen.dart';
import 'package:health_guardian/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0)),
    );
    _controller.forward();
    _navigateToNext();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final authProvider = context.read<AuthProvider>();
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
              Color(0xFFE91E63),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: 140.w,
                      height: 140.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(35.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE91E63).withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shield,
                        size: 80.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        Text(
                          'AIGIS',
                          style: TextStyle(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Your AI-Powered Health Shield',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white60,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60.h),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
