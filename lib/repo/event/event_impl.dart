part of 'event_repo.dart';

class EventImpl extends EventRepo {
  final EventService eventService = EventService();
  @override
  Future<List<dynamic>> requestEconomicEventList(DateTime dateTime) async {
    try {
      final res = await await eventService.requestEconomicEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      ) as Map<String, dynamic>;
      return List<dynamic>.from(
        (res['data'] as Map<String, dynamic>)['rows'] as List<dynamic>,
      );
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<dynamic>> requestDvidendEventList(DateTime dateTime) async {
    try {
      final res = await await eventService.requestDvidendEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      ) as Map<String, dynamic>;
      return List<dynamic>.from(
        ((res['data'] as Map<String, dynamic>)['calendar']
                as Map<String, dynamic>)['rows']
            as List<dynamic>,
      );
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<dynamic>> requestEarningEventList(DateTime dateTime) async {
    try {
      final res = await eventService.requestEarningEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      ) as Map<String, dynamic>;
      return List<dynamic>.from(
        (res['data'] as Map<String, dynamic>)['rows'] as List<dynamic>,
      );
    } catch (e) {
      return [];
    }
  }
}
