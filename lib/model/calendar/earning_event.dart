part of calendar_event;

class EarningEvent extends CalendarEvent {
  const EarningEvent({
    required this.lastYearRptDt,
    required this.lastYearEPS,
    required this.time,
    required this.symbol,
    required this.name,
    required this.marketCap,
    required this.fiscalQuarterEnding,
    required this.epsForecast,
    required this.noOfEsts,
  }) : super(CalendarEventType.earnings);

  final String lastYearRptDt;
  final String lastYearEPS;
  final String time;
  final String symbol;
  final String name;
  final String marketCap;
  final String fiscalQuarterEnding;
  final String epsForecast;
  final String noOfEsts;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lastYearRptDt': lastYearRptDt,
      'lastYearEPS': lastYearEPS,
      'time': time,
      'symbol': symbol,
      'name': name,
      'marketCap': marketCap,
      'fiscalQuarterEnding': fiscalQuarterEnding,
      'epsForecast': epsForecast,
      'noOfEsts': noOfEsts,
    };
  }

  factory EarningEvent.fromMap(Map<String, dynamic> map) {
    return EarningEvent(
      lastYearRptDt: map['lastYearRptDt'] as String,
      lastYearEPS: map['lastYearEPS'] as String,
      time: map['time'] as String,
      symbol: map['symbol'] as String,
      name: map['name'] as String,
      marketCap: map['marketCap'] as String,
      fiscalQuarterEnding: map['fiscalQuarterEnding'] as String,
      epsForecast: map['epsForecast'] as String,
      noOfEsts: map['noOfEsts'] as String,
    );
  }
}