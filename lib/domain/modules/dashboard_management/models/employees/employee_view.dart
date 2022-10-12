import 'package:project/domain/modules/dashboard_management/models/data_columns/data_columns.dart';

class EmployeeView extends DataToColumns {
  final double absenceWageSum;
  final int currentStepId;
  final int currentStepMainId;
  final String currentStepName;
  final double difference;
  final double istWageSum;
  final int employeeId;
  final String employeeName;
  final double sollIstDifferencePercentage;
  final double sollWageSum;

  EmployeeView({
    required this.absenceWageSum,
    required this.currentStepId,
    required this.currentStepMainId,
    required this.currentStepName,
    required this.difference,
    required this.istWageSum,
    required this.employeeId,
    required this.employeeName,
    required this.sollIstDifferencePercentage,
    required this.sollWageSum,
  });

  @override
  String get columnTitle => employeeName;

  factory EmployeeView.fromJson(Map<String, dynamic> json) {
    return EmployeeView(
      absenceWageSum: json['absenceWageSum'].toDouble(),
      difference: json['difference'].toDouble(),
      istWageSum: json['istWageSum'].toDouble(),
      sollIstDifferencePercentage: json['sollIstDifferencePercentage'].toDouble(),
      sollWageSum: json['sollWageSum'].toDouble(),
      currentStepId: json['currentStepId'],
      currentStepMainId: json['currentStepMainId'],
      currentStepName: json['currentStepName'],
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['absenceWageSum'] = absenceWageSum;
    data['currentStepId'] = currentStepId;
    data['currentStepName'] = currentStepName;
    data['difference'] = difference;
    data['istWageSum'] = istWageSum;
    data['employeeId'] = employeeId;
    data['employeeName'] = employeeName;
    data['sollIstDifferencePercentage'] = sollIstDifferencePercentage;
    data['sollWageSum'] = sollWageSum;
    data['currentStepMainId'] = currentStepMainId;
    return data;
  }

  @override
  Map<String, String> toColumnNames() {
      final Map<String, String> data = <String, String>{};
      data['employeeName'] = 'Employee Name';
      data['employeeId'] = 'Employee ID';
      data['absenceWageSum'] = 'AbsenceWageSum';
      data['istWageSum'] = 'IstWageSum';
      data['sollWageSum'] = 'SollWageSum';
      data['difference'] = 'Difference';
      data['sollIstDifferencePercentage'] = 'Percentage';
      return data;
  }

}
