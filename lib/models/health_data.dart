class HealthData {
  final double? heartRate;
  final double? oxygenLevel;
  final double? stressLevel;
  final String? facialExpression;
  final double? voiceStress;
  final double? movement;
  final int? steps;
  final double? calories;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  HealthData({
    this.heartRate,
    this.oxygenLevel,
    this.stressLevel,
    this.facialExpression,
    this.voiceStress,
    this.movement,
    this.steps,
    this.calories,
    DateTime? timestamp,
    this.additionalData,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'heartRate': heartRate,
      'oxygenLevel': oxygenLevel,
      'stressLevel': stressLevel,
      'facialExpression': facialExpression,
      'voiceStress': voiceStress,
      'movement': movement,
      'steps': steps,
      'calories': calories,
      'timestamp': timestamp.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      heartRate: json['heartRate']?.toDouble(),
      oxygenLevel: json['oxygenLevel']?.toDouble(),
      stressLevel: json['stressLevel']?.toDouble(),
      facialExpression: json['facialExpression'],
      voiceStress: json['voiceStress']?.toDouble(),
      movement: json['movement']?.toDouble(),
      steps: json['steps']?.toInt(),
      calories: json['calories']?.toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      additionalData: json['additionalData'] != null
          ? Map<String, dynamic>.from(json['additionalData'])
          : null,
    );
  }

  bool isHeartRateAbnormal() {
    if (heartRate == null) return false;
    return heartRate! < 50 || heartRate! > 120;
  }

  bool isHeartRateCritical() {
    if (heartRate == null) return false;
    return heartRate! < 40 || heartRate! > 150;
  }

  bool isOxygenLow() {
    if (oxygenLevel == null) return false;
    return oxygenLevel! < 90;
  }

  bool isStressHigh() {
    if (stressLevel == null) return false;
    return stressLevel! > 0.7;
  }
}
