class LanguageCache {
  LanguageCache({
    required this.languages,
    required this.repoCounts,
    required this.cachedAt,
  });

  final Map<String, double> languages;
  final Map<String, int> repoCounts;
  final DateTime cachedAt;

  factory LanguageCache.fromJson(Map<String, dynamic> json) {
    final langsRaw = (json['languages'] as Map<String, dynamic>? ?? const {});
    final countsRaw = (json['repoCounts'] as Map<String, dynamic>? ?? const {});
    return LanguageCache(
      languages: langsRaw.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
      repoCounts: countsRaw.map(
        (key, value) => MapEntry(key, (value as num).toInt()),
      ),
      cachedAt:
          DateTime.tryParse(json['cachedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
    'languages': languages,
    'repoCounts': repoCounts,
    'cachedAt': cachedAt.toIso8601String(),
  };
}
