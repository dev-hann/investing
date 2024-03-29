import 'package:equatable/equatable.dart';
import 'package:investing/model/chart.dart';

class IVDateTimeRange extends Equatable {
  const IVDateTimeRange(this.begin, this.end);
  final DateTime begin;
  final DateTime end;

  @override
  List<Object?> get props => [begin, end];

  bool isEqual(IVDateTimeRange other) {
    return isEqualDateTime(begin, other.begin) &&
        isEqualDateTime(end, other.end);
  }

  bool isEqualDateTime(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int get inDays => end.difference(begin).inDays;

  factory IVDateTimeRange.beforeDay(int day) {
    final now = DateTime.now();
    return IVDateTimeRange(
      now.add(Duration(days: -day)),
      now,
    );
  }
  factory IVDateTimeRange.beforeMonth(int month) {
    final now = DateTime.now();
    return IVDateTimeRange(
      DateTime(now.year, now.month - month, now.day),
      now,
    );
  }
  factory IVDateTimeRange.beforeYear(int year) {
    final now = DateTime.now();
    return IVDateTimeRange(
      DateTime(now.year - year, now.month, now.day),
      now,
    );
  }

  static IVDateTimeRange? fromRangeType(ChartRangeType type) {
    switch (type) {
      case ChartRangeType.realTime:
      case ChartRangeType.oneDay:
        return null;
      case ChartRangeType.oneMonth:
        return IVDateTimeRange.beforeMonth(1);
      case ChartRangeType.threeMonth:
        return IVDateTimeRange.beforeMonth(3);
      case ChartRangeType.oneYear:
        return IVDateTimeRange.beforeYear(1);
      case ChartRangeType.all:
        return IVDateTimeRange.beforeYear(100);
    }
  }
}
