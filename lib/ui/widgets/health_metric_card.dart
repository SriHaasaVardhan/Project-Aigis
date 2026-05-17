import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HealthMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final bool isNormal;

  const HealthMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.isNormal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: isNormal ? null : color.withOpacity(0.1),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 18.sp),
                ),
                if (!isNormal) Icon(Icons.warning, color: Colors.orange, size: 16.sp),
              ],
            ),
            SizedBox(height: 8.h),
            Text(title, style: TextStyle(fontSize: 11.sp, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: 2.h),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(value, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: isNormal ? null : color)),
                    SizedBox(width: 3.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Text(unit, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
