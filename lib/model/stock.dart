import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:dividends_manager/data/db/data_base_model.dart';

enum StockType {
  etf,
  common,
}

extension StockTypeExtension on String {
  StockType _toStockType() {
    if (toLowerCase() == "etf") {
      return StockType.etf;
    } else {
      return StockType.common;
    }
  }
}

class Stock extends DataBaseModel with EquatableMixin, Comparable<Stock> {
  const Stock({
    required this.name,
    required this.symbol,
    required this.count,
    required this.price,
    required this.dividendYield,
    required this.stockTypeIndex,
  }) : super(index: symbol);
  final String name;
  final String symbol;
  final int price;
  final int count;
  final double dividendYield;
  final int stockTypeIndex;

  StockType get type => StockType.values[stockTypeIndex];

  @override
  List<Object> get props => [
        name,
        symbol,
        price,
        count,
        dividendYield,
        stockTypeIndex,
      ];

  @override
  int compareTo(Stock other) {
    return index.compareTo(other.index);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'symbol': symbol,
      'price': price,
      'count': count,
      'dividendYield': dividendYield,
      'stockTypeIndex': stockTypeIndex,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      name: map['name'] as String,
      symbol: map['symbol'] as String,
      price: map['price'] as int,
      count: map['count'] as int,
      dividendYield: map['dividendYield'] as double,
      stockTypeIndex: map['stockTypeIndex'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Stock.fromJson(String source) =>
      Stock.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Stock.dto(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return Stock(
      name: List<String>.from(data['name']).first,
      symbol: List<String>.from(data['symbol']).first,
      price: 0,
      count: 0,
      dividendYield: 0,
      stockTypeIndex: data["asset"].toString()._toStockType().index,
    );
  }
}
