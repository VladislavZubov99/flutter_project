import 'dart:convert';

import 'package:project/domain/modules/dashboard_management/models/common/pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/payers/payer_view.dart';

class PayersWithPagination extends DashboardManagementPagination<PayerView>  {
    bool orderByDesc;
    String sortField;
    List<PayerView> payersList;

    // Pagination({this.currentStepIds, this.dateRange, this.orderByDesc, this.page, this.pageSize, this.sortField, this.totalCount, this.viewModelList});

    PayersWithPagination({
        required this.orderByDesc,
        required this.sortField,
        dateRange,
        page,
        pageSize,
        totalCount,
        currentStepIds,
        required List<PayerView> viewModelList,
    })  : payersList = viewModelList,
            super(
            dateRange: dateRange,
            page: page,
            pageSize: pageSize,
            totalCount: totalCount,
            list: viewModelList,
            currentStepIds: currentStepIds,
        );


    factory PayersWithPagination.fromJson(Map<String, dynamic> json) {
        return PayersWithPagination(
            currentStepIds: List<int>.from(json['currentStepIds']),
            dateRange: List<String>.from(json['dateRange']),
            orderByDesc: json['orderByDesc'],
            page: json['page'], 
            pageSize: json['pageSize'], 
            sortField: json['sortField'], 
            totalCount: json['totalCount'],
            viewModelList: (json['viewModelList'] as List)
                .map((i) => PayerView.fromJson(i))
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
        data['viewModelList'] = payersList.map((v) => v.toJson()).toList();
        return data;
    }

    @override
    String toString() {
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final jsonObject = toJson();
        return encoder.convert(jsonObject);
    }
}