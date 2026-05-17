import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final auth = context.read<AuthProvider>();
    final profile = await auth.getCurrentUserProfile();
    if (mounted) setState(() { _profile = profile; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(children: [
                  Center(child: Column(children: [
                    Container(
                      width: 90.w, height: 90.w,
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Icons.person, size: 45.sp, color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: 12.h),
                    Text(auth.currentUserName ?? 'User', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    Text(auth.currentUserEmail ?? '', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                  ])),
                  SizedBox(height: 24.h),
                  _Section(title: 'Personal Info', icon: Icons.person, children: [
                    _Info(label: 'Phone', value: _profile?['phone'] ?? 'Not set'),
                    _Info(label: 'Date of Birth', value: _profile?['date_of_birth'] ?? 'Not set'),
                    _Info(label: 'Gender', value: _profile?['gender'] ?? 'Not set'),
                    _Info(label: 'Height', value: _profile?['height'] ?? 'Not set'),
                    _Info(label: 'Weight', value: _profile?['weight'] ?? 'Not set'),
                    _Info(label: 'Bio', value: _profile?['bio'] ?? 'Not set'),
                  ]),
                  SizedBox(height: 12.h),
                  _Section(title: 'Medical Info', icon: Icons.medical_services, children: [
                    _Info(label: 'Blood Type', value: _profile?['blood_type'] ?? 'Not set'),
                    _Info(label: 'Allergies', value: _profile?['allergies']?.toString().isNotEmpty == true ? _profile!['allergies'] : 'None'),
                    _Info(label: 'Conditions', value: _profile?['medical_conditions']?.toString().isNotEmpty == true ? _profile!['medical_conditions'] : 'None'),
                    _Info(label: 'Medications', value: _profile?['current_medications']?.toString().isNotEmpty == true ? _profile!['current_medications'] : 'None'),
                  ]),
                  SizedBox(height: 12.h),
                  _Section(title: 'Emergency Contact', icon: Icons.contact_phone, children: [
                    _Info(label: 'Name', value: _profile?['emergency_contact_name'] ?? 'Not set'),
                    _Info(label: 'Phone', value: _profile?['emergency_contact_phone'] ?? 'Not set'),
                    _Info(label: 'Relationship', value: _profile?['emergency_contact_relationship'] ?? 'Not set'),
                  ]),
                  SizedBox(height: 24.h),
                  SizedBox(width: double.infinity, child: OutlinedButton.icon(
                    onPressed: () async {
                      await auth.logout();
                      if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Logout', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                  )),
                ]),
              ),
            ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _Section({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 20.sp),
            SizedBox(width: 8.w),
            Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ]),
          SizedBox(height: 10.h),
          ...children,
        ]),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label, value;
  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
        Flexible(child: Text(value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500), textAlign: TextAlign.end, overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
