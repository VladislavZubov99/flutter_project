import 'package:project/domain/modules/dashboard_management/models/data_columns/data_columns.dart';

class PayerView extends DataToColumns {
  final double absenceWageSum;
  final int currentStepId;
  final int currentStepMainId;
  final String currentStepName;
  final double difference;
  final double istWageSum;
  final int payerId;
  final String payerName;
  final double sollIstDifferencePercentage;
  final double sollWageSum;

  PayerView({
    required this.absenceWageSum,
    required this.currentStepId,
    required this.currentStepMainId,
    required this.currentStepName,
    required this.difference,
    required this.istWageSum,
    required this.payerId,
    required this.payerName,
    required this.sollIstDifferencePercentage,
    required this.sollWageSum,
  });

  @override
  String get columnTitle => payerName;

  factory PayerView.fromJson(Map<String, dynamic> json) {
    return PayerView(
      payerId: json['payerId'],
      payerName: json['payerName'],
      currentStepId: json['currentStepId'],
      currentStepMainId: json['currentStepMainId'],
      currentStepName: json['currentStepName'],
      absenceWageSum: json['absenceWageSum'].toDouble(),
      difference: json['difference'].toDouble(),
      istWageSum: json['istWageSum'].toDouble(),
      sollIstDifferencePercentage: json['sollIstDifferencePercentage'].toDouble(),
      sollWageSum: json['sollWageSum'].toDouble(),
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
    data['payerId'] = payerId;
    data['payerName'] = payerName;
    data['sollIstDifferencePercentage'] = sollIstDifferencePercentage;
    data['sollWageSum'] = sollWageSum;
    data['currentStepMainId'] = currentStepMainId;
    return data;
  }

  @override
  Map<String, String> toColumnNames() {
      final Map<String, String> data = <String, String>{};
      data['payerName'] = 'Payer Name';
      data['payerId'] = 'Payer ID';
      data['absenceWageSum'] = 'AbsenceWageSum';
      data['istWageSum'] = 'IstWageSum';
      data['sollWageSum'] = 'SollWageSum';
      data['difference'] = 'Difference';
      data['sollIstDifferencePercentage'] = 'Percentage';
      return data;
  }


}
