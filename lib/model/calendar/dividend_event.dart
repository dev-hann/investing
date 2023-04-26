part of calendar_event;

class DividendEvent extends CalendarEvent {
  const DividendEvent({
    required this.companyName,
    required this.symbol,
    required this.dividendExDateTime,
    required this.paymentDateTime,
    required this.recordDateTime,
    required this.dividendRate,
    required this.indicatedAnnualDividend,
    required this.announcementDateTime,
  }) : super(CalendarEventType.dividends);
  final String companyName;
  final String symbol;
  final String dividendExDateTime;
  final String paymentDateTime;
  final String recordDateTime;
  final double dividendRate;
  final double indicatedAnnualDividend;
  final String announcementDateTime;

  factory DividendEvent.fromMap(Map<String, dynamic> map) {
    return DividendEvent(
      companyName: map['companyName'] as String,
      symbol: map['symbol'] as String,
      dividendExDateTime: map['dividend_Ex_Date'] as String,
      paymentDateTime: map['payment_Date'] as String,
      recordDateTime: map['record_Date'] as String,
      dividendRate: map['dividend_Rate'] as double,
      indicatedAnnualDividend: map['indicated_Annual_Dividend'] as double,
      announcementDateTime: map['announcement_Date'] as String,
    );
  }

  @override
  List<Object?> get props => [
        companyName,
        symbol,
        dividendExDateTime,
        paymentDateTime,
        recordDateTime,
        dividendRate,
        indicatedAnnualDividend,
        announcementDateTime,
      ];
}
