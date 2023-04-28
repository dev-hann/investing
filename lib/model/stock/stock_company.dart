import 'package:equatable/equatable.dart';

class StockCompany extends Equatable {
  const StockCompany(
    this.name,
    this.symbol,
    this.address,
    this.industry,
    this.sector,
    this.region,
    this.description,
  );
  final String name;
  final String symbol;
  final String address;
  final String industry;
  final String sector;
  final String region;
  final String description;

  @override
  List<Object?> get props => [
        name,
        symbol,
        address,
        industry,
        sector,
        region,
        description,
      ];

  factory StockCompany.fromMap(Map<String, dynamic> map) {
    return StockCompany(
      map['CompanyName']["value"] as String,
      map['Symbol']["value"] as String,
      map['Address']["value"] as String,
      map['Industry']["value"] as String,
      map['Sector']["value"] as String,
      map['Region']["value"] as String,
      map['CompanyDescription']["value"] as String,
    );
  }
}
