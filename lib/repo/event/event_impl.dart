part of 'event_repo.dart';

class EventImpl extends EventRepo {
  final EventService eventService = EventService();
  final IVDataBase cacheDB = IVDataBase('EventCache');

  @override
  Future<void> init() async {
    await cacheDB.init();
    return super.init();
  }

  String _cacheKey(String type, DateTime dateTime) {
    final date = IVDateTimeFormat(dateTime).dateTimeFormat();
    return '$type:$date';
  }

  /// Last-known-good rows for the key, parsed with [parse]; empty when absent.
  List<T> _loadCached<T>(String key, T Function(Map<String, dynamic>) parse) {
    final data = cacheDB.read(key);
    if (data is List && data.isNotEmpty) {
      try {
        return List<Map<String, dynamic>>.from(data).map(parse).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  @override
  Future<List<EconomicEvent>> requestEconomicEventList(
    DateTime dateTime,
  ) async {
    final key = _cacheKey('economic', dateTime);
    try {
      final res = await eventService.requestEconomicEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      ) as Map<String, dynamic>;
      final rows =
          ((res['data'] as Map<String, dynamic>)['rows'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
      await cacheDB.put(key: key, value: rows);
      return rows.map(EconomicEvent.fromMap).toList();
    } catch (e) {
      return _loadCached(key, EconomicEvent.fromMap);
    }
  }

  @override
  Future<List<DividendEvent>> requestDividendEventList(
    DateTime dateTime,
  ) async {
    final key = _cacheKey('dividend', dateTime);
    try {
      final res = await eventService.requestDividendEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      ) as Map<String, dynamic>;
      final rows =
          (((res['data'] as Map<String, dynamic>)['calendar']
                      as Map<String, dynamic>)['rows']
                  as List<dynamic>)
              .cast<Map<String, dynamic>>();
      await cacheDB.put(key: key, value: rows);
      return rows.map(DividendEvent.fromMap).toList();
    } catch (e) {
      return _loadCached(key, DividendEvent.fromMap);
    }
  }

  @override
  Future<List<EarningEvent>> requestEarningEventList(DateTime dateTime) async {
    final key = _cacheKey('earning', dateTime);
    try {
      final res = await eventService.requestEarningEventList(
        IVDateTimeFormat(dateTime).dateTimeFormat()!,
      ) as Map<String, dynamic>;
      final rows =
          ((res['data'] as Map<String, dynamic>)['rows'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
      await cacheDB.put(key: key, value: rows);
      return rows.map(EarningEvent.fromMap).toList();
    } catch (e) {
      return _loadCached(key, EarningEvent.fromMap);
    }
  }
}
