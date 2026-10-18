import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/repo/event/event_repo.dart';
import 'package:investing/use_case/use_case.dart';

class EventUseCase extends UseCase<EventRepo> {
  EventUseCase(super.repo);

  Future<List<EconomicEvent>> requestEconomicEventList(DateTime dateTime) {
    return repo.requestEconomicEventList(dateTime);
  }

  Future<List<EarningEvent>> requestEarningEventList(DateTime dateTime) {
    return repo.requestEarningEventList(dateTime);
  }

  Future<List<DividendEvent>> requestDividendEventList(DateTime dateTime) {
    return repo.requestDividendEventList(dateTime);
  }
}

final eventUseCaseProvider = Provider(
  (ref) => EventUseCase(ref.watch(eventRepoProvider)),
);
