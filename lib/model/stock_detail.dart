// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:investing/model/chart.dart';
import 'package:investing/model/stock.dart';

class StockDetail extends Stock {
  StockDetail({
    required super.symbol,
    required super.name,
    required super.asset,
    super.lastSalePrice = 0.0,
    super.netChange = 0.0,
    super.percentChange = 0.0,
    this.priceChartList = const [],
    this.volumeChartList = const [],
    this.previousClosePrice = 0,
  });

  final double previousClosePrice;
  final List<IVChart> priceChartList;
  final List<IVChart> volumeChartList;

  @override
  List<Object?> get props => [
        symbol,
        name,
        asset,
        lastSalePrice,
        netChange,
        percentChange,
        priceChartList.hashCode,
        volumeChartList.hashCode,
      ];

  @override
  StockDetail copyWith({
    String? symbol,
    String? name,
    String? asset,
    double? lastSalePrice,
    double? netChange,
    double? percentChange,
    List<IVChart>? priceChartList,
    List<IVChart>? volumeChartList,
  }) {
    return StockDetail(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      asset: asset ?? this.asset,
      lastSalePrice: lastSalePrice ?? this.lastSalePrice,
      netChange: netChange ?? this.netChange,
      percentChange: percentChange ?? this.percentChange,
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
    );
  }
}
