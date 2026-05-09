import 'dart:convert';

class ContributionDay {
  ContributionDay({required this.date, required this.contributionCount});

  final DateTime date;
  final int contributionCount;

  factory ContributionDay.fromJson(Map<String, dynamic> json) {
    return ContributionDay(
      date: DateTime.parse(json['date'] as String),
      contributionCount: json['contributionCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'contributionCount': contributionCount,
  };
}

class ContributionData {
  ContributionData({required this.totalContributions, required this.weeks});

  final int totalContributions;
  final List<List<ContributionDay>> weeks;

  factory ContributionData.fromJson(Map<String, dynamic> json) {
    final weeksRaw = (json['weeks'] as List<dynamic>? ?? const []);
    return ContributionData(
      totalContributions: json['totalContributions'] as int? ?? 0,
      weeks: weeksRaw
          .map(
            (week) => (week as List<dynamic>)
                .map(
                  (day) =>
                      ContributionDay.fromJson(day as Map<String, dynamic>),
                )
                .toList(),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalContributions': totalContributions,
    'weeks': weeks
        .map((week) => week.map((day) => day.toJson()).toList())
        .toList(),
  };
}

class ContributionCache {
  ContributionCache({
    required this.range,
    required this.totalContributions,
    required this.weeksJson,
    required this.cachedAt,
  });

  final String range;
  final int totalContributions;
  final String weeksJson;
  final DateTime cachedAt;

  factory ContributionCache.fromData({
    required ContributionData data,
    required String range,
    required DateTime cachedAt,
  }) {
    return ContributionCache(
      range: range,
      totalContributions: data.totalContributions,
      weeksJson: jsonEncode(
        data.weeks
            .map((week) => week.map((day) => day.toJson()).toList())
            .toList(),
      ),
      cachedAt: cachedAt,
    );
  }

  ContributionData toContributionData() {
    final decoded = (jsonDecode(weeksJson) as List<dynamic>)
        .map(
          (week) => (week as List<dynamic>)
              .map(
                (day) => ContributionDay.fromJson(day as Map<String, dynamic>),
              )
              .toList(),
        )
        .toList();
    return ContributionData(
      totalContributions: totalContributions,
      weeks: decoded,
    );
  }

  factory ContributionCache.fromJson(Map<String, dynamic> json) {
    return ContributionCache(
      range: json['range'] as String? ?? '',
      totalContributions: json['totalContributions'] as int? ?? 0,
      weeksJson: json['weeksJson'] as String? ?? '[]',
      cachedAt:
          DateTime.tryParse(json['cachedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
    'range': range,
    'totalContributions': totalContributions,
    'weeksJson': weeksJson,
    'cachedAt': cachedAt.toIso8601String(),
  };
}
