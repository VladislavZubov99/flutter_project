import 'package:project/core/api_client.dart';
import 'package:project/core/api_configurations.dart';
import 'package:project/domain/modules/dashboard_management/models/common/notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_view.dart';

class CompanyNotifier extends DashboardManagementFetching<CompanyView> {
  final ApiClient _apiClient = ApiClient();

  CompanyNotifier() : super() {
    final DashboardManagementEndpointConfiguration filterConfiguration =
        DashboardManagementEndpointConfiguration(
      filterLists: FilterListsConfiguration(),
    );
    fetchNext(filterConfiguration: filterConfiguration);
  }

  @override
  Future<void> fetchNext(
      {required DashboardManagementEndpointConfiguration
          filterConfiguration}) async {
    if (!isCanFetch || loading) {
      return;
    }

    loading = true;
    final List<CompanyView> oldCompaniesList = [...list];
    notifyListeners();

    final DashboardManagementEndpointConfiguration configuration =
        filterConfiguration.copyWith(page: nextPage);

    try {
      dataWithPagination = (await _apiClient.getCompanies(
        configuration: configuration,
      ));


      final newCompaniesList = dataWithPagination!.list;

      list = [...oldCompaniesList, ...newCompaniesList];

      loading = false;
      currentPage = nextPage;
      notifyListeners();

    } on ApiClientException catch(e) {
      loading = false;
      hasError = true;
      errorMessage = e.message ?? '';
      notifyListeners();
      return;
    }
  }
}
