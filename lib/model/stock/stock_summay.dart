import 'package:equatable/equatable.dart';

class StockSummary extends Equatable {
  const StockSummary(
    this.todayHighLowPrice,
    this.shareVolume,
    this.day20AvgVolume,
    this.day50AvgVolume,
    this.day65AvgVolume,
    this.previousClosePrice,
    this.fiftyTwoWeekHighLowPrice,
    this.marketCap,
    this.annualizedDividend,
    this.exDividendDate,
    this.dividendPayDate,
    this.currentYield,
    this.beta,
  );
  final String todayHighLowPrice;
  final String shareVolume;
  final String day20AvgVolume;
  final String day50AvgVolume;
  final String day65AvgVolume;
  final String previousClosePrice;
  final String fiftyTwoWeekHighLowPrice;
  final String marketCap;
  final String annualizedDividend;
  final String exDividendDate;
  final String dividendPayDate;
  final String currentYield;
  final String beta;

  @override
  List<Object?> get props => [
        todayHighLowPrice,
        shareVolume,
        day20AvgVolume,
        day50AvgVolume,
        day65AvgVolume,
        previousClosePrice,
        fiftyTwoWeekHighLowPrice,
        marketCap,
        annualizedDividend,
        exDividendDate,
        dividendPayDate,
        currentYield,
        beta,
      ];

  factory StockSummary.fromMap(Map<String, dynamic> map) {
    return StockSummary(
      map['TodayHighLow']["value"] as String,
      map['ShareVolume']["value"] as String,
      map['AvgDailyVol20Days']["value"] as String,
      map['FiftyDayAvgDailyVol']["value"] as String,
      map['AvgDailyVol65Days']["value"] as String,
      map['PreviousClose']["value"] as String,
      map['FiftTwoWeekHighLow']["value"] as String,
      map['MarketCap']["value"] as String,
      map['annualizedDividend']["value"] as String,
      map['exDividendDate']["value"] as String,
      map['dividendPayDate']["value"] as String,
      map['currentYield']["value"] as String,
      map['beta']["value"] as String,
    );
  }
}
