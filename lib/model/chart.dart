import 'package:equatable/equatable.dart';

enum ChartRangeType {
  realTime,
  oneDay,
  oneMonth,
  threeMonth,
  oneYear,
  all,
}

class IVChart extends Comparable<IVChart> with EquatableMixin {
  IVChart(
    this.dateTime,
    this.value,
  );
  final int dateTime;
  final double value;

  @override
  List<Object?> get props => [dateTime, value];

  factory IVChart.fromMap(Map<String, dynamic> map) {
    return IVChart(
      map['x'],
      map['y'],
    );
  }

  @override
  int compareTo(IVChart other) {
    return dateTime.compareTo(other.dateTime);
  }
}
