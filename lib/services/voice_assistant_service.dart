import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceAssistantService {
  static final VoiceAssistantService _instance = VoiceAssistantService._internal();
  factory VoiceAssistantService() => _instance;
  VoiceAssistantService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  
  bool _isInitialized = false;
  bool _isListening = false;

  Future<void> initialize() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    
    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  Future<bool> initializeSpeechRecognition() async {
    return await _speechToText.initialize();
  }

  Future<void> startListening(Function(String) onResult) async {
    if (!_isListening) {
      _isListening = true;
      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
      );
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening = false;
  }

  Future<String> getEmergencyResponse(String emergencyType) async {
    switch (emergencyType.toLowerCase()) {
      case 'heart attack':
        return 'I detect you may be having a heart emergency. Stay calm. Sit down and rest. Loosen any tight clothing. If you have aspirin, chew one tablet. I am calling for help now.';
      case 'breathing difficulty':
        return 'I detect breathing difficulty. Stay calm and sit upright. Try to take slow, deep breaths. If you have an inhaler, use it. Help is on the way.';
      case 'fall':
        return 'I detect a fall has occurred. Do not try to move if you are injured. Stay where you are and try to stay calm. Help is on the way.';
      case 'panic attack':
        return 'I detect signs of a panic attack. Focus on your breathing. Breathe in slowly through your nose for 4 seconds, hold for 4 seconds, and exhale through your mouth for 4 seconds. You are safe.';
      default:
        return 'I detect an emergency situation. Stay calm and try to breathe slowly. Help is on the way.';
    }
  }

  Future<void> provideFirstAidGuidance(String situation) async {
    final guidance = await getEmergencyResponse(situation);
    await speak(guidance);
  }
}
