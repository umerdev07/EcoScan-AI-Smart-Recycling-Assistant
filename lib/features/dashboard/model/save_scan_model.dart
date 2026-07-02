class SavedScan {
  final String objectName;
  final String shortDescription;
  final bool isRecyclable;
  final int ecoPoints;
  final List<String> reuseIdeas;
  final String recyclingInfo;
  final String disposalAdvice;
  final DateTime savedAt;

  SavedScan({
    required this.objectName,
    required this.shortDescription,
    required this.isRecyclable,
    required this.ecoPoints,
    required this.reuseIdeas,
    required this.recyclingInfo,
    required this.disposalAdvice,
    required this.savedAt,
  });

  /// Convert from ScanResult (used when user taps Save)
  factory SavedScan.fromScanResult({
    required String objectName,
    required String shortDescription,
    required bool isRecyclable,
    required int ecoPoints,
    required List<String> reuseIdeas,
    required String recyclingInfo,
    required String disposalAdvice,
  }) {
    return SavedScan(
      objectName: objectName,
      shortDescription: shortDescription,
      isRecyclable: isRecyclable,
      ecoPoints: ecoPoints,
      reuseIdeas: reuseIdeas,
      recyclingInfo: recyclingInfo,
      disposalAdvice: disposalAdvice,
      savedAt: DateTime.now(),
    );
  }

  String get timeAgo {
    final diff = DateTime.now().difference(savedAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}