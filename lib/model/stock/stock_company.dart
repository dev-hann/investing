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
    String valueOf(String key) {
      return (map[key] as Map<String, dynamic>)['value'] as String;
    }

    return StockCompany(
      valueOf('CompanyName'),
      valueOf('Symbol'),
      valueOf('Address'),
      valueOf('Industry'),
      valueOf('Sector'),
      valueOf('Region'),
      valueOf('CompanyDescription'),
    );
  }
}
