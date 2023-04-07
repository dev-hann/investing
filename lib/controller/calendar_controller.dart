import 'package:investing/controller/controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/repo/event/event_repo.dart';

typedef CalendarEventData = Map<String, List<CalendarEvent>>;

class CalendarController extends Controller<EventRepo> {
  CalendarController(super.repo);

  Future<List<CalendarEvent>> requestEventList({
    required DateTime dateTime,
    required CalendarEventType eventType,
  }) async {
    switch (eventType) {
      case CalendarEventType.economics:
        return (await repo.requestEconomicEventList(dateTime))
            .map((e) => EconomicEvent.fromMap(e))
            .where((element) {
          return element.country.code == "US";
        }).toList();
      case CalendarEventType.earnings:
        return (await repo.requestEarningEventList(dateTime))
            .map((e) => EarningEvent.fromMap(e))
            .toList();
      case CalendarEventType.dividends:
        return (await repo.requestDvidendEventList(dateTime))
            .map((e) => DividendEvent.fromMap(e))
            .toList();
    }
  }
}
