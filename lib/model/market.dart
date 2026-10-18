import 'package:equatable/equatable.dart';

/// Market movers categories served by the Nasdaq screener endpoint.
enum MarketMoverCategory { advancers, decliners, actives }

abstract class Market<T> extends Equatable {
  const Market(this.name, this.childeren);
  final String name;
  final List<T> childeren;
  int get sumValue;
  @override
  List<Object> get props => [name, childeren];
}

class MarketData extends Market<MarketSector> {
  const MarketData(super.name, super.childeren);

  factory MarketData.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map as Map<dynamic, dynamic>);
    return MarketData(
      data['name'] as String,
      (data['children'] as List<dynamic>).map(MarketSector.fromMap).toList(),
    );
  }

  @override
  int get sumValue => childeren
      .map((e) => e.sumValue)
      .fold(0, (previousValue, element) => previousValue + element);
}

class MarketSector extends Market<MarketItem> {
  const MarketSector(super.name, super.childeren);

  factory MarketSector.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map as Map<dynamic, dynamic>);
    return MarketSector(
      data['name'] as String,
      (data['children'] as List<dynamic>)
          .map((e) => MarketItem.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  int get sumValue => childeren
      .map((e) => e.value)
      .fold(0, (previousValue, element) => previousValue + element);
}

class MarketItem extends Market<Never> {
  MarketItem(String name, this.description, this.value) : super(name, []);
  final String description;
  final int value;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'value': value,
    };
  }

  factory MarketItem.fromMap(Map<String, dynamic> map) {
    return MarketItem(
      map['name'] as String,
      map['description'] as String,
      map['value'] as int,
    );
  }

  @override
  int get sumValue => value;
}
