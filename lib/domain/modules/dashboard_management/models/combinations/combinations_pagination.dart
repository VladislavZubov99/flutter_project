import 'dart:convert';

import 'package:project/domain/modules/dashboard_management/models/common/pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/combinations/combination_view.dart';

class CombinationsWithPagination extends DashboardManagementPagination<CombinationView>  {
    bool orderByDesc;
    String sortField;
    List<CombinationView> combinationsList;

    // Pagination({this.currentStepIds, this.dateRange, this.orderByDesc, this.page, this.pageSize, this.sortField, this.totalCount, this.viewModelList});

    CombinationsWithPagination({
        required this.orderByDesc,
        required this.sortField,
        dateRange,
        page,
        pageSize,
        totalCount,
        currentStepIds,
        required List<CombinationView> viewModelList,
    })  : combinationsList = viewModelList,
            super(
            dateRange: dateRange,
            page: page,
            pageSize: pageSize,
            totalCount: totalCount,
            list: viewModelList,
            currentStepIds: currentStepIds,
        );


    factory CombinationsWithPagination.fromJson(Map<String, dynamic> json) {
        return CombinationsWithPagination(
            currentStepIds: List<int>.from(json['currentStepIds']),
            dateRange: List<String>.from(json['dateRange']),
            orderByDesc: json['orderByDesc'],
            page: json['page'], 
            pageSize: json['pageSize'], 
            sortField: json['sortField'], 
            totalCount: json['totalCount'],
            viewModelList: (json['viewModelList'] as List)
                .map((i) => CombinationView.fromJson(i))
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
        data['viewModelList'] = combinationsList.map((v) => v.toJson()).toList();
        return data;
    }

    @override
    String toString() {
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final jsonObject = toJson();
        return encoder.convert(jsonObject);
    }
}