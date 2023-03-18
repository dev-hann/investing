import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent({
    required this.dateTime,
  });
  final DateTime dateTime;

  String get key {
    return "${dateTime.month}-${dateTime.day}";
  }

  bool isSameDate(CalendarEvent other) {
    final otherDateTime = other.dateTime;
    return dateTime.year == otherDateTime.year &&
        dateTime.month == otherDateTime.month &&
        dateTime.day == otherDateTime.day;
  }

  @override
  List<Object?> get props => [
        dateTime,
      ];
}

class EconomicEvent extends CalendarEvent {
  const EconomicEvent({required super.dateTime});
}
