import 'package:intl/intl.dart';

class IVDateTimeFormat {
  IVDateTimeFormat(this.dateTime);
  final DateTime dateTime;

  String dateTimeFormat([String format = "yyyy-MM-dd"]) {
    return DateFormat(format).format(dateTime);
  }
}
