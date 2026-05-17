import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/medicine_provider.dart';
import 'package:health_guardian/providers/auth_provider.dart';

class MedicineRemindersScreen extends StatefulWidget {
  const MedicineRemindersScreen({super.key});
  @override
  State<MedicineRemindersScreen> createState() => _MedicineRemindersScreenState();
}

class _MedicineRemindersScreenState extends State<MedicineRemindersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.currentUserId != null) {
        context.read<MedicineProvider>().setUserId(auth.currentUserId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicineProvider>(
      builder: (context, mp, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Medicine Reminders')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDialog(context, mp),
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: mp.reminders.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.medication_outlined, size: 70.sp, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text('No Medicine Reminders', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.grey)),
                    SizedBox(height: 8.h),
                    Text('Tap + to add a reminder', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                  ]))
                : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: mp.reminders.length,
                    itemBuilder: (context, index) {
                      final r = mp.reminders[index];
                      final isActive = (r['is_active'] as int?) == 1;
                      return Dismissible(
                        key: Key(r['id'].toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 20.w),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12.r)),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => mp.deleteReminder(r['id'].toString()),
                        child: Card(
                          margin: EdgeInsets.only(bottom: 10.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            leading: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: isActive ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.medication, color: isActive ? Theme.of(context).primaryColor : Colors.grey),
                            ),
                            title: Text(r['medicine_name']?.toString() ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp,
                              decoration: isActive ? null : TextDecoration.lineThrough)),
                            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Dosage: ${r['dosage'] ?? ''}', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                              if (r['frequency'] != null) Text('Frequency: ${r['frequency']}', style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                              if (r['notes'] != null && r['notes'].toString().isNotEmpty)
                                Text('Note: ${r['notes']}', style: TextStyle(fontSize: 11.sp, color: Colors.grey[500])),
                            ]),
                            trailing: Switch(
                              value: isActive,
                              onChanged: (val) => mp.toggleReminder(r['id'].toString(), val),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, MedicineProvider mp) {
    final nameC = TextEditingController();
    final dosageC = TextEditingController();
    final notesC = TextEditingController();
    String frequency = 'Daily';
    final selectedHours = <int>{8};
    final selectedDays = <int>{1, 2, 3, 4, 5, 6, 7};
    final frequencies = ['Once daily', 'Twice daily', 'Three times daily', 'Weekly', 'As needed', 'Daily'];
    final timeLabels = {6: '6 AM', 8: '8 AM', 10: '10 AM', 12: '12 PM', 14: '2 PM', 16: '4 PM', 18: '6 PM', 20: '8 PM', 22: '10 PM'};
    final dayLabels = {1: 'Mon', 2: 'Tue', 3: 'Wed', 4: 'Thu', 5: 'Fri', 6: 'Sat', 7: 'Sun'};

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20.w, right: 20.w, top: 20.h),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.r)))),
            SizedBox(height: 16.h),
            Text('Add Medicine', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            TextField(controller: nameC, decoration: InputDecoration(labelText: 'Medicine Name *', prefixIcon: const Icon(Icons.medication), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
            SizedBox(height: 12.h),
            TextField(controller: dosageC, decoration: InputDecoration(labelText: 'Dosage (e.g., 500mg) *', prefixIcon: const Icon(Icons.science), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              value: frequency,
              items: frequencies.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (v) => setS(() => frequency = v!),
              decoration: InputDecoration(labelText: 'Frequency', prefixIcon: const Icon(Icons.repeat), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
            ),
            SizedBox(height: 12.h),
            Text('Reminder Times', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            Wrap(spacing: 6.w, runSpacing: 6.h, children: timeLabels.entries.map((e) => FilterChip(
              label: Text(e.value, style: TextStyle(fontSize: 11.sp)),
              selected: selectedHours.contains(e.key),
              onSelected: (v) => setS(() => v ? selectedHours.add(e.key) : selectedHours.remove(e.key)),
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
            )).toList()),
            SizedBox(height: 12.h),
            Text('Days', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            Wrap(spacing: 6.w, children: dayLabels.entries.map((e) => FilterChip(
              label: Text(e.value, style: TextStyle(fontSize: 11.sp)),
              selected: selectedDays.contains(e.key),
              onSelected: (v) => setS(() => v ? selectedDays.add(e.key) : selectedDays.remove(e.key)),
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
            )).toList()),
            SizedBox(height: 12.h),
            TextField(controller: notesC, decoration: InputDecoration(labelText: 'Notes (optional)', prefixIcon: const Icon(Icons.note), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
            SizedBox(height: 16.h),
            SizedBox(width: double.infinity, height: 48.h, child: ElevatedButton(
              onPressed: () async {
                if (nameC.text.trim().isEmpty || dosageC.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields'), behavior: SnackBarBehavior.floating));
                  return;
                }
                await mp.addReminder(
                  name: nameC.text.trim(), dosage: dosageC.text.trim(), frequency: frequency,
                  hours: selectedHours.toList(), days: selectedDays.toList(), notes: notesC.text.trim(),
                );
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Add Medicine'),
            )),
            SizedBox(height: 20.h),
          ])),
        ),
      ),
    );
  }
}
