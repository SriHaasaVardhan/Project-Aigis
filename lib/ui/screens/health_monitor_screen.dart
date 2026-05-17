import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/health_monitor_provider.dart';
import 'package:health_guardian/ui/widgets/health_metric_card.dart';
import 'package:health_guardian/ui/screens/camera_analysis_screen.dart';

class HealthMonitorScreen extends StatefulWidget {
  const HealthMonitorScreen({super.key});

  @override
  State<HealthMonitorScreen> createState() => _HealthMonitorScreenState();
}

class _HealthMonitorScreenState extends State<HealthMonitorScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<HealthMonitorProvider>();
    provider.startMonitoring();
  }

  @override
  void dispose() {
    final provider = context.read<HealthMonitorProvider>();
    provider.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthMonitorProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Health Monitor'),
            actions: [
              IconButton(
                icon: Icon(
                  provider.isMonitoring ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  if (provider.isMonitoring) {
                    provider.stopMonitoring();
                  } else {
                    provider.startMonitoring();
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Indicator
                  _StatusIndicator(status: provider.status),
                  SizedBox(height: 20.h),
                  
                  // Health Metrics Grid
                  Text(
                    'Vital Signs',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.h,
                    crossAxisSpacing: 15.w,
                    childAspectRatio: 1.0,
                    children: [
                      HealthMetricCard(
                        title: 'Heart Rate',
                        value: provider.currentHealthData.heartRate?.toStringAsFixed(0) ?? '--',
                        unit: 'BPM',
                        icon: Icons.favorite,
                        color: Colors.red,
                        isNormal: !(provider.currentHealthData.isHeartRateAbnormal()),
                      ),
                      HealthMetricCard(
                        title: 'Oxygen Level',
                        value: provider.currentHealthData.oxygenLevel?.toStringAsFixed(0) ?? '--',
                        unit: '%',
                        icon: Icons.air,
                        color: Colors.blue,
                        isNormal: !(provider.currentHealthData.isOxygenLow()),
                      ),
                      HealthMetricCard(
                        title: 'Stress Level',
                        value: provider.currentHealthData.stressLevel != null
                            ? (provider.currentHealthData.stressLevel! * 100).toStringAsFixed(0)
                            : '--',
                        unit: '%',
                        icon: Icons.psychology,
                        color: Colors.purple,
                        isNormal: !(provider.currentHealthData.isStressHigh()),
                      ),
                      HealthMetricCard(
                        title: 'Movement',
                        value: provider.currentHealthData.movement != null
                            ? (provider.currentHealthData.movement! * 100).toStringAsFixed(0)
                            : '--',
                        unit: '%',
                        icon: Icons.directions_walk,
                        color: Colors.green,
                        isNormal: true,
                      ),
                    ],
                  ),
                  
                  // Camera Analysis Section
                  Text(
                    'Camera Analysis',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CameraAnalysisScreen()),
                      );
                    },
                    icon: const Icon(Icons.camera_front),
                    label: const Text('Open Camera for Facial Analysis'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Monitoring Controls
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Facial Analysis'),
                            subtitle: const Text('Monitor facial expressions'),
                            value: true,
                            onChanged: (value) {
                              // Toggle facial analysis
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Voice Analysis'),
                            subtitle: const Text('Monitor voice patterns'),
                            value: true,
                            onChanged: (value) {
                              // Toggle voice analysis
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Wearable Integration'),
                            subtitle: const Text('Connect to smartwatch'),
                            value: true,
                            onChanged: (value) {
                              // Toggle wearable
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}

class _StatusIndicator extends StatelessWidget {
  final MonitoringStatus status;

  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    
    switch (status) {
      case MonitoringStatus.normal:
        color = Colors.green;
        text = 'Normal';
        break;
      case MonitoringStatus.warning:
        color = Colors.orange;
        text = 'Warning';
        break;
      case MonitoringStatus.critical:
        color = Colors.red;
        text = 'Critical';
        break;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Status: $text',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _AnalysisRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
