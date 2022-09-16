import 'package:flutter/material.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/data_providers/json_data_provider.dart';
import 'package:project/domain/models/dashboard_management/company_view.dart';

class CompanyNotifier extends ChangeNotifier {
  bool loading = false;
  List<CompanyView> companiesList = [];
  final page = 1;

  final JsonDataProvider _jsonDataProvider = JsonDataProvider();
  final ApiClient _apiClient = ApiClient();

  CompanyNotifier() {
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    loading = true;
    final List<CompanyView> oldCompaniesList = [...companiesList];
    companiesList = [];
    notifyListeners();

    final CompaniesEndpointConfiguration companiesConfiguration =
        CompaniesEndpointConfiguration(
          page: page
        );

    final companiesWithPagination = (await _apiClient.getCompanies(
      configuration: companiesConfiguration,
    ));


    final newCompaniesList = companiesWithPagination
        .companiesList;

    companiesList = [...oldCompaniesList, ...newCompaniesList];

    loading = false;
    notifyListeners();
  }

  bool get hasData => companiesList.isNotEmpty && loading == false;
}
