import 'dart:convert';

import 'package:project/domain/modules/dashboard_management/models/common/pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/employees/employee_view.dart';

class EmployeesWithPagination extends DashboardManagementPagination<EmployeeView>  {
    bool orderByDesc;
    String sortField;
    List<EmployeeView> employeesList;

    EmployeesWithPagination({
        required this.orderByDesc,
        required this.sortField,
        dateRange,
        page,
        pageSize,
        totalCount,
        currentStepIds,
        required List<EmployeeView> viewModelList,
    })  : employeesList = viewModelList,
            super(
            dateRange: dateRange,
            page: page,
            pageSize: pageSize,
            totalCount: totalCount,
            list: viewModelList,
            currentStepIds: currentStepIds,
        );


    factory EmployeesWithPagination.fromJson(Map<String, dynamic> json) {
        return EmployeesWithPagination(
            currentStepIds: List<int>.from(json['currentStepIds']),
            dateRange: List<String>.from(json['dateRange']),
            orderByDesc: json['orderByDesc'],
            page: json['page'], 
            pageSize: json['pageSize'], 
            sortField: json['sortField'], 
            totalCount: json['totalCount'],
            viewModelList: (json['viewModelList'] as List)
                .map((i) => EmployeeView.fromJson(i))
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
        data['viewModelList'] = employeesList.map((v) => v.toJson()).toList();
        return data;
    }

    @override
    String toString() {
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final jsonObject = toJson();
        return encoder.convert(jsonObject);
    }
}