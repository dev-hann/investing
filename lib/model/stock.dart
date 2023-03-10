import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:dividends_manager/data/db/data_base_model.dart';

class Stock extends DataBaseModel with EquatableMixin, Comparable<Stock> {
  const Stock({
    required super.index,
    required this.name,
    required this.tickerID,
    required this.count,
    required this.price,
    required this.dividendYield,
  });
  final String name;
  final String tickerID;
  final int price;
  final int count;
  final double dividendYield;

  @override
  List<Object> get props => [
        index,
        name,
        tickerID,
        price,
        count,
        dividendYield,
      ];

  @override
  int compareTo(Stock other) {
    return index.compareTo(other.index);
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'name': name,
      'tickerID': tickerID,
      'price': price,
      'count': count,
      'dividendYield': dividendYield,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      index: map["index"],
      name: map['name'] as String,
      tickerID: map['tickerID'] as String,
      price: map['price'] as int,
      count: map['count'] as int,
      dividendYield: map['dividendYield'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Stock.fromJson(String source) =>
      Stock.fromMap(json.decode(source) as Map<String, dynamic>);
}
