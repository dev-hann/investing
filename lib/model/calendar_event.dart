import 'package:equatable/equatable.dart';

class CalendarEventKey extends Equatable {
  const CalendarEventKey(this.dateTime);
  final DateTime dateTime;
  String get key => "${dateTime.month}-${dateTime.day}";

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
