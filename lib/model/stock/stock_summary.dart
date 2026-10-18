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
    String valueOf(String key) {
      return (map[key] as Map<String, dynamic>)['value'] as String;
    }

    return StockSummary(
      valueOf('TodayHighLow'),
      valueOf('ShareVolume'),
      valueOf('AvgDailyVol20Days'),
      valueOf('FiftyDayAvgDailyVol'),
      valueOf('AvgDailyVol65Days'),
      valueOf('PreviousClose'),
      valueOf('FiftTwoWeekHighLow'),
      valueOf('MarketCap'),
      valueOf('annualizedDividend'),
      valueOf('exDividendDate'),
      valueOf('dividendPayDate'),
      valueOf('currentYield'),
      valueOf('beta'),
    );
  }
}
