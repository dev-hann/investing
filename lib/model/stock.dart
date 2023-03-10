// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dividends_manager/data/db/data_base_model.dart';
import 'package:equatable/equatable.dart';

class Stock extends DataBaseModel with EquatableMixin, Comparable<Stock> {
  const Stock({
    required super.index,
    required this.name,
    required this.tickerID,
  });
  final String name;
  final String tickerID;

  @override
  List<Object> get props => [index, name, tickerID];

  Stock copyWith({
    String? index,
    String? name,
    String? tickerID,
  }) {
    return Stock(
      index: index ?? this.index,
      name: name ?? this.name,
      tickerID: tickerID ?? this.tickerID,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'name': name,
      'tickerID': tickerID,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      index: map['index'] as String,
      name: map['name'] as String,
      tickerID: map['tickerID'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Stock.fromJson(String source) =>
      Stock.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  int compareTo(Stock other) {
    return index.compareTo(other.index);
  }
}
