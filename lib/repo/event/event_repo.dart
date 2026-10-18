library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/data/service/event_service.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/repo/repo.dart';
import 'package:investing/util/date_time_format.dart';
part './event_impl.dart';

abstract class EventRepo extends Repo {
  Future<List<EconomicEvent>> requestEconomicEventList(DateTime dateTime);
  Future<List<EarningEvent>> requestEarningEventList(DateTime dateTime);
  Future<List<DividendEvent>> requestDividendEventList(DateTime dateTime);
}

final eventRepoProvider = Provider<EventRepo>((ref) => EventImpl());
