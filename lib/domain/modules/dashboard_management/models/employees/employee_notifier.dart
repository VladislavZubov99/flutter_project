import 'package:project/core/api_client.dart';
import 'package:project/core/api_configurations.dart';
import 'package:project/domain/modules/dashboard_management/models/common/notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/employees/employee_view.dart';

class EmployeeNotifier extends DashboardManagementFetching<EmployeeView> {
  final ApiClient _apiClient = ApiClient();

  EmployeeNotifier() : super();

  @override
  Future<void> fetchNext({required DashboardManagementEndpointConfiguration filterConfiguration}) async {
    if (!isCanFetch || loading) {
      return;
    }

    loading = true;
    notifyListeners();

    final List<EmployeeView> oldList = [...list];
    final DashboardManagementEndpointConfiguration configuration = filterConfiguration.copyWith(page: nextPage);

    dataWithPagination = (await _apiClient.getEmployees(
      configuration: configuration,
    ));

    final newList = dataWithPagination!.list;

    list = [...oldList, ...newList];

    loading = false;
    currentPage = nextPage;
    notifyListeners();
  }
}
