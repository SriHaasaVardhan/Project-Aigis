import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FamilyDashboardScreen extends StatefulWidget {
  const FamilyDashboardScreen({super.key});
  @override
  State<FamilyDashboardScreen> createState() => _FamilyDashboardScreenState();
}

class _FamilyDashboardScreenState extends State<FamilyDashboardScreen> {
  final List<Map<String, dynamic>> _familyMembers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Dashboard')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMemberDialog(context),
        child: const Icon(Icons.person_add),
      ),
      body: SafeArea(
        child: _familyMembers.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.family_restroom, size: 70.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text('No Family Members', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.grey)),
                SizedBox(height: 8.h),
                Text('Add family members to monitor their health', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                SizedBox(height: 24.h),
                ElevatedButton.icon(onPressed: () => _showAddMemberDialog(context), icon: const Icon(Icons.person_add), label: const Text('Add Member')),
              ]))
            : ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  Text('Family Members', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text('Monitor health of your loved ones', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                  SizedBox(height: 20.h),
                  ..._familyMembers.asMap().entries.map((e) => _MemberCard(
                    member: e.value,
                    onDelete: () => setState(() => _familyMembers.removeAt(e.key)),
                  )),
                ],
              ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final nameC = TextEditingController();
    final relC = TextEditingController();
    final phoneC = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20.w, right: 20.w, top: 20.h),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Add Family Member', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),
          TextField(controller: nameC, decoration: InputDecoration(labelText: 'Name', prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
          SizedBox(height: 12.h),
          TextField(controller: relC, decoration: InputDecoration(labelText: 'Relationship', prefixIcon: const Icon(Icons.family_restroom), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
          SizedBox(height: 12.h),
          TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Phone', prefixIcon: const Icon(Icons.phone), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
          SizedBox(height: 16.h),
          SizedBox(width: double.infinity, height: 48.h, child: ElevatedButton(
            onPressed: () {
              if (nameC.text.isNotEmpty && relC.text.isNotEmpty) {
                setState(() => _familyMembers.add({'name': nameC.text, 'relationship': relC.text, 'phone': phoneC.text, 'status': 'Normal', 'lastUpdate': 'Just now'}));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add Member'),
          )),
          SizedBox(height: 20.h),
        ]),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback onDelete;
  const _MemberCard({required this.member, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(children: [
          CircleAvatar(backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1), child: Icon(Icons.person, color: Theme.of(context).primaryColor)),
          SizedBox(width: 12.w),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(member['name'] ?? '', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            Text(member['relationship'] ?? '', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
          ])),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12.r)),
            child: Text(member['status'] ?? 'Normal', style: TextStyle(fontSize: 11.sp, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          IconButton(icon: Icon(Icons.delete, color: Colors.red[300], size: 20), onPressed: onDelete),
        ]),
      ),
    );
  }
}
