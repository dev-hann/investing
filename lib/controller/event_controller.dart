import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/use_case/event_use_case.dart';

typedef CalendarEventData = Map<String, List<CalendarEvent>>;

class EventController extends Controller<EventUseCase> {
  EventController(super.useCase);

  static EventController find() => Get.find<EventController>();
  final RxMap<CalendarEventType, CalendarEventData> eventData = RxMap();
  final Rx<DateTime> dateTime = Rx(DateTime.now());
  final Rx<CalendarEventType> eventType = Rx(CalendarEventType.economics);
  final Rxn<List<CalendarEvent>> eventList = Rxn();

  @override
  void onReady() {
    // refreshEventList();
    super.onReady();
  }

  Future refreshEventList({
    CalendarEventType? newEventType,
    DateTime? newDateTime,
  }) async {
    final e = newEventType ?? eventType.value;
    final d = newDateTime ?? dateTime.value;
    dateTime(d);
    eventType(e);

    if (!eventData.containsKey(e)) {
      eventData[e] = {};
    }
    eventList.value = null;
    final List<CalendarEvent> tmpList = [];
    final data = eventData[e]!;
    final key = CalendarEvent.key(d);
    if (data.containsKey(key)) {
      tmpList.addAll(data[key]!);
    } else {
      final List<CalendarEvent> eventList = [];
      switch (e) {
        case CalendarEventType.economics:
          final list = await useCase.requestEconomicEventList(d);
          eventList.addAll(list.where((e) => e.country.code == "US").toList());
          break;
        case CalendarEventType.earnings:
          eventList.addAll(await useCase.requestEarningEventList(d));
          break;
        case CalendarEventType.dividends:
          eventList.addAll(await useCase.requestDvidendEventList(d));
          break;
      }
      data[key] = eventList;
      eventData.update(e, (value) => data);
      tmpList.addAll(eventList);
    }
    eventList(tmpList);
  }
}
