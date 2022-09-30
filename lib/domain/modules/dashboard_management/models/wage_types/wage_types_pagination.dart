import 'dart:convert';

import 'package:project/domain/modules/dashboard_management/models/common/pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/wage_types/wage_type_view.dart';

class WageTypesWithPagination extends DashboardManagementPagination<WageTypeView>  {
    bool orderByDesc;
    String sortField;
    List<WageTypeView> wageTypesList;

    WageTypesWithPagination({
        required this.orderByDesc,
        required this.sortField,
        dateRange,
        page,
        pageSize,
        totalCount,
        currentStepIds,
        required List<WageTypeView> viewModelList,
    })  : wageTypesList = viewModelList,
            super(
            dateRange: dateRange,
            page: page,
            pageSize: pageSize,
            totalCount: totalCount,
            list: viewModelList,
            currentStepIds: currentStepIds,
        );


    factory WageTypesWithPagination.fromJson(Map<String, dynamic> json) {
        return WageTypesWithPagination(
            currentStepIds: List<int>.from(json['currentStepIds']),
            dateRange: List<String>.from(json['dateRange']),
            orderByDesc: json['orderByDesc'],
            page: json['page'], 
            pageSize: json['pageSize'], 
            sortField: json['sortField'], 
            totalCount: json['totalCount'],
            viewModelList: (json['viewModelList'] as List)
                .map((i) => WageTypeView.fromJson(i))
                .toList(),
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['orderByDesc'] = orderByDesc;
        data['page'] = page;
        data['pageSize'] = pageSize;
        data['sortField'] = sortField;
        data['totalCount'] = totalCount;
        data['currentStepIds'] = currentStepIds;
        data['dateRange'] = dateRange;
        data['viewModelList'] = wageTypesList.map((v) => v.toJson()).toList();
        return data;
    }

    @override
    String toString() {
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final jsonObject = toJson();
        return encoder.convert(jsonObject);
    }
}