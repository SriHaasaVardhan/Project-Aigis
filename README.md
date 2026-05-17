flutter # Health Guardian

An AI-powered healthcare emergency detection and response assistant mobile application built with Flutter/Dart.

## Overview

Health Guardian is a comprehensive mobile application designed to save lives by providing real-time health monitoring, emergency detection, and immediate response capabilities. The app uses multi-modal AI approaches including facial analysis, voice recognition, behavioral patterns, and wearable health data integration.

## Key Features

### 1. Multi-Modal Health Monitoring
- **Facial Analysis**: Analyzes facial expressions for distress signals using ML Kit
- **Voice Recognition**: Detects voice stress, breathing irregularities, and distress phrases
- **Wearable Integration**: Connects to smartwatches/fitness bands for heart rate, SpO₂, and activity data
- **Sensor Monitoring**: Uses device sensors for fall detection and movement tracking

### 2. Intelligent Emergency Detection
- Detects falls, lack of movement, and abnormal health patterns
- AI decision models to identify high-risk situations
- Automatic user confirmation prompts ("Are you okay?")

### 3. Automated Emergency Response
- Automatic alerts to emergency contacts via SMS
- Real-time GPS location sharing
- Emergency services integration
- Configurable confirmation timer

### 4. AI Voice Health Assistant
- Voice command recognition in emergencies
- Step-by-step first-aid guidance (CPR, breathing techniques)
- Calming instructions to reduce panic
- Text-to-speech for accessibility

### 5. Affordable Healthcare Support
- Nearby low-cost hospitals and clinics finder
- Government healthcare schemes information
- Telemedicine consultation options
- Safe home remedies for non-critical situations

### 6. Offline Emergency Functionality
- Basic detection and alert system works without internet
- SMS alerts with location to emergency contacts
- Local database for health data storage
- Queued alerts sent when connection restored

### 7. Family & Caregiver Integration
- Real-time health alerts shared with family members
- Monitoring dashboard for elderly or high-risk users
- Multi-user support
- Health history tracking

### 8. Smart Features
- Stress and anxiety detection
- Medicine reminders and health tracking
- Personalized risk insights
- Health trends visualization

### 9. Privacy & Safety Layer
- Secure handling of sensitive health data
- End-to-end encryption for personal information
- Medical disclaimers and user consent
- GDPR-compliant data management
- Right to be forgotten (data deletion)

## Technology Stack

### Frontend
- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **Provider**: State management
- **ScreenUtil**: Responsive design

### AI/ML
- **Google ML Kit**: Face detection and analysis
- **Speech-to-Text**: Voice recognition
- **Flutter TTS**: Text-to-speech

### Sensors & Hardware
- **Camera**: Facial analysis
- **Microphone**: Voice analysis
- **Sensors Plus**: Accelerometer and gyroscope
- **Health Package**: Wearable device integration
- **Geolocator**: GPS location
- **Bluetooth**: Wearable connectivity

### Storage & Database
- **Hive**: Local key-value storage
- **SQLite**: Offline database
- **Flutter Secure Storage**: Encrypted data storage
- **Shared Preferences**: Settings storage

### Communication
- **SMS Service**: Emergency alerts
- **URL Launcher**: External app integration
- **Connectivity Plus**: Network status

### Background Services
- **Flutter Background Service**: Continuous monitoring
- **Awesome Notifications**: Alert notifications

## Project Structure

