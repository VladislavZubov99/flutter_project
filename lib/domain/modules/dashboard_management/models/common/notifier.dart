import 'package:flutter/material.dart';
import 'package:project/core/api_configurations.dart';
import 'package:project/domain/modules/dashboard_management/models/common/pagination.dart';

class DashboardManagementFetching<T> extends ChangeNotifier {
  List<int> idsList = [];
  bool loading = false;
  int currentPage = 0;
  List<T> list;

  DashboardManagementPagination<T>? dataWithPagination;

  DashboardManagementFetching({this.dataWithPagination})
      : list = dataWithPagination?.list ?? [];

  Future<void> fetchNext({required DashboardManagementEndpointConfiguration filterConfiguration}) async {}

  bool get hasData => list.isNotEmpty && loading == false;

  int get nextPage => currentPage + 1;

  void addIdToList(int id) {
    if (dataWithPagination == null) {
      return;
    } else if (dataWithPagination!.list.isEmpty) {
      return;
    }

    idsList.add(id);

    //remove duplicates
    idsList = idsList.toSet().toList();
    notifyListeners();
  }

  void removeIdFromList(int id) {
    if (dataWithPagination == null) {
      return;
    } else if (dataWithPagination!.list.isEmpty) {
      return;
    }

    idsList.remove(id);
    notifyListeners();
  }

  void addAllIdsList() {
    if (dataWithPagination == null) {
      return;
    }

    idsList.replaceRange(0, idsList.length, dataWithPagination!.currentStepIds);
    notifyListeners();
  }

  void removeAllIdsList() {
    idsList = [];
    notifyListeners();
  }

  bool isCheckedId(int id) {
    return idsList.contains(id);
  }

  bool get isCanFetch {
    if (dataWithPagination != null &&
        (dataWithPagination!.page * dataWithPagination!.pageSize >=
            dataWithPagination!.totalCount)) {
      return false;
    } else {
      return true;
    }
  }

  void resetData() {
    dataWithPagination = null;
    list = [];
    idsList = [];
    currentPage = 0;
  }
}
