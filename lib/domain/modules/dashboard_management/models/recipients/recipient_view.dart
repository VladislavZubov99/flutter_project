import 'package:project/domain/modules/dashboard_management/models/data_columns/data_columns.dart';

class RecipientView extends DataToColumns {
  final double absenceWageSum;
  final int currentStepId;
  final double? currentStepMainId;
  final String currentStepName;
  final double difference;
  final double istWageSum;
  final int recipientId;
  final String recipientName;
  final double sollIstDifferencePercentage;
  final double sollWageSum;

  RecipientView({
    required this.absenceWageSum,
    required this.currentStepId,
    required this.currentStepMainId,
    required this.currentStepName,
    required this.difference,
    required this.istWageSum,
    required this.recipientId,
    required this.recipientName,
    required this.sollIstDifferencePercentage,
    required this.sollWageSum,
  });

  @override
  String get columnTitle => recipientName;

  factory RecipientView.fromJson(Map<String, dynamic> json) {
    return RecipientView(
      absenceWageSum: json['absenceWageSum'],
      currentStepId: json['currentStepId'],
      currentStepMainId: json['currentStepMainId'],
      currentStepName: json['currentStepName'],
      difference: json['difference'],
      istWageSum: json['istWageSum'],
      recipientId: json['recipientId'],
      recipientName: json['recipientName'],
      sollIstDifferencePercentage: json['sollIstDifferencePercentage'],
      sollWageSum: json['sollWageSum'],
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
    data['recipientId'] = recipientId;
    data['recipientName'] = recipientName;
    data['sollIstDifferencePercentage'] = sollIstDifferencePercentage;
    data['sollWageSum'] = sollWageSum;
    data['currentStepMainId'] = currentStepMainId;
    return data;
  }

  @override
  Map<String, String> toColumnNames() {
      final Map<String, String> data = <String, String>{};
      data['recipientName'] = 'Recipient Name';
      data['recipientId'] = 'Recipient ID';
      data['absenceWageSum'] = 'AbsenceWageSum';
      data['istWageSum'] = 'IstWageSum';
      data['sollWageSum'] = 'SollWageSum';
      data['difference'] = 'Difference';
      data['sollIstDifferencePercentage'] = 'Percentage';
      return data;
  }


}