```
lib/
├── core/
│   └── app.dart                 # App configuration
├── models/
│   ├── emergency_contact.dart   # Emergency contact model
│   ├── emergency_event.dart     # Emergency event model
│   ├── health_data.dart         # Health data model
│   ├── medicine_reminder.dart   # Medicine reminder model
│   └── user_profile.dart        # User profile model
├── providers/
│   ├── emergency_provider.dart  # Emergency state management
│   ├── health_monitor_provider.dart # Health monitoring state
│   └── settings_provider.dart   # Settings state management
├── services/
│   ├── background_service.dart  # Background monitoring
│   ├── facial_analysis_service.dart # Face analysis
│   ├── location_service.dart    # GPS location
│   ├── notification_service.dart # Push notifications
│   ├── offline_service.dart     # Offline functionality
│   ├── privacy_service.dart     # Privacy & encryption
│   ├── sensor_service.dart      # Device sensors
│   ├── sms_service.dart         # SMS alerts
│   ├── voice_analysis_service.dart # Voice analysis
│   ├── voice_assistant_service.dart # Voice assistant
│   └── wearable_service.dart   # Wearable integration
├── ui/
│   ├── screens/
│   │   ├── emergency_screen.dart
│   │   ├── emergency_contacts_screen.dart
│   │   ├── family_dashboard_screen.dart
│   │   ├── health_monitor_screen.dart
│   │   ├── healthcare_support_screen.dart
│   │   ├── home_screen.dart
│   │   ├── medicine_reminders_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── settings_screen.dart
│   │   └── splash_screen.dart
│   └── widgets/
│       ├── emergency_button.dart
│       ├── health_metric_card.dart
│       └── health_status_card.dart
├── utils/
│   └── theme.dart               # App theming
└── main.dart                    # App entry point
```

## Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode
- For Android: Android SDK (API 21+)
- For iOS: Xcode (latest version)

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd health_guardian
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For specific device
flutter devices
flutter run -d <device-id>
```

## Configuration

### Android Setup

1. Open `android/app/src/main/AndroidManifest.xml`
2. Ensure all permissions are granted
3. Configure your package name
4. Add your Google Maps API key if needed

### iOS Setup

1. Open `ios/Runner/Info.plist`
2. Add required permissions for camera, microphone, location, etc.
3. Configure background modes in Xcode
4. Enable required capabilities

### Permissions

The app requires the following permissions:

- **Camera**: For facial analysis
- **Microphone**: For voice analysis
- **Location**: For GPS tracking and emergency alerts
- **SMS**: For sending emergency alerts
- **Phone**: For emergency calls
- **Bluetooth**: For wearable device connection
- **Body Sensors**: For health data from wearables
- **Activity Recognition**: For fall detection

## Usage

### First-Time Setup

1. Launch the app
2. Grant required permissions
3. Set up your profile (name, blood type, allergies, etc.)
4. Add emergency contacts
5. Configure settings (notification preferences, emergency number, etc.)
6. Connect wearable devices (optional)

### Emergency Mode

1. Tap the large SOS button on the home screen
2. Or select a specific emergency type from the Emergency screen
3. The app will start a countdown timer (default: 30 seconds)
4. Confirm you're okay to cancel, or wait for automatic response
5. Emergency contacts will be alerted with your location

### Health Monitoring

1. Navigate to the Monitor tab
2. Enable/disable specific monitoring features
3. View real-time health metrics
4. Check AI analysis results
5. Review health history

### Family Dashboard

1. Add family members you want to monitor
2. View their health status in real-time
3. Receive alerts for their emergencies
4. Track their health history

## Medical Disclaimer

**IMPORTANT**: Health Guardian is an AI-powered health monitoring and emergency response assistant. It is NOT a substitute for professional medical advice, diagnosis, or treatment.

This app provides:
- Health monitoring and alerts
- Emergency detection and response
- First-aid guidance
- Location sharing with emergency contacts

Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.

If you think you may have a medical emergency, call your doctor or emergency services immediately.

## Privacy & Security

- All personal health data is encrypted using AES-256 encryption
- Data is stored locally on your device
- No data is shared with third parties without explicit consent
- Users can export or delete all their data at any time
- GDPR compliant with right to be forgotten

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Support

For issues, questions, or suggestions, please open an issue on GitHub or contact the development team.

## Acknowledgments

- Google ML Kit for face detection
- Flutter community for amazing packages
- Healthcare professionals for medical guidance
- All contributors and testers

## Version History

- **v1.0.0** - Initial release with core features
  - Multi-modal health monitoring
  - Emergency detection and response
  - AI voice assistant
  - Offline functionality
  - Privacy and security features
