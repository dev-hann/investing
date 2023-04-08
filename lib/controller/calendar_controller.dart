import 'package:investing/controller/controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/use_case/event_use_case.dart';

typedef CalendarEventData = Map<String, List<CalendarEvent>>;

class CalendarController extends Controller<EventUseCase> {
  CalendarController(super.useCase);

  Future<List<CalendarEvent>> requestEventList({
    required DateTime dateTime,
    required CalendarEventType eventType,
  }) async {
    switch (eventType) {
      case CalendarEventType.economics:
        return (await useCase.requestEconomicEventList(dateTime))
            .map((e) => EconomicEvent.fromMap(e))
            .where((element) {
          return element.country.code == "US";
        }).toList();
      case CalendarEventType.earnings:
        return (await useCase.requestEarningEventList(dateTime))
            .map((e) => EarningEvent.fromMap(e))
            .toList();
      case CalendarEventType.dividends:
        return (await useCase.requestDvidendEventList(dateTime))
            .map((e) => DividendEvent.fromMap(e))
            .toList();
    }
  }
}
