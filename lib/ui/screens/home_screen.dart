import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/emergency_provider.dart';
import 'package:health_guardian/providers/health_monitor_provider.dart';
import 'package:health_guardian/providers/auth_provider.dart';
import 'package:health_guardian/ui/screens/emergency_screen.dart';
import 'package:health_guardian/ui/screens/health_monitor_screen.dart';
import 'package:health_guardian/ui/screens/settings_screen.dart';
import 'package:health_guardian/ui/screens/emergency_contacts_screen.dart';
import 'package:health_guardian/ui/screens/medicine_reminders_screen.dart';
import 'package:health_guardian/ui/screens/profile_screen.dart';
import 'package:health_guardian/ui/screens/family_dashboard_screen.dart';
import 'package:health_guardian/ui/screens/ai_chat_screen.dart';
import 'package:health_guardian/ui/screens/healthcare_support_screen.dart';
import 'package:health_guardian/ui/widgets/health_status_card.dart';
import 'package:health_guardian/ui/widgets/emergency_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const _DashboardScreen(),
    const HealthMonitorScreen(),
    const EmergencyContactsScreen(),
    const MedicineRemindersScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: KeyedSubtree(key: ValueKey(_currentIndex), child: _screens[_currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: 'Monitor'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Medicine'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class _DashboardScreen extends StatelessWidget {
  const _DashboardScreen();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Consumer2<EmergencyProvider, HealthMonitorProvider>(
      builder: (context, ep, hp, _) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Welcome Back${authProvider.currentUserName != null ? ", ${authProvider.currentUserName!.split(' ').first}" : ""}',
                          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 4.h),
                        Text('Your health is being monitored', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                      ]),
                    ),
                    IconButton(icon: const Icon(Icons.account_circle, size: 30), onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                    }),
                  ],
                ),
                SizedBox(height: 24.h),
                const EmergencyButton(),
                SizedBox(height: 24.h),
                const HealthStatusCard(),
                SizedBox(height: 20.h),
                Text('Quick Actions', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 12.h),
                GridView.count(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2, mainAxisSpacing: 12.h, crossAxisSpacing: 12.w, childAspectRatio: 1.3,
                  children: [
                    _QuickActionCard(icon: Icons.emergency, label: 'Emergency', color: Colors.red, onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyScreen()));
                    }),
                    _QuickActionCard(icon: Icons.local_hospital, label: 'Healthcare', color: Colors.green, onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthcareSupportScreen()));
                    }),
                    _QuickActionCard(icon: Icons.family_restroom, label: 'Family', color: Colors.purple, onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyDashboardScreen()));
                    }),
                    _QuickActionCard(icon: Icons.chat, label: 'AI Chat', color: Colors.orange, onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AiChatScreen()));
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _QuickActionCard({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.93),
      onTapUp: (_) { setState(() => _scale = 1.0); widget.onTap(); },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale, duration: const Duration(milliseconds: 150), curve: Curves.easeOutBack,
        child: Card(
          elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(color: widget.color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(widget.icon, size: 28.sp, color: widget.color),
            ),
            SizedBox(height: 8.h),
            Text(widget.label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}