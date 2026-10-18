import 'package:equatable/equatable.dart';

import 'package:investing/util/date_time_format.dart';
import 'package:investing/util/number_format.dart';

class StockDividend extends Equatable {
  const StockDividend({
    required this.annualizedDividend,
    required this.dividendPaymentDate,
    required this.exDividendDate,
    required this.yield,
    required this.histoyList,
  });
  final double annualizedDividend;
  final DateTime? dividendPaymentDate;
  final DateTime? exDividendDate;
  final double yield;
  final List<DividenedHistory> histoyList;

  static DateTime? _dateTime(String value) {
    if (value == 'N/A') {
      return null;
    }
    return IVDateTimeFormat.fromPattern('MM/dd/yyyy', value);
  }

  static double _double(String value) {
    if (value == 'N/A') {
      return 0.0;
    }
    return IVNumberFormat(value).toDouble();
  }

  @override
  List<Object?> get props => [];

  factory StockDividend.fromMap(Map<String, dynamic> map) {
    return StockDividend(
      annualizedDividend: _double(map['annualizedDividend'] as String),
      dividendPaymentDate: _dateTime(map['dividendPaymentDate'] as String),
      exDividendDate: _dateTime(map['exDividendDate'] as String),
      yield: _double(map['yield'] as String),
      histoyList:
          ((map['dividends'] as Map<String, dynamic>)['rows'] as List<dynamic>)
              .map((e) => DividenedHistory.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class DividenedHistory extends Equatable {
  final double amount;
  final String currency;
  final DateTime? declarationDate;
  final DateTime? exOrEffDate;
  final DateTime? paymentDate;
  final DateTime? recordDate;
  final String type;

  const DividenedHistory(
    this.amount,
    this.currency,
    this.declarationDate,
    this.exOrEffDate,
    this.paymentDate,
    this.recordDate,
    this.type,
  );

  @override
  List<Object?> get props => [
    amount,
    currency,
    declarationDate,
    exOrEffDate,
    paymentDate,
    recordDate,
    type,
  ];

  factory DividenedHistory.fromMap(Map<String, dynamic> map) {
    return DividenedHistory(
      StockDividend._double(map['amount'] as String),
      map['currency'] as String,
      StockDividend._dateTime(map['declarationDate'] as String),
      StockDividend._dateTime(map['exOrEffDate'] as String),
      StockDividend._dateTime(map['paymentDate'] as String),
      StockDividend._dateTime(map['recordDate'] as String),
      map['type'] as String,
    );
  }
}
