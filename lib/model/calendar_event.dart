import 'package:equatable/equatable.dart';

class CalendarEventKey extends Equatable {
  const CalendarEventKey(this.dateTime);
  final DateTime dateTime;
  String get key => "${dateTime.month}-${dateTime.day}";

  bool isSameDay(DateTime other) {
    return dateTime.year == other.year &&
        dateTime.month == other.month &&
        dateTime.day == other.day;
  }

  @override
  List<Object?> get props => [key];
}

abstract class CalendarEvent extends Equatable {
  CalendarEvent({
    required DateTime dateTime,
  }) : eventKey = CalendarEventKey(dateTime);
  final CalendarEventKey eventKey;

  @override
  List<Object?> get props => [
        eventKey,
      ];
}

class EconomicEvent extends CalendarEvent {
  EconomicEvent({required super.dateTime});
}
