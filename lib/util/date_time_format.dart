import 'package:intl/intl.dart';

class IVDateTimeFormat {
  IVDateTimeFormat(this.dateTime);
  final DateTime? dateTime;

  String? dateTimeFormat([String format = "yyyy-MM-dd"]) {
    if (dateTime == null) {
      return null;
    }
    return DateFormat(format).format(dateTime!);
  }

  static DateTime fromPattern(String pattern, String value) {
    return DateFormat(pattern).parse(value);
  }
}
