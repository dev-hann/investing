import 'package:equatable/equatable.dart';

class Dividend extends Equatable {
  const Dividend({
    required this.yieldRatio,
    required this.exDateTime,
    required this.paymentDateTime,
    required this.annualDividend,
  });
  final double yieldRatio;
  final DateTime exDateTime;
  final DateTime paymentDateTime;
  final double annualDividend;

  @override
  List<Object?> get props => [
        yieldRatio,
        exDateTime,
        paymentDateTime,
        annualDividend,
      ];
}
