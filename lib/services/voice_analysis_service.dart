import 'package:speech_to_text/speech_to_text.dart';

class VoiceAnalysisService {
  static final VoiceAnalysisService _instance = VoiceAnalysisService._internal();
  factory VoiceAnalysisService() => _instance;
  VoiceAnalysisService._internal();

  final SpeechToText _speechToText = SpeechToText();
  bool _isMonitoring = false;
  bool _isInitialized = false;

  final List<String> _distressPhrases = [
    'help',
    'emergency',
    "can't breathe",
    'chest pain',
    'heart attack',
    'falling',
    'hurt',
    'pain',
    'scared',
    'panic',
    'dying',
    'unconscious',
    'fainting',
    'call doctor',
    'ambulance',
  ];

  Future<void> initialize() async {
    _isInitialized = await _speechToText.initialize();
  }

  Future<void> startMonitoring() async {
    if (!_isInitialized) {
      await initialize();
    }
    _isMonitoring = true;
  }

  Future<void> stopMonitoring() async {
    await _speechToText.stop();
    _isMonitoring = false;
  }

  Future<Map<String, dynamic>> analyze() async {
    if (!_isMonitoring) {
      return {
        'stressLevel': 0.0,
        'hasDistress': false,
        'detectedPhrase': null,
      };
    }

    // In a real implementation, this would continuously listen and analyze
    // For now, return simulated data
    return {
      'stressLevel': _calculateVoiceStress(),
      'hasDistress': false,
      'detectedPhrase': null,
    };
  }

  double _calculateVoiceStress() {
    // In real implementation, analyze voice characteristics:
    // - Pitch variability
    // - Speech rate
    // - Volume changes
    // - Breathing patterns
    // - Tremors in voice
    
    // Simulated stress level (0.0 to 1.0)
    return 0.1;
  }

  bool detectDistressPhrase(String text) {
    final lowerText = text.toLowerCase();
    for (final phrase in _distressPhrases) {
      if (lowerText.contains(phrase)) {
        return true;
      }
    }
    return false;
  }

  String? getDetectedDistressPhrase(String text) {
    final lowerText = text.toLowerCase();
    for (final phrase in _distressPhrases) {
      if (lowerText.contains(phrase)) {
        return phrase;
      }
    }
    return null;
  }

  Future<void> listenForDistress(Function(String) onDistressDetected) async {
    if (!_isMonitoring) {
      await startMonitoring();
    }

    await _speechToText.listen(
      onResult: (result) {
        final text = result.recognizedWords;
        if (detectDistressPhrase(text)) {
          final phrase = getDetectedDistressPhrase(text);
          onDistressDetected(phrase ?? 'distress detected');
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
    );
  }
}
