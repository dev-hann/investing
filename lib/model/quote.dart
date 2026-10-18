import 'package:equatable/equatable.dart';

/// Real-time quote from the Alpaca stream.
///
/// [price] is the mid of bid/ask when both sides are present,
/// otherwise whichever side exists.
class Quote extends Equatable {
  const Quote({required this.symbol, required this.price});

  final String symbol;
  final double price;

  /// Returns `null` when the payload has no symbol or no usable price.
  static Quote? tryFromMap(Map<String, dynamic> map) {
    final symbol = map['S'] as String?;
    final ask = (map['ap'] as num?)?.toDouble();
    final bid = (map['bp'] as num?)?.toDouble();
    if (symbol == null || (ask == null && bid == null)) {
      return null;
    }
    final double price;
    if (ask != null && bid != null) {
      price = (ask + bid) / 2;
    } else {
      price = (ask ?? bid)!;
    }
    return Quote(symbol: symbol, price: price);
  }

  @override
  List<Object?> get props => [symbol, price];
}
