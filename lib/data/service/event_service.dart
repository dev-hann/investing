import 'package:flutter/material.dart';
import 'package:investing/data/service/service.dart';

const _eventURL = "https://api.nasdaq.com/api/calendar/";

class EventService extends IVService {
  Future requestEconomicEventList(String dateTime) async {
    try {
      const url = "${_eventURL}economicevents";
      final res = await get(
        url,
        query: {
          "date": dateTime,
        },
      );
      return res.data;
    } catch (e) {
      throw FlutterError(e.toString());
    }
  }

  Future requestDvidendEventList(String dateTime) async {
    try {
      const url = "${_eventURL}dividends";
      final res = await get(
        url,
        query: {
          "date": dateTime,
        },
      );
      return res.data;
    } catch (e) {
      throw FlutterError(e.toString());
    }
  }

  Future requestEarningEventList(String dateTime) async {
    try {
      const url = "${_eventURL}earnings";
      final res = await get(
        url,
        query: {
          "date": dateTime,
        },
      );
      return res.data;
    } catch (e) {
      throw FlutterError(e.toString());
    }
  }
}
