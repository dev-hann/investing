part of event_repo;

class EventImpl extends EventRepo {
  final EventService eventService = EventService();
  @override
  Future<List> requestEconomicEventList(DateTime dateTime) async {
    try {
      final res = await await eventService.requestEconomicEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      );
      return List.from(res["data"]["rows"]);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List> requestDvidendEventList(DateTime dateTime) async {
    try {
      final res = await await eventService.requestDvidendEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      );
      return List.from(res["data"]["calendar"]["rows"]);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List> requestEarningEventList(DateTime dateTime) async {
    try {
      final res = await eventService.requestEarningEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      );
      return List.from(res["data"]["rows"]);
    } catch (e) {
      return [];
    }
  }
}
