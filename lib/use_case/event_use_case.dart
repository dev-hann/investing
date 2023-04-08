import 'package:investing/repo/event/event_repo.dart';
import 'package:investing/use_case/use_case.dart';

class EventUseCase extends UseCase<EventRepo> {
  EventUseCase(super.repo);

  Future<List> requestEconomicEventList(DateTime dateTime) {
    return repo.requestEconomicEventList(dateTime);
  }

  Future<List> requestEarningEventList(DateTime dateTime) {
    return repo.requestEarningEventList(dateTime);
  }

  Future<List> requestDvidendEventList(DateTime dateTime) {
    return repo.requestDvidendEventList(dateTime);
  }
}
