import 'package:equatable/equatable.dart';

class Index extends Equatable {
  const Index({
    required this.symbol,
    required this.name,
    required this.lastSalePrice,
    required this.netChange,
    required this.percentageChange,
  });
  final String symbol;
  final String name;
  final String lastSalePrice;
  final String netChange;
  final String percentageChange;

  @override
  List<Object?> get props => [
        symbol,
        name,
        lastSalePrice,
        netChange,
        percentageChange,
      ];

  factory Index.majorIndex(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return Index(
      symbol: data["symbol"],
      name: data["companyName"],
      lastSalePrice: data["lastSalePrice"],
      netChange: data["netChange"],
      percentageChange: data["percentageChange"],
    );
  }

  factory Index.fixedIncome(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    final primaryData = data["primaryData"];
    return Index(
      symbol: data["symbol"],
      name: data["companyName"],
      lastSalePrice: primaryData["lastSalePrice"],
      netChange: primaryData["netChange"],
      percentageChange: primaryData["percentageChange"],
    );
  }

  factory Index.commodity(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    final primaryData = data["primaryData"];
    return Index(
      symbol: data["symbol"],
      name: data["companyName"],
      lastSalePrice: primaryData["lastSalePrice"],
      netChange: primaryData["netChange"],
      percentageChange: primaryData["percentageChange"],
    );
  }
}
