import 'package:project/domain/modules/dashboard_management/models/data_columns/data_columns.dart';


class CompanyView extends DataToColumns {
  double absenceWageSum;
  int companyId;
  String companyName;
  double difference;
  double istWageSum;
  double sollIstDifferencePercentage;
  double sollWageSum;

  CompanyView({
    required this.absenceWageSum,
    required this.companyId,
    required this.companyName,
    required this.difference,
    required this.istWageSum,
    required this.sollIstDifferencePercentage,
    required this.sollWageSum,
  });

  @override
  String get columnTitle => companyName;

  factory CompanyView.fromJson(Map<String, dynamic> json) {
    return CompanyView(
      absenceWageSum: json['absenceWageSum'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      difference: json['difference'],
      istWageSum: json['istWageSum'],
      sollIstDifferencePercentage: json['sollIstDifferencePercentage'],
      sollWageSum: json['sollWageSum'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['absenceWageSum'] = absenceWageSum;
    data['companyId'] = companyId;
    data['companyName'] = companyName;
    data['difference'] = difference;
    data['istWageSum'] = istWageSum;
    data['sollIstDifferencePercentage'] = sollIstDifferencePercentage;
    data['sollWageSum'] = sollWageSum;
    return data;
  }



  CompanyView copyWith({
    double? absenceWageSum,
    int? companyId,
    String? companyName,
    double? difference,
    double? istWageSum,
    double? sollIstDifferencePercentage,
    double? sollWageSum,
  }) {
    return CompanyView(
      absenceWageSum: absenceWageSum ?? this.absenceWageSum,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      difference: difference ?? this.difference,
      istWageSum: istWageSum ?? this.istWageSum,
      sollIstDifferencePercentage:
          sollIstDifferencePercentage ?? this.sollIstDifferencePercentage,
      sollWageSum: sollWageSum ?? this.sollWageSum,
    );
  }

  @override
  Map<String, String> toColumnNames() {
    final Map<String, String> data = <String, String>{};
    data['companyName'] = 'Company Name';
    data['companyId'] = 'Company ID';
    data['absenceWageSum'] = 'AbsenceWageSum';
    data['istWageSum'] = 'IstWageSum';
    data['sollWageSum'] = 'SollWageSum';
    data['difference'] = 'Difference';
    data['sollIstDifferencePercentage'] = 'Percentage';
    return data;
  }



}

