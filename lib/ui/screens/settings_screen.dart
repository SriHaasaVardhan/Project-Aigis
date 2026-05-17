import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/settings_provider.dart';
import 'package:health_guardian/ui/screens/privacy_policy_screen.dart';
import 'package:health_guardian/ui/screens/data_management_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                const _SectionTitle('General'),
                _SettingTile(
                  title: 'Dark Mode',
                  subtitle: 'Enable dark theme',
                  icon: Icons.dark_mode,
                  trailing: Switch(
                    value: settings.darkMode,
                    onChanged: settings.toggleDarkMode,
                  ),
                ),
                _SettingTile(
                  title: 'Language',
                  subtitle: 'App language',
                  icon: Icons.language,
                  trailing: DropdownButton<String>(
                    value: settings.language,
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'es', child: Text('Spanish')),
                      DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        settings.setLanguage(value);
                      }
                    },
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                const _SectionTitle('Monitoring'),
                _SettingTile(
                  title: 'Notifications',
                  subtitle: 'Enable health alerts',
                  icon: Icons.notifications,
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: settings.toggleNotifications,
                  ),
                ),
                _SettingTile(
                  title: 'Voice Assistant',
                  subtitle: 'AI voice guidance',
                  icon: Icons.mic,
                  trailing: Switch(
                    value: settings.voiceAssistantEnabled,
                    onChanged: settings.toggleVoiceAssistant,
                  ),
                ),
                _SettingTile(
                  title: 'Facial Analysis',
                  subtitle: 'Monitor facial expressions',
                  icon: Icons.face,
                  trailing: Switch(
                    value: settings.facialAnalysisEnabled,
                    onChanged: settings.toggleFacialAnalysis,
                  ),
                ),
                _SettingTile(
                  title: 'Voice Analysis',
                  subtitle: 'Monitor voice patterns',
                  icon: Icons.record_voice_over,
                  trailing: Switch(
                    value: settings.voiceAnalysisEnabled,
                    onChanged: settings.toggleVoiceAnalysis,
                  ),
                ),
                _SettingTile(
                  title: 'Wearable Integration',
                  subtitle: 'Connect to smartwatch',
                  icon: Icons.watch,
                  trailing: Switch(
                    value: settings.wearableIntegrationEnabled,
                    onChanged: settings.toggleWearableIntegration,
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                const _SectionTitle('Emergency'),
                _SettingTile(
                  title: 'Confirmation Time',
                  subtitle: '${settings.emergencyConfirmationTime} seconds',
                  icon: Icons.timer,
                  onTap: () {
                    _showConfirmationTimeDialog(context, settings);
                  },
                ),
                _SettingTile(
                  title: 'Auto Call Emergency',
                  subtitle: 'Automatically call emergency services',
                  icon: Icons.phone_in_talk,
                  trailing: Switch(
                    value: settings.autoCallEmergency,
                    onChanged: settings.toggleAutoCallEmergency,
                  ),
                ),
                _SettingTile(
                  title: 'Emergency Number',
                  subtitle: settings.emergencyPhoneNumber,
                  icon: Icons.emergency,
                  onTap: () {
                    _showEmergencyNumberDialog(context, settings);
                  },
                ),
                
                SizedBox(height: 20.h),
                
                const _SectionTitle('Privacy & Security'),
                _SettingTile(
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  icon: Icons.privacy_tip,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                    );
                  },
                ),
                _SettingTile(
                  title: 'Data Management',
                  subtitle: 'Manage your health data',
                  icon: Icons.storage,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DataManagementScreen()),
                    );
                  },
                ),
                _SettingTile(
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  icon: Icons.delete_forever,
                  onTap: () {
                    _showDeleteAccountDialog(context);
                  },
                  textColor: Colors.red,
                ),
                
                SizedBox(height: 20.h),
                
                const _SectionTitle('About'),
                const _SettingTile(
                  title: 'App Version',
                  subtitle: '1.2.0',
                  icon: Icons.info,
                ),
                _SettingTile(
                  title: 'Medical Disclaimer',
                  subtitle: 'Important medical information',
                  icon: Icons.medical_services,
                  onTap: () {
                    _showMedicalDisclaimer(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationTimeDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select confirmation time in seconds:'),
            const SizedBox(height: 20),
            Slider(
              value: settings.emergencyConfirmationTime.toDouble(),
              min: 10,
              max: 60,
              divisions: 5,
              label: '${settings.emergencyConfirmationTime}s',
              onChanged: (value) {
                settings.setEmergencyConfirmationTime(value.toInt());
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyNumberDialog(BuildContext context, SettingsProvider settings) {
    final controller = TextEditingController(text: settings.emergencyPhoneNumber);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Number'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Emergency Phone Number',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              settings.setEmergencyPhoneNumber(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Delete account logic
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showMedicalDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medical Disclaimer'),
        content: const SingleChildScrollView(
          child: Text(
            'AIGIS is an AI-powered health monitoring and emergency response assistant. '
            'It is NOT a substitute for professional medical advice, diagnosis, or treatment.\n\n'
            'This app provides:\n'
            '- Health monitoring and alerts\n'
            '- Emergency detection and response\n'
            '- First-aid guidance\n'
            '- Location sharing with emergency contacts\n\n'
            'Always seek the advice of your physician or other qualified health provider '
            'with any questions you may have regarding a medical condition.\n\n'
            'If you think you may have a medical emergency, call your doctor or emergency services immediately.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;

  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        subtitle: Text(subtitle),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }
}
