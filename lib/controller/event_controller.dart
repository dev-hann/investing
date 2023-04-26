import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/use_case/event_use_case.dart';

typedef CalendarEventData = Map<String, List<CalendarEvent>>;

class EventController extends Controller<EventUseCase> {
  EventController(super.useCase);
  static EventController find() => Get.find<EventController>();
  final RxMap<CalendarEventType, CalendarEventData> eventData = RxMap();

  Future<List<CalendarEvent>> requestEventList({
    required CalendarEventType eventType,
    required DateTime dateTime,
  }) async {
    if (!eventData.containsKey(eventType)) {
      eventData[eventType] = {};
    }
    final data = eventData[eventType]!;
    final key = CalendarEvent.key(dateTime);
    if (data.containsKey(key)) {
      return data[key]!;
    }
    final List<CalendarEvent> eventList = [];
    switch (eventType) {
      case CalendarEventType.economics:
        final list = await useCase.requestEconomicEventList(dateTime);
        eventList.addAll(list.where((e) => e.country.code == "US").toList());
        break;
      case CalendarEventType.earnings:
        eventList.addAll(await useCase.requestEarningEventList(dateTime));
        break;
      case CalendarEventType.dividends:
        eventList.addAll(await useCase.requestDvidendEventList(dateTime));
        break;
    }
    data[key] = eventList;
    eventData.update(eventType, (value) => data);
    return eventList;
  }
}
