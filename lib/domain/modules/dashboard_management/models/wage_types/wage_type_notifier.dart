import 'package:project/core/api_client.dart';
import 'package:project/core/api_configurations.dart';
import 'package:project/domain/modules/dashboard_management/models/common/notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/wage_types/wage_type_view.dart';

class WageTypeNotifier extends DashboardManagementFetching<WageTypeView> {
  final ApiClient _apiClient = ApiClient();

  WageTypeNotifier() : super();

  @override
  Future<void> fetchNext(
      {required DashboardManagementEndpointConfiguration
          filterConfiguration}) async {
    if (!isCanFetch || loading) {
      return;
    }

    loading = true;
    notifyListeners();

    final List<WageTypeView> oldList = [...list];
    final DashboardManagementEndpointConfiguration configuration =
        filterConfiguration.copyWith(page: nextPage);
    try {
      dataWithPagination = (await _apiClient.getWageTypes(
        configuration: configuration,
      ));

      final newList = dataWithPagination!.list;

      list = [...oldList, ...newList];

      loading = false;
      currentPage = nextPage;
      notifyListeners();
    } on ApiClientException catch (e) {
      loading = false;
      hasError = true;
      errorMessage = e.message ?? '';
      notifyListeners();
      return;
    }
  }
}
