library;

import 'package:investing/data/service/event_service.dart';
import 'package:investing/repo/repo.dart';
import 'package:investing/util/date_time_format.dart';
part './event_impl.dart';

abstract class EventRepo extends Repo {
  Future<List<dynamic>> requestEconomicEventList(DateTime dateTime);
  Future<List<dynamic>> requestEarningEventList(DateTime dateTime);
  Future<List<dynamic>> requestDvidendEventList(DateTime dateTime);
}
