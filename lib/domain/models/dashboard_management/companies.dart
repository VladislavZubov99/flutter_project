import 'dart:convert';

import 'package:project/domain/models/dashboard_management/company_view.dart';

class Companies {
  List<int> currentStepIds;
  List<String> dateRange;
  int page;
  int pageSize;
  int totalCount;
  List<CompanyView> companiesList;

  Companies(
      {required this.currentStepIds,
      required this.dateRange,
      required this.page,
      required this.pageSize,
      required this.totalCount,
      required List<CompanyView> viewModelList})
      : companiesList = viewModelList;

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(
      currentStepIds: List<int>.from(json['currentStepIds']),
      dateRange: List<String>.from(json['dateRange']),
      page: json['page'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      viewModelList: (json['viewModelList'] as List)
          .map((i) => CompanyView.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['currentStepIds'] = currentStepIds;
    data['dateRange'] = dateRange;
    data['viewModelList'] = companiesList.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final jsonObject = toJson();
    return encoder.convert(jsonObject);
  }
}
