import 'package:intl/intl.dart';

class IVNumberFormat {
  IVNumberFormat(this.number);
  final String number;

  double toDouble() {
    return double.tryParse(number.replaceAll(",", "").replaceAll("\$", "")) ??
        0.0;
  }

  static String priceFormat(double price) {
    return NumberFormat.simpleCurrency().format(price);
  }
}
