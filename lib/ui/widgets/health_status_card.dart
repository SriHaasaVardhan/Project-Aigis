import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:health_guardian/providers/health_monitor_provider.dart';

class HealthStatusCard extends StatelessWidget {
  const HealthStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthMonitorProvider>(
      builder: (context, provider, child) {
        final status = provider.status;
        final healthData = provider.currentHealthData;
        
        Color statusColor;
        String statusText;
        IconData statusIcon;
        
        switch (status) {
          case MonitoringStatus.normal:
            statusColor = Colors.green;
            statusText = 'Normal';
            statusIcon = Icons.check_circle;
            break;
          case MonitoringStatus.warning:
            statusColor = Colors.orange;
            statusText = 'Warning';
            statusIcon = Icons.warning;
            break;
          case MonitoringStatus.critical:
            statusColor = Colors.red;
            statusText = 'Critical';
            statusIcon = Icons.error;
            break;
        }
        
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                colors: [
                  statusColor.withOpacity(0.1),
                  statusColor.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            color: statusColor,
                            size: 28.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Health Status',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  
                  // Health Metrics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _HealthMetric(
                        label: 'Heart Rate',
                        value: healthData.heartRate?.toStringAsFixed(0) ?? '--',
                        unit: 'BPM',
                        icon: Icons.favorite,
                        color: Colors.red,
                      ),
                      _HealthMetric(
                        label: 'Oxygen',
                        value: healthData.oxygenLevel?.toStringAsFixed(0) ?? '--',
                        unit: '%',
                        icon: Icons.air,
                        color: Colors.blue,
                      ),
                      _HealthMetric(
                        label: 'Stress',
                        value: healthData.stressLevel != null
                            ? (healthData.stressLevel! * 100).toStringAsFixed(0)
                            : '--',
                        unit: '%',
                        icon: Icons.psychology,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 15.h),
                  
                  // Last Updated
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Last updated: ${_formatTime(healthData.timestamp)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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

class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _HealthMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24.sp,
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
