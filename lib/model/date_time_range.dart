import 'package:equatable/equatable.dart';

class IVDateTimeRange extends Equatable {
  const IVDateTimeRange(this.begin, this.end);
  final DateTime begin;
  final DateTime end;

  @override
  List<Object?> get props => [begin, end];

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
}
