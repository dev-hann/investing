import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/repo/event/event_repo.dart';
import 'package:investing/use_case/use_case.dart';

class EventUseCase extends UseCase<EventRepo> {
  EventUseCase(super.repo);

  Future<List<EconomicEvent>> requestEconomicEventList(
      DateTime dateTime) async {
    final res = await repo.requestEconomicEventList(dateTime);
    return List.from(res).map((e) => EconomicEvent.fromMap(e)).toList();
  }

  Future<List<EarningEvent>> requestEarningEventList(DateTime dateTime) async {
    final res = await repo.requestEarningEventList(dateTime);
    return List.from(res).map((e) => EarningEvent.fromMap(e)).toList();
  }

  Future<List<DividendEvent>> requestDvidendEventList(DateTime dateTime) async {
    final res = await repo.requestDvidendEventList(dateTime);
    return List.from(res).map((e) => DividendEvent.fromMap(e)).toList();
  }
}
