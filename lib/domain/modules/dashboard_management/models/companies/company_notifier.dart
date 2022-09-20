import 'package:flutter/material.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/companies_pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_view.dart';

class DashboardManagementFetching<T> extends ChangeNotifier {
  bool loading = false;
  int currentPage = 0;
  List<T> list;

  DashboardManagementPagination<T>? dataWithPagination;

  DashboardManagementFetching({this.dataWithPagination})
      : list = dataWithPagination?.list ?? [];

  Future<void> fetchNext() async {}

  bool get hasData => list.isNotEmpty && loading == false;

  int get nextPage => currentPage + 1;

  void resetData() {
    dataWithPagination = null;
    list = [];
    currentPage = 0;
  }
}


class CompanyNotifier extends DashboardManagementFetching<CompanyView> {

  final ApiClient _apiClient = ApiClient();

  CompanyNotifier()
      : super() {
    fetchNext();
  }

  @override
  Future<void> fetchNext() async {
    if (dataWithPagination != null &&
        (dataWithPagination!.page *
            dataWithPagination!.pageSize >=
            dataWithPagination!.totalCount)) {
      return;
    }

    loading = true;
    final List<CompanyView> oldCompaniesList = [...list];
    notifyListeners();

    final CompaniesEndpointConfiguration companiesConfiguration =
        CompaniesEndpointConfiguration(page: nextPage);

    dataWithPagination = (await _apiClient.getCompanies(
      configuration: companiesConfiguration,
    ));

    final newCompaniesList = dataWithPagination!.list;

    list = [...oldCompaniesList, ...newCompaniesList];

    loading = false;
    currentPage = nextPage;
    notifyListeners();
  }
}
