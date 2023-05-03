import 'package:equatable/equatable.dart';
import 'package:investing/util/date_time_format.dart';

const _marketDateTimeFormat = "MMM dd, yyyy HH:mm a";

enum MarketStatusType {
  pre,
  regular,
  after,
}

class MarketStatus extends Equatable {
  const MarketStatus({
    required this.preMarketOpen,
    required this.preMarketClose,
    required this.marketOpen,
    required this.afterHourMarketOpen,
    required this.afterHourMarketClose,
    this.isBusinessDay = true,
    this.status = "",
  });

  final DateTime preMarketOpen;
  final DateTime preMarketClose;
  final DateTime marketOpen;
  final DateTime afterHourMarketOpen;
  final DateTime afterHourMarketClose;
  final bool isBusinessDay;
  final String status;

  bool get isOpened => !status.toLowerCase().contains("close");

  MarketStatusType get type => MarketStatusType.pre;

  static DateTime _dateTime(String text) {
    // Convert US time to TW time.
    return IVDateTimeFormat.fromPattern(_marketDateTimeFormat, text).add(
      const Duration(hours: 12),
    );
  }

  @override
  List<Object?> get props => [
        preMarketOpen,
        preMarketClose,
        marketOpen,
        afterHourMarketOpen,
        afterHourMarketClose,
        isBusinessDay,
        status,
        // for Test
        DateTime.now(),
      ];

  factory MarketStatus.fromMap(Map<String, dynamic> map) {
    final data = Map<String, dynamic>.from(map)["data"];
    return MarketStatus(
      preMarketOpen: _dateTime(data['preMarketOpeningTime']),
      preMarketClose: _dateTime(data['preMarketClosingTime']),
      marketOpen: _dateTime(data['marketOpeningTime']),
      afterHourMarketOpen: _dateTime(data['afterHoursMarketOpeningTime']),
      afterHourMarketClose: _dateTime(data['afterHoursMarketClosingTime']),
      isBusinessDay: data['isBusinessDay'] as bool,
      status: data['mrktStatus'] as String,
    );
  }
}
