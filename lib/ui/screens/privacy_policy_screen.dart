import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Text(
            '''Privacy Policy for AI Healthcare Emergency Assistant

Last Updated: May 16, 2026

Welcome to the AI Healthcare Emergency Assistant (“App”, “Service”, “we”, “our”, or “us”).
Your privacy and safety are extremely important to us. This Privacy Policy explains how we collect, use, store, and protect your information when you use our application.

By using this App, you agree to the practices described in this Privacy Policy.

1. Purpose of the Application

The AI Healthcare Emergency Assistant is designed to help users during potential medical emergencies by providing:
- Real-time health monitoring
- Emergency detection and alerts
- First-aid assistance and guidance
- Communication with emergency contacts and healthcare services

The App is not a replacement for professional medical diagnosis, treatment, or emergency healthcare services.

2. Information We Collect

To provide emergency monitoring and assistance, we may collect the following types of information:

A. Personal Information
Name, Phone number, Email address, Age and gender (optional), Emergency contact details

B. Health & Sensor Data
With your permission, the App may collect:
Heart rate, Blood oxygen levels (SpO₂), Activity and movement data, Fall detection data, Sleep or stress-related indicators, Breathing irregularities
Data may come from: Smartwatches, Fitness bands, Mobile sensors, Connected wearable devices

C. Audio & Voice Data
The App may temporarily process:
Voice commands, Distress phrases, Breathing sounds, Stress indicators in speech
Audio processing is primarily used for emergency detection and voice assistance.

D. Camera & Facial Analysis Data
With explicit consent, the App may analyze facial expressions or movement patterns to detect signs of distress, unconsciousness, or emergencies.
We do not use facial data for identity recognition or advertising purposes.

E. Location Information
We may collect real-time GPS location data to:
Share your location with emergency contacts, Help emergency responders locate you, Recommend nearby hospitals or clinics

F. Device & Technical Data
We may collect:
Device model, Operating system, App version, Crash logs, Network information

3. How We Use Your Information

We use collected information to:
Detect possible medical emergencies, Send emergency alerts, Provide AI-based first-aid guidance, Enable voice assistance features, Monitor health trends and anomalies, Improve app functionality and safety, Recommend healthcare resources, Support offline emergency communication.
We do not sell personal health data to advertisers or third parties.

4. Emergency Response Features

If the system detects a potential emergency and you do not respond:
The App may:
Notify emergency contacts, Share your live GPS location, Trigger emergency SMS alerts, Contact local emergency services (where supported)
These actions are intended solely for user safety.

5. Offline Functionality

Some emergency features may work without internet access, including:
Basic fall detection, Emergency alarms, SMS alerts with location, Local first-aid instructions
However, certain AI features and telemedicine services may require an internet connection.

6. Data Sharing

We only share data in limited situations.
We may share information with:
Emergency contacts chosen by you, Healthcare or emergency responders during emergencies, Trusted service providers supporting app functionality, Telemedicine providers (only when requested by you).
We do NOT:
Sell health data, Share sensitive data for advertising, Use health information for profiling unrelated to safety features.

7. Data Storage & Security

We implement industry-standard security measures to protect your data, including:
Encryption of sensitive data, Secure cloud storage, Access control systems, Authentication protections.
Despite our efforts, no digital system can guarantee 100% security.

8. User Consent & Control

You control your data and permissions. You may:
Enable or disable sensors, Revoke microphone or camera access, Delete your account, Remove emergency contacts, Request deletion of stored data.

9. Medical Disclaimer

The AI Healthcare Emergency Assistant:
Does NOT provide medical diagnosis, Is NOT a licensed healthcare provider, Should NOT replace doctors, hospitals, or emergency services.
Always seek professional medical attention for serious conditions or emergencies. The App provides informational and first-response assistance only.

10. AI Limitations

AI-based detection systems may occasionally:
Miss emergencies, Generate false alerts, Misinterpret symptoms or sensor data.
Users should not rely solely on the App for life-critical decisions.

11. Children’s Privacy

This App is not intended for children under 13 without parental or guardian supervision.
If we learn that personal information from a child was collected improperly, we will take steps to delete it.

12. International Users

If you use the App outside your country of residence, your information may be processed in regions where data protection laws differ. We aim to comply with applicable privacy regulations wherever possible.

13. Data Retention

We retain data only as long as necessary for:
Safety functionality, Legal compliance, Technical support, Service improvement.
Users may request deletion of their personal information.

14. Third-Party Services

The App may integrate with third-party services such as:
Wearable device providers, Maps and GPS services, Telemedicine platforms, SMS or emergency communication providers.
Their services may have separate privacy policies.

15. Changes to This Privacy Policy

We may update this Privacy Policy periodically. Updated versions will be posted inside the App or on the official website with a revised “Last Updated” date.

16. Contact Us

If you have questions or concerns regarding this Privacy Policy, contact us at:
Email: support@yourappname.com
Website: yourappname.com
Support Center: Available inside the App

17. Consent

By using this application, you acknowledge that you have read, understood, and agreed to this Privacy Policy and consent to the collection and use of information as described above.''',
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
