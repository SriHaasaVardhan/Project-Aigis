import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/emergency_provider.dart';
import 'package:health_guardian/models/emergency_contact.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  Future<void> _callContact(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyProvider>(
      builder: (context, ep, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Contacts')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddContactDialog(context, ep),
            child: const Icon(Icons.person_add),
          ),
          body: SafeArea(
            child: ep.emergencyContacts.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.contacts_outlined, size: 70.sp, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text('No Emergency Contacts', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.grey)),
                    SizedBox(height: 8.h),
                    Text('Add up to 5 emergency contacts', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(onPressed: () => _showAddContactDialog(context, ep), icon: const Icon(Icons.add), label: const Text('Add Contact')),
                  ]))
                : ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      // Emergency contacts section
                      Text('Emergency Contacts', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4.h),
                      Text('${ep.emergencyContacts.length}/5 contacts', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                      SizedBox(height: 12.h),
                      ...ep.emergencyContacts.map((c) => _ContactCard(
                        contact: c,
                        onCall: () => _callContact(c.phone),
                        onDelete: () => ep.removeEmergencyContact(c.id),
                      )),
                      SizedBox(height: 20.h),
                      // Quick dial section
                      Text('Quick Dial', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.h),
                      _QuickDialTile(name: 'Emergency Services', phone: '108', icon: Icons.local_hospital, color: Colors.red, onCall: () => _callContact('108')),
                      _QuickDialTile(name: 'Police', phone: '100', icon: Icons.shield, color: Colors.blue, onCall: () => _callContact('100')),
                      _QuickDialTile(name: 'Fire', phone: '101', icon: Icons.fire_truck, color: Colors.orange, onCall: () => _callContact('101')),
                      _QuickDialTile(name: 'Ambulance', phone: '102', icon: Icons.emergency, color: Colors.red, onCall: () => _callContact('102')),
                      _QuickDialTile(name: 'Women Helpline', phone: '181', icon: Icons.support, color: Colors.purple, onCall: () => _callContact('181')),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _showAddContactDialog(BuildContext context, EmergencyProvider provider) {
    if (provider.emergencyContacts.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maximum 5 emergency contacts allowed'), behavior: SnackBarBehavior.floating));
      return;
    }
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final relC = TextEditingController();
    bool isPrimary = false;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20.w, right: 20.w, top: 20.h),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.r))),
            SizedBox(height: 16.h),
            Text('Add Emergency Contact', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            TextField(controller: nameC, decoration: InputDecoration(labelText: 'Name', prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
            SizedBox(height: 12.h),
            TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Phone Number', prefixIcon: const Icon(Icons.phone), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
            SizedBox(height: 12.h),
            TextField(controller: relC, decoration: InputDecoration(labelText: 'Relationship', prefixIcon: const Icon(Icons.family_restroom), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)))),
            SizedBox(height: 8.h),
            SwitchListTile(title: const Text('Primary Contact'), value: isPrimary, onChanged: (v) => setS(() => isPrimary = v)),
            SizedBox(height: 12.h),
            SizedBox(width: double.infinity, height: 48.h, child: ElevatedButton(
              onPressed: () {
                if (nameC.text.isNotEmpty && phoneC.text.isNotEmpty) {
                  provider.addEmergencyContact(EmergencyContact(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameC.text, phone: phoneC.text, relationship: relC.text, isPrimary: isPrimary,
                  ));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add Contact'),
            )),
            SizedBox(height: 20.h),
          ]),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final EmergencyContact contact;
  final VoidCallback onCall, onDelete;
  const _ContactCard({required this.contact, required this.onCall, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(Icons.person, color: Theme.of(context).primaryColor),
        ),
        title: Row(children: [
          Flexible(child: Text(contact.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp), overflow: TextOverflow.ellipsis)),
          if (contact.isPrimary) ...[SizedBox(width: 6.w), Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8.r)),
            child: Text('Primary', style: TextStyle(fontSize: 9.sp, color: Colors.white, fontWeight: FontWeight.bold)),
          )],
        ]),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (contact.relationship.isNotEmpty) Text(contact.relationship, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
          Text(contact.phone, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
        ]),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(icon: const Icon(Icons.call, color: Colors.green), onPressed: onCall),
          IconButton(icon: Icon(Icons.delete, color: Colors.red[300], size: 20), onPressed: onDelete),
        ]),
      ),
    );
  }
}

class _QuickDialTile extends StatelessWidget {
  final String name, phone;
  final IconData icon;
  final Color color;
  final VoidCallback onCall;
  const _QuickDialTile({required this.name, required this.phone, required this.icon, required this.color, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: Container(padding: EdgeInsets.all(8.w), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20.sp)),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
        subtitle: Text(phone, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        trailing: IconButton(icon: const Icon(Icons.call, color: Colors.green), onPressed: onCall),
      ),
    );
  }
}
