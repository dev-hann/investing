import 'dart:convert';

import 'package:investing/data/db/data_base_model_mixin.dart';
import 'package:investing/model/stock.dart';

class Ticker extends Stock with DataBaseModelMixin {
  Ticker({
    required super.name,
    required super.symbol,
    required super.lastSalePrice,
    required super.netChange,
    required super.percentageChange,
    required super.chartList,
    this.dividendYield = 0.0,
  });
  final double dividendYield;

  StockType get type {
    if (name.toLowerCase().contains("etf")) {
      return StockType.etf;
    }
    return StockType.stock;
  }

  String get priceText {
    return double.parse(lastSalePrice).toStringAsFixed(2);
  }

  @override
  List<Object> get props => [
        name,
        symbol,
        lastSalePrice,
        netChange,
        percentageChange,
        chartList.hashCode,
        dividendYield,
      ];

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'symbol': symbol,
      'price': lastSalePrice,
      'dividendYield': dividendYield,
    };
  }

  factory Ticker.fromMap(Map<String, dynamic> map) {
    return Ticker(
      name: map['name'] as String,
      symbol: map['symbol'] as String,
      lastSalePrice: map['lastSalePrice'] as String,
      dividendYield: map['dividendYield'] as double,
      chartList: const [],
      netChange: '',
      percentageChange: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Ticker.fromJson(String source) =>
      Ticker.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Ticker.dto(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return Ticker(
      name: List<String>.from(data['name']).first,
      symbol: List<String>.from(data['symbol']).first,
      lastSalePrice: "0",
      dividendYield: 0,
      chartList: const [],
      netChange: '',
      percentageChange: '',
    );
  }

  @override
  String get index => symbol;
}
