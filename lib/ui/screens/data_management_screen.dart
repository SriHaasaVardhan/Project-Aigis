import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataManagementScreen extends StatelessWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            Text(
              'Manage Your Data',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'View, export, or delete the health data we have collected.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30.h),
            
            _DataTile(
              title: 'Export Health Data',
              subtitle: 'Download a copy of your health records.',
              icon: Icons.download,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting data...')),
                );
              },
            ),
            _DataTile(
              title: 'Clear Local Cache',
              subtitle: 'Free up space by deleting local cache.',
              icon: Icons.cleaning_services,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared.')),
                );
              },
            ),
            _DataTile(
              title: 'Delete History',
              subtitle: 'Permanently remove your health history.',
              icon: Icons.delete_sweep,
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('History deleted.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DataTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _DataTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
