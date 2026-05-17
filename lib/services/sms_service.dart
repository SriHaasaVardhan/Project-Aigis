import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

class SMSService {
  static final SMSService _instance = SMSService._internal();
  factory SMSService() => _instance;
  SMSService._internal();

  final Telephony telephony = Telephony.instance;

  Future<bool> hasPermission() async {
    return await Permission.sms.isGranted;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  Future<void> sendEmergencyAlert({
    required String phoneNumber,
    required String message,
    Map<String, double>? location,
  }) async {
    try {
      if (!await hasPermission()) {
        await requestPermission();
      }

      await telephony.sendSms(
        to: phoneNumber,
        message: message,
      );
    } catch (e) {
      // Handle error - could try alternative methods
    }
  }

  Future<void> sendBulkEmergencyAlert({
    required List<String> phoneNumbers,
    required String message,
    Map<String, double>? location,
  }) async {
    for (final phoneNumber in phoneNumbers) {
      await sendEmergencyAlert(
        phoneNumber: phoneNumber,
        message: message,
        location: location,
      );
    }
  }
}
