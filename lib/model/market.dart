import 'package:equatable/equatable.dart';

abstract class Market<T> extends Equatable {
  const Market(
    this.name,
    this.childeren,
  );
  final String name;
  final List<T> childeren;
  int get sumValue;
  @override
  List<Object> get props => [name, childeren];
}

class MarketData extends Market<MarketSector> {
  const MarketData(
    super.name,
    super.childeren,
  );

  factory MarketData.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return MarketData(
      data["name"],
      List.from(data["children"]).map((e) => MarketSector.fromMap(e)).toList(),
    );
  }

  @override
  int get sumValue => childeren
      .map((e) => e.sumValue)
      .fold(0, (previousValue, element) => previousValue + element);
}

class MarketSector extends Market<MarketItem> {
  const MarketSector(
    super.name,
    super.childeren,
  );

  factory MarketSector.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return MarketSector(
      data["name"],
      List.from(data["children"]).map((e) => MarketItem.fromMap(e)).toList(),
    );
  }

  @override
  int get sumValue => childeren
      .map((e) => e.value)
      .fold(0, (previousValue, element) => previousValue + element);
}

class MarketItem extends Equatable {
  const MarketItem(this.name, this.description, this.value);
  final String name;
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
  List<Object?> get props => [
        name,
        description,
        value,
      ];
}
