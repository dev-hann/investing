part of calendar_event;

class EarningEvent extends CalendarEvent {
  const EarningEvent({
    required this.time,
    required this.symbol,
    required this.name,
    required this.marketCap,
    required this.firscalQuarterEnding,
    required this.epsForecast,
    required this.noOfEsts,
    // not yet
    required this.lastYearRptDt,
    required this.lastYearEPS,
    // opened
    required this.eps,
    required this.surprise,
  }) : super(CalendarEventType.earnings);

  final String time;
  final String symbol;
  final String name;
  final String marketCap;
  final String firscalQuarterEnding;
  final String epsForecast;
  final String noOfEsts;

  // not yet
  final String? lastYearRptDt;
  final String? lastYearEPS;

  // opend
  final String? eps;
  final String? surprise;

  factory EarningEvent.fromMap(Map<String, dynamic> map) {
    return EarningEvent(
      time: map['time'] as String,
      symbol: map['symbol'] as String,
      name: map['name'] as String,
      marketCap: map['marketCap'] as String,
      firscalQuarterEnding: map['fiscalQuarterEnding'] as String,
      epsForecast: map['epsForecast'] as String,
      noOfEsts: map['noOfEsts'] as String,
      lastYearRptDt: map['lastYearRptDt'] as String?,
      lastYearEPS: map['lastYearEPS'] as String?,
      eps: map["eps"] as String?,
      surprise: map["surprice"] as String?,
    );
  }

  @override
  List<Object?> get props => [
        lastYearEPS,
        lastYearRptDt,
        time,
        symbol,
        name,
        marketCap,
        firscalQuarterEnding,
        epsForecast,
        noOfEsts,
        eps,
        surprise,
      ];
}
