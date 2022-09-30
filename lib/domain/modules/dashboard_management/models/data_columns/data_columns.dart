import 'dart:convert';

import 'package:project/domain/modules/dashboard_management/models/combinations/combination_view.dart';
import 'package:project/domain/modules/dashboard_management/models/employees/employee_view.dart';
import 'package:project/domain/modules/dashboard_management/models/payers/payer_view.dart';
import 'package:project/domain/modules/dashboard_management/models/recipients/recipient_view.dart';
import 'package:project/domain/modules/dashboard_management/models/wage_types/wage_type_view.dart';

import '../companies/company_view.dart';

class DataToColumns {
  Map<String, dynamic> toJson() => {};

  Map<String, String> toColumnNames() => {};

  String get columnTitle => '';

  @override
  String toString() {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final jsonObject = toJson();
    return encoder.convert(jsonObject);
  }
}

class ColumnData {
  final String key;
  final String value;
  final String name;

  const ColumnData({
    required this.key,
    required this.value,
    required this.name,
  });
}

class ColumnDataList {
  final DataToColumns entry;

  // ColumnDataList.company(CompanyView this.entry) {
  //   id = (entry as CompanyView).companyId;
  // }
  //
  // ColumnDataList.recipient(RecipientView this.entry) {
  //   id = (entry as RecipientView).recipientId;
  // }
  //
  // ColumnDataList.payer(PayerView this.entry) {
  //   id = (entry as PayerView).payerId;
  // }

  ColumnDataList(this.entry);

  get id {
    final columnEntry = entry;
    if(columnEntry is CompanyView) return columnEntry.companyId;
    if(columnEntry is RecipientView) return columnEntry.recipientId;
    if(columnEntry is PayerView) return columnEntry.payerId;
    if(columnEntry is CombinationView) return columnEntry.combinationId;
    if(columnEntry is EmployeeView) return columnEntry.employeeId;
    if(columnEntry is WageTypeView) return columnEntry.wageTypeId;
  }

  List<ColumnData> get list => entry
      .toColumnNames()
      .entries
      .map((e) => ColumnData(
    key: e.key,
    value: entry.toJson()[e.key].toString(),
    name: e.value,
  ))
      .toList();

  get title => entry.columnTitle;
}
