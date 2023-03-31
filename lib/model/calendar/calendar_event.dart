library calendar_event;

import 'package:equatable/equatable.dart';
import 'package:investing/util/date_time_format.dart';

part './economic_event.dart';
part './earning_event.dart';
part './dividend_event.dart';

enum CalendarEventType {
  economics,
  earnings,
  dividends,
}

abstract class CalendarEvent extends Equatable {
  const CalendarEvent(this.type);

  final CalendarEventType type;

  static String key(DateTime dateTime) {
    return IVDateTimeFormat(dateTime).dateTimeFormat();
  }

  @override
  List<Object?> get props => [
        type,
      ];
}
