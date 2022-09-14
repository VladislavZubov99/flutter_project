import 'package:flutter/material.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/data_providers/json_data_provider.dart';
import 'package:project/domain/models/dashboard_management/company_view.dart';

class CompanyNotifier extends ChangeNotifier {
  bool loading = false;
  List<CompanyView> companiesList = [];

  final JsonDataProvider _jsonDataProvider = JsonDataProvider();
  final ApiClient _apiClient = ApiClient();

  CompanyNotifier() {
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    loading = true;
    companiesList = [];
    notifyListeners();

    companiesList = (await _apiClient.getCompanies()).companiesList;
    // await Future.delayed(const Duration(seconds: 1));

    // companyViewList = [
    //   CompanyView(
    //     absenceWageSum: 600,
    //     companyId: 1,
    //     companyName: 'Test Name',
    //     difference: 0,
    //     istWageSum: 600,
    //     sollIstDifferencePersentage: 0,
    //     sollWageSum: 600,
    //   ),
    //   CompanyView(
    //     absenceWageSum: 600,
    //     companyId: 2,
    //     companyName: 'Test Name 2',
    //     difference: 0,
    //     istWageSum: 600,
    //     sollIstDifferencePersentage: 0,
    //     sollWageSum: 600,
    //   ),
    //   CompanyView(
    //     absenceWageSum: 600,
    //     companyId: 3,
    //     companyName: 'Test Name 3',
    //     difference: 0,
    //     istWageSum: 600,
    //     sollIstDifferencePersentage: 0,
    //     sollWageSum: 600,
    //   ),
    // ];

    loading = false;
    notifyListeners();
  }

  bool get hasData => companiesList.isNotEmpty && loading == false;
}
