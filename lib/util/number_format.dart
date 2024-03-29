import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IVNumberFormat {
  IVNumberFormat(this.number);
  final String? number;

  double toDouble() {
    if (number == null) {
      return 0.0;
    }
    return double.tryParse(
          number!.replaceAll(RegExp("[,\$%]"), ""),
        ) ??
        0.0;
  }

  static String priceFormat(
    double price, {
    int decimalDigits = 2,
  }) {
    return NumberFormat.simpleCurrency(decimalDigits: decimalDigits)
        .format(price);
  }

  static String indexFormat(double value) {
    return NumberFormat.currency(symbol: "").format(value);
  }
}
