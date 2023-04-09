import 'package:equatable/equatable.dart';

class IVChart extends Comparable<IVChart> with EquatableMixin {
  IVChart(this.x, this.y, this.z);
  final int x;
  final double y;
  final Z z;

  @override
  List<Object?> get props => [x, y, z];

  factory IVChart.fromMap(Map<String, dynamic> map) {
    return IVChart(
      map['x'],
      map['y'],
      Z.fromMap(map['z'] as Map<String, dynamic>),
    );
  }

  @override
  int compareTo(IVChart other) {
    return x.compareTo(other.x);
  }
}

class Z extends Equatable {
  const Z(this.dateTime, this.value);
  final String dateTime;
  final String value;

  @override
  List<Object?> get props => [dateTime, value];

  factory Z.fromMap(Map<String, dynamic> map) {
    return Z(
      map['dateTime'] as String,
      map['value'] as String,
    );
  }
}
