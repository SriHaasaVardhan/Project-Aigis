import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:health_guardian/ui/screens/home_remedies_screen.dart';

class HealthcareSupportScreen extends StatelessWidget {
  const HealthcareSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthcare Support'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Affordable Healthcare',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Find low-cost healthcare options near you',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 30.h),
              
              _SupportCard(
                icon: Icons.local_hospital,
                title: 'Nearby Hospitals',
                subtitle: 'Find hospitals and clinics in your area',
                color: Colors.blue,
                onTap: () {
                  _launchMap('hospitals near me');
                },
              ),
              
              _SupportCard(
                icon: Icons.medical_services,
                title: 'Government Schemes',
                subtitle: 'Explore government healthcare programs',
                color: Colors.green,
                onTap: () {
                  _showGovernmentSchemes(context);
                },
              ),
              
              _SupportCard(
                icon: Icons.video_call,
                title: 'Telemedicine',
                subtitle: 'Connect with doctors online',
                color: Colors.purple,
                onTap: () {
                  _showTelemedicineOptions(context);
                },
              ),
              
              _SupportCard(
                icon: Icons.health_and_safety,
                title: 'Home Remedies',
                subtitle: 'Search from over 100 common issues',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeRemediesScreen()),
                  );
                },
              ),
              
              _SupportCard(
                icon: Icons.attach_money,
                title: 'Low-Cost Clinics',
                subtitle: 'Find affordable healthcare providers',
                color: Colors.teal,
                onTap: () {
                  _launchMap('low cost clinics near me');
                },
              ),
              
              SizedBox(height: 30.h),
              
              Text(
                'Emergency Resources',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.h),
              
              const _EmergencyResourceCard(
                title: 'National Health Helpline',
                number: '104',
                description: '24/7 health information and advice',
              ),
              
              const _EmergencyResourceCard(
                title: 'Emergency Services',
                number: '108',
                description: 'Ambulance and emergency services',
              ),
              
              const _EmergencyResourceCard(
                title: 'Mental Health Helpline',
                number: '112',
                description: 'Crisis support and counseling',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchMap(String query) async {
    final url = Uri.parse('https://www.google.com/maps/search/$query');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _showGovernmentSchemes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Government Healthcare Schemes'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _SchemeItem(
                name: 'Ayushman Bharat',
                description: 'Health insurance for poor families',
              ),
              _SchemeItem(
                name: 'PMJAY',
                description: 'Pradhan Mantri Jan Arogya Yojana',
              ),
              _SchemeItem(
                name: 'Rashtriya Swasthya Bima Yojana',
                description: 'Health insurance for BPL families',
              ),
              _SchemeItem(
                name: 'National Health Mission',
                description: 'Universal health access',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTelemedicineOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Telemedicine Services'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TelemedicineOption(
              name: 'eSanjeevani',
              description: 'Government telemedicine service',
              isFree: true,
            ),
            _TelemedicineOption(
              name: 'Practo',
              description: 'Online doctor consultations',
              isFree: false,
            ),
            _TelemedicineOption(
              name: 'mfine',
              description: 'AI-powered healthcare',
              isFree: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHomeRemedies(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Home Remedies'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Disclaimer: These are for minor ailments only. For serious conditions, consult a doctor.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 15.h),
              const _RemedyItem(
                condition: 'Cold & Flu',
                remedy: 'Drink warm water with honey and lemon. Rest and stay hydrated.',
              ),
              const _RemedyItem(
                condition: 'Headache',
                remedy: 'Rest in a quiet, dark room. Apply cold compress to forehead.',
              ),
              const _RemedyItem(
                condition: 'Sore Throat',
                remedy: 'Gargle with warm salt water. Drink herbal tea with honey.',
              ),
              const _RemedyItem(
                condition: 'Minor Burns',
                remedy: 'Cool the burn under running water for 10-15 minutes. Apply aloe vera.',
              ),
              const _RemedyItem(
                condition: 'Indigestion',
                remedy: 'Drink ginger tea. Avoid heavy meals. Stay hydrated.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SupportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 15.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyResourceCard extends StatelessWidget {
  final String title;
  final String number;
  final String description;

  const _EmergencyResourceCard({
    required this.title,
    required this.number,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 15.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone,
                color: Colors.red,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    number,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SchemeItem extends StatelessWidget {
  final String name;
  final String description;

  const _SchemeItem({
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _TelemedicineOption extends StatelessWidget {
  final String name;
  final String description;
  final bool isFree;

  const _TelemedicineOption({
    required this.name,
    required this.description,
    required this.isFree,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      child: ListTile(
        title: Row(
          children: [
            Text(name),
            SizedBox(width: 8.w),
            if (isFree)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'FREE',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(description),
      ),
    );
  }
}

class _RemedyItem extends StatelessWidget {
  final String condition;
  final String remedy;

  const _RemedyItem({
    required this.condition,
    required this.remedy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            condition,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            remedy,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
