// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:investing/model/chart.dart';
import 'package:investing/model/stock.dart';

class StockDetail extends Stock {
  const StockDetail({
    required super.symbol,
    required super.name,
    required super.lastSalePrice,
    required super.previousSalePrice,
    required super.netChange,
    required super.percentageChange,
    required super.deltaIndicator,
    required super.asset,
    this.priceChartList = const [],
    this.volumeChartList = const [],
    this.previousClosePrice = 0,
  });

  final double previousClosePrice;
  final List<IVChart> priceChartList;
  final List<IVChart> volumeChartList;

  @override
  List<Object?> get props => [
        priceChartList.hashCode,
        volumeChartList.hashCode,
      ];

  @override
  StockDetail copyWith({
    String? symbol,
    String? name,
    double? lastSalePrice,
    double? previousSalePrice,
    String? netChange,
    String? percentageChange,
    String? deltaIndicator,
    String? asset,
    double? previousClosePrice,
    List<IVChart>? priceChartList,
    List<IVChart>? volumeChartList,
  }) {
    return StockDetail(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      lastSalePrice: lastSalePrice ?? this.lastSalePrice,
      previousSalePrice: previousSalePrice ?? this.previousSalePrice,
      netChange: netChange ?? this.netChange,
      percentageChange: percentageChange ?? this.percentageChange,
      deltaIndicator: deltaIndicator ?? this.deltaIndicator,
      asset: asset ?? this.asset,
      previousClosePrice: previousClosePrice ?? this.previousClosePrice,
      priceChartList: priceChartList ?? this.priceChartList,
      volumeChartList: volumeChartList ?? this.volumeChartList,
    );
  }

  factory StockDetail.fromStock(Stock stock) {
    return StockDetail(
      symbol: stock.symbol,
      name: stock.name,
      asset: stock.asset,
      lastSalePrice: 0,
      previousSalePrice: 0,
      netChange: "",
      percentageChange: "",
      deltaIndicator: "",
    );
  }
}
