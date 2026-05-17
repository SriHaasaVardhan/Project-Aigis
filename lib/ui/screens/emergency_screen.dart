import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_guardian/services/emergency_actions_data.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});
  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String _search = '';
  String _selectedCategory = 'All';

  List<String> get _categories {
    final cats = emergencyActions.map((e) => e.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  List<EmergencyAction> get _filtered {
    var list = emergencyActions;
    if (_selectedCategory != 'All') list = list.where((e) => e.category == _selectedCategory).toList();
    if (_search.isNotEmpty) list = list.where((e) => e.name.toLowerCase().contains(_search.toLowerCase())).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Actions'), backgroundColor: Colors.red),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(hintText: 'Search emergencies...', prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
            ),
          ),
          SizedBox(
            height: 36.h,
            child: ListView(scrollDirection: Axis.horizontal, padding: EdgeInsets.symmetric(horizontal: 12.w), children: _categories.map((c) =>
              Padding(padding: EdgeInsets.only(right: 6.w), child: ChoiceChip(
                label: Text(c, style: TextStyle(fontSize: 11.sp)),
                selected: _selectedCategory == c,
                onSelected: (_) => setState(() => _selectedCategory = c),
                selectedColor: Colors.red.withOpacity(0.2),
              )),
            ).toList()),
          ),
          SizedBox(height: 8.h),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text('${_filtered.length} emergency scenarios', style: TextStyle(fontSize: 12.sp, color: Colors.grey))),
          SizedBox(height: 4.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final a = _filtered[i];
                return Card(
                  margin: EdgeInsets.only(bottom: 8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: ListTile(
                    leading: Text(a.icon, style: TextStyle(fontSize: 24.sp)),
                    title: Text(a.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
                    subtitle: Text(a.category, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showSteps(ctx, a),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  void _showSteps(BuildContext context, EmergencyAction action) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.4, expand: false,
        builder: (ctx, scrollC) => Padding(
          padding: EdgeInsets.all(20.w),
          child: ListView(controller: scrollC, children: [
            Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.r)))),
            SizedBox(height: 16.h),
            Row(children: [
              Text(action.icon, style: TextStyle(fontSize: 32.sp)),
              SizedBox(width: 12.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(action.name, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                Text(action.category, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ])),
            ]),
            SizedBox(height: 20.h),
            Text('Immediate Actions:', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.red)),
            SizedBox(height: 12.h),
            ...action.steps.asMap().entries.map((e) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 28.w, height: 28.w,
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                  child: Center(child: Text('${e.key + 1}', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.red))),
                ),
                SizedBox(width: 12.w),
                Expanded(child: Text(e.value, style: TextStyle(fontSize: 14.sp, height: 1.4))),
              ]),
            )),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.red.withOpacity(0.2))),
              child: Row(children: [
                Icon(Icons.warning, color: Colors.red, size: 20.sp),
                SizedBox(width: 8.w),
                Expanded(child: Text('Always call emergency services (108) for serious situations', style: TextStyle(fontSize: 12.sp, color: Colors.red[700]))),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
