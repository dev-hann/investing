import 'package:equatable/equatable.dart';

class DateTimeRange extends Equatable {
  const DateTimeRange(this.begin, this.end);
  final DateTime begin;
  final DateTime end;

  @override
  List<Object?> get props => [begin, end];

  factory DateTimeRange.beforeDay(int day) {
    final now = DateTime.now();
    return DateTimeRange(
      now.add(Duration(days: -day)),
      now,
    );
  }
  factory DateTimeRange.beforeMonth(int month) {
    final now = DateTime.now();
    return DateTimeRange(
      DateTime(now.year, now.month - month, now.day),
      now,
    );
  }
  factory DateTimeRange.beforeYear(int year) {
    final now = DateTime.now();
    return DateTimeRange(
      DateTime(now.year - year, now.month, now.day),
      now,
    );
  }
}
