import 'package:project/core/api_client.dart';
import 'package:project/core/api_configurations.dart';
import 'package:project/domain/modules/dashboard_management/models/common/notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/payers/payer_view.dart';

class PayerNotifier extends DashboardManagementFetching<PayerView> {
  final ApiClient _apiClient = ApiClient();

  PayerNotifier() : super();

  @override
  Future<void> fetchNext(
      {required DashboardManagementEndpointConfiguration
          filterConfiguration}) async {
    if (!isCanFetch || loading) {
      return;
    }

    loading = true;
    notifyListeners();

    final List<PayerView> oldList = [...list];
    final DashboardManagementEndpointConfiguration configuration =
        filterConfiguration.copyWith(page: nextPage);

    try {
      dataWithPagination = (await _apiClient.getPayers(
        configuration: configuration,
      ));

      final newList = dataWithPagination!.list;

      list = [...oldList, ...newList];

      loading = false;
      currentPage = nextPage;
      notifyListeners();
    } on ApiClientException  catch (e) {
      loading = false;
      hasError = true;
      errorMessage = e.message ?? '';
      notifyListeners();
      return;
    }
  }
}
