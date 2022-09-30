import 'package:project/core/api_configurations.dart';
import 'package:project/domain/modules/dashboard_management/models/combinations/combination_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/common/notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/employees/employee_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/payers/payer_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/recipients/recipient_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/wage_types/wage_type_notifier.dart';
import 'package:project/domain/modules/dashboard_management/state_machine/dashboard_management_machine.dart';
import 'package:project/domain/modules/dashboard_management/state_machine/dashboard_management_notifier.dart';

class DashboardManagementStepController {
  final Map<String, List<int>> selectedStepIds = {
    DashboardManagementMachineStates.company.name: [],
    DashboardManagementMachineStates.recipient.name: [],
    DashboardManagementMachineStates.payer.name: [],
    DashboardManagementMachineStates.combination.name: [],
    DashboardManagementMachineStates.employee.name: [],
    DashboardManagementMachineStates.wageType.name: [],
  };

  final DashboardManagementMachineNotifier machine;
  final CompanyNotifier companiesModel;
  final RecipientNotifier recipientsModel;
  final PayerNotifier payersModel;
  final CombinationNotifier combinationsModel;
  final EmployeeNotifier employeesModel;
  final WageTypeNotifier wageTypesModel;

  late DashboardManagementFetching currentViewModel;

  final FilterListsConfiguration filter = FilterListsConfiguration();
  DashboardManagementEndpointConfiguration endpointConfiguration =
  DashboardManagementEndpointConfiguration(
      filterLists: FilterListsConfiguration());

  DashboardManagementStepController({
    required this.machine,
    required this.companiesModel,
    required this.recipientsModel,
    required this.payersModel,
    required this.combinationsModel,
    required this.employeesModel,
    required this.wageTypesModel,
  }) {
    currentViewModel = companiesModel;
  }

  setViewModelByStep() {
    switch (machine.currentStepState) {
      case DashboardManagementMachineStates.company:
        currentViewModel = companiesModel;
        break;
      case DashboardManagementMachineStates.recipient:
        currentViewModel = recipientsModel;
        if (!currentViewModel.hasData) {
          filter.companyIds = companiesModel.idsList;
        }
        break;
      case DashboardManagementMachineStates.payer:
        currentViewModel = payersModel;
        if (!currentViewModel.hasData) {
          filter.recipientIds = recipientsModel.idsList;
        }
        break;
      case DashboardManagementMachineStates.combination:
        currentViewModel = combinationsModel;
        if (!currentViewModel.hasData) {
          filter.payerIds = payersModel.idsList;
        }
        break;
      case DashboardManagementMachineStates.employee:
        currentViewModel = employeesModel;
        if (!currentViewModel.hasData) {
          filter.combinationIds = combinationsModel.idsList;
        }
        break;
      case DashboardManagementMachineStates.wageType:
        currentViewModel = wageTypesModel;
        if (!currentViewModel.hasData) {
          filter.employeeIds = employeesModel.idsList;
        }
        break;
    }
    _updateEndpointConfiguration();
    if (!currentViewModel.hasData) {
      fetchByIdsList();
    }
  }

  _updateEndpointConfiguration() {
    endpointConfiguration = endpointConfiguration.copyWith(filterLists: filter);
  }

  fetchByIdsList() {
    Future.delayed(Duration.zero, () async {
      currentViewModel.fetchNext(
        filterConfiguration: endpointConfiguration,
      );
    });
  }

  fetchNextByStep() {
    fetchByIdsList();
  }

  updateEndpointConfiguration({
    int? pageSize,
    String? sortField,
    bool? orderByDesc,
    List<String>? dateRange,
  }) {
    endpointConfiguration = endpointConfiguration.copyWith(
      pageSize: pageSize,
      sortField: sortField,
      orderByDesc: orderByDesc,
      dateRange: dateRange,
    );
    currentViewModel.resetData();
    fetchByIdsList();
  }
}
