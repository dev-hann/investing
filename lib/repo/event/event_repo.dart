library event_repo;

import 'package:investing/data/service/event_service.dart';
import 'package:investing/repo/repo.dart';
import 'package:investing/util/date_time_format.dart';
part './event_impl.dart';

abstract class EventRepo extends Repo {
  Future<List> requestEconomicEventList(DateTime dateTime);
  Future<List> requestEarningEventList(DateTime dateTime);
  Future<List> requestDvidendEventList(DateTime dateTime);
}
