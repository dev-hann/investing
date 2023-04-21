import 'package:equatable/equatable.dart';

enum FinancialType {
  annual,
  queartly,
}

class StockFinancial extends Equatable {
  const StockFinancial({
    required this.incomeTable,
    required this.balanceTable,
    required this.cashFlowTable,
    required this.ratiosTable,
  });
  final FinancialTable incomeTable;
  final FinancialTable balanceTable;
  final FinancialTable cashFlowTable;
  final FinancialTable ratiosTable;

  @override
  List<Object?> get props => [
        incomeTable,
        balanceTable,
        cashFlowTable,
        ratiosTable,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'incomeTable': incomeTable.toMap(),
      'balanceTable': balanceTable.toMap(),
      'cashFlowTable': cashFlowTable.toMap(),
      'ratiosTable': ratiosTable.toMap(),
    };
  }

  factory StockFinancial.fromMap(Map<String, dynamic> map) {
    return StockFinancial(
      incomeTable: FinancialTable.fromMap(map['incomeStatementTable']),
      balanceTable: FinancialTable.fromMap(map['balanceSheetTable']),
      cashFlowTable: FinancialTable.fromMap(map['cashFlowTable']),
      ratiosTable: FinancialTable.fromMap(map['financialRatiosTable']),
    );
  }
}

class FinancialTable extends Equatable {
  const FinancialTable({
    required this.headerMap,
    required this.dataList,
  });
  final Map<String, dynamic> headerMap;
  final List<Map<String, dynamic>> dataList;

  @override
  List<Object?> get props => [
        headerMap.hashCode,
        dataList.hashCode,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'headerMap': headerMap,
      'dataList': dataList,
    };
  }

  factory FinancialTable.fromMap(Map<String, dynamic> map) {
    return FinancialTable(
      headerMap: Map<String, dynamic>.from(map['headers']),
      dataList: List.from(map["rows"]),
    );
  }
}
