import 'dart:convert';

import 'package:project/domain/modules/dashboard_management/models/common/pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_view.dart';

class CompaniesWithPagination
    extends DashboardManagementPagination<CompanyView> {
  List<CompanyView> companiesList;

  CompaniesWithPagination({
    dateRange,
    page,
    pageSize,
    totalCount,
    currentStepIds,
    required List<CompanyView> viewModelList,
  })  : companiesList = viewModelList,
        super(
          dateRange: dateRange,
          page: page,
          pageSize: pageSize,
          totalCount: totalCount,
          list: viewModelList,
          currentStepIds: currentStepIds,
        );

  factory CompaniesWithPagination.fromJson(Map<String, dynamic> json) {
    return CompaniesWithPagination(
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
