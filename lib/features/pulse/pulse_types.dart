enum DateRange { last7Days, last30Days, last90Days, lastYear }

extension DateRangeExt on DateRange {
  int get days => switch (this) {
    DateRange.last7Days => 7,
    DateRange.last30Days => 30,
    DateRange.last90Days => 90,
    DateRange.lastYear => 365,
  };

  String get label => switch (this) {
    DateRange.last7Days => 'Last 7 Days',
    DateRange.last30Days => 'Last 30 Days',
    DateRange.last90Days => 'Last 90 Days',
    DateRange.lastYear => 'Last Year',
  };
}
