part of 'event_repo.dart';

class EventImpl extends EventRepo {
  final EventService eventService = EventService();

  @override
  Future<List<EconomicEvent>> requestEconomicEventList(
    DateTime dateTime,
  ) async {
    try {
      final res = await eventService.requestEconomicEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      ) as Map<String, dynamic>;
      final rows =
          ((res['data'] as Map<String, dynamic>)['rows'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return rows.map(EconomicEvent.fromMap).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DividendEvent>> requestDividendEventList(
    DateTime dateTime,
  ) async {
    try {
      final res = await eventService.requestDividendEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      ) as Map<String, dynamic>;
      final rows =
          (((res['data'] as Map<String, dynamic>)['calendar']
                      as Map<String, dynamic>)['rows']
                  as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return rows.map(DividendEvent.fromMap).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<EarningEvent>> requestEarningEventList(DateTime dateTime) async {
    try {
      final res = await eventService.requestEarningEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      ) as Map<String, dynamic>;
      final rows =
          ((res['data'] as Map<String, dynamic>)['rows'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
      return rows.map(EarningEvent.fromMap).toList();
    } catch (e) {
      return [];
    }
  }
}
