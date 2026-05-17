import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/emergency_provider.dart';

class EmergencyButton extends StatefulWidget {
  const EmergencyButton({super.key});
  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseC;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseC = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(CurvedAnimation(parent: _pulseC, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulseC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyProvider>(
      builder: (context, ep, _) {
        return AnimatedBuilder(
          animation: _pulseAnim,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnim.value,
              child: GestureDetector(
                onTap: () => ep.requestHelp(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.red, Colors.redAccent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50.w, height: 50.w,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, spreadRadius: 1)]),
                        child: Icon(Icons.sos, size: 28.sp, color: Colors.red),
                      ),
                      SizedBox(height: 8.h),
                      Text('EMERGENCY SOS', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                      SizedBox(height: 3.h),
                      Text('Tap to request immediate help', style: TextStyle(fontSize: 12.sp, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
