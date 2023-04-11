part of event_repo;

class EventImpl extends EventRepo {
  final EventService eventService = EventService();
  @override
  Future<List> requestEconomicEventList(DateTime dateTime) async {
    try {
      final list = List.from(
        await eventService.requestEconomicEventList(
          IVDateTimeFormat(dateTime).dateTimeFormat()!,
        ),
      );
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List> requestDvidendEventList(DateTime dateTime) async {
    try {
      final list = List.from(
        await eventService.requestDvidendEventList(
          IVDateTimeFormat(dateTime).dateTimeFormat()!,
        ),
      );
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List> requestEarningEventList(DateTime dateTime) async {
    try {
      final list = List.from(
        await eventService.requestEarningEventList(
          IVDateTimeFormat(dateTime).dateTimeFormat()!,
        ),
      );
      return list;
    } catch (e) {
      return [];
    }
  }
}
