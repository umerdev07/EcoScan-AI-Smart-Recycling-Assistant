class ScanResult {
  final String objectName;
  final String shortDescription;
  final double confidence;       // 0.0 – 1.0
  final bool isRecyclable;
  final String recyclingInfo;
  final List<String> reuseIdeas;
  final String disposalAdvice;
  final int ecoPoints;

  const ScanResult({
    required this.objectName,
    required this.shortDescription,
    required this.confidence,
    required this.isRecyclable,
    required this.recyclingInfo,
    required this.reuseIdeas,
    required this.disposalAdvice,
    required this.ecoPoints,
  });
}