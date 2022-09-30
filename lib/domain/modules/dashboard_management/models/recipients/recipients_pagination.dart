import 'dart:convert';

import 'package:project/domain/modules/dashboard_management/models/common/pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/recipients/recipient_view.dart';

class RecipientsWithPagination extends DashboardManagementPagination<RecipientView>  {
    bool orderByDesc;
    String sortField;
    List<RecipientView> recipientsList;

    // Pagination({this.currentStepIds, this.dateRange, this.orderByDesc, this.page, this.pageSize, this.sortField, this.totalCount, this.viewModelList});

    RecipientsWithPagination({
        required this.orderByDesc,
        required this.sortField,
        dateRange,
        page,
        pageSize,
        totalCount,
        currentStepIds,
        required List<RecipientView> viewModelList,
    })  : recipientsList = viewModelList,
            super(
            dateRange: dateRange,
            page: page,
            pageSize: pageSize,
            totalCount: totalCount,
            list: viewModelList,
            currentStepIds: currentStepIds,
        );


    factory RecipientsWithPagination.fromJson(Map<String, dynamic> json) {
        return RecipientsWithPagination(
            currentStepIds: List<int>.from(json['currentStepIds']),
            dateRange: List<String>.from(json['dateRange']),
            orderByDesc: json['orderByDesc'],
            page: json['page'], 
            pageSize: json['pageSize'], 
            sortField: json['sortField'], 
            totalCount: json['totalCount'],
            viewModelList: (json['viewModelList'] as List)
                .map((i) => RecipientView.fromJson(i))
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
        data['viewModelList'] = recipientsList.map((v) => v.toJson()).toList();
        return data;
    }

    @override
    String toString() {
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final jsonObject = toJson();
        return encoder.convert(jsonObject);
    }
}