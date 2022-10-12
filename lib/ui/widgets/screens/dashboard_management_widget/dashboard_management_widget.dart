import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:project/core/api_configurations.dart';
import 'package:project/domain/modules/dashboard_management/models/combinations/combination_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/common/notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/employees/employee_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/payers/payer_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/recipients/recipient_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/wage_types/wage_type_notifier.dart';
import 'package:project/domain/modules/dashboard_management/state_machine/dashboard_management_notifier.dart';
import 'package:project/domain/modules/dashboard_management/step_controller/dashboard_management_step_controller.dart';
import 'package:project/resources/resources.dart';
import 'package:project/ui/app_settings/app_colors.dart';
import 'package:project/ui/app_settings/app_space.dart';
import 'package:project/ui/widgets/custom_scroll_view_widget/custom_scroll_view_widget.dart';
import 'package:project/ui/widgets/dashboard_management/dashboard_management_header_widget/dashboard_management_header_widget.dart';
import 'package:project/ui/widgets/dashboard_management/expandable_data_widget/expandable_data_widget.dart';
import 'package:project/domain/models/expand_notifier.dart';
import 'package:project/ui/widgets/dashboard_management/filters_widget/filters_widget.dart';
import 'package:project/ui/widgets/slivers/sticky_persistent_header.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:project/ui/widgets/navigation_drawer/navigation_drawer.dart';

class DashboardManagementWidget extends StatefulWidget {
  const DashboardManagementWidget({Key? key}) : super(key: key);

  @override
  State<DashboardManagementWidget> createState() =>
      _DashboardManagementWidgetState();
}

class EndpointConfigurationController extends ChangeNotifier {
  DashboardManagementEndpointConfiguration endpointConfiguration =
      DashboardManagementEndpointConfiguration(
          filterLists: FilterListsConfiguration());

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
    notifyListeners();
  }
}

class _DashboardManagementWidgetState extends State<DashboardManagementWidget> {
  DashboardManagementStepController? stepController;

  final ExpandableController expandableController = ExpandableController();
  final EndpointConfigurationController endpointConfigurationController =
      EndpointConfigurationController();

  @override
  void initState() {
    // TODO: implement initState
    endpointConfigurationController.addListener(() {
      print(endpointConfigurationController.endpointConfiguration.dateRange);
    });

    super.initState();
  }

  onUpdateFilers({
    int? pageSize,
    String? sortField,
    bool? orderByDesc,
    List<String>? dateRange,
  }) {
    setState(() {
      endpointConfigurationController.updateEndpointConfiguration(
        sortField: sortField,
        orderByDesc: orderByDesc,
        dateRange: dateRange,
        pageSize: pageSize,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        return SafeArea(
          top: true,
          child: Scaffold(
            drawer: const NavigationDrawer(),
            endDrawer: Drawer(
                width: width * 0.8,
                child: Center(
                  child: Column(
                    children: [
                      FiltersWidget(
                        initialFilters: endpointConfigurationController
                            .endpointConfiguration,
                        onUpdateFilers: onUpdateFilers,
                      )
                    ],
                  ),
                )),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(Provider.of<DashboardManagementMachineNotifier>(
                      context,
                      listen: true)
                  .currentStep),
            ),
            body: Stack(
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpace.padding),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.backgroundWave),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Consumer<DashboardManagementMachineNotifier>(
                    builder: (_, machine, __) {
                  return Consumer6<
                      CompanyNotifier,
                      RecipientNotifier,
                      PayerNotifier,
                      CombinationNotifier,
                      EmployeeNotifier,
                      WageTypeNotifier>(
                    builder: (
                      _,
                      companiesModel,
                      recipientsModel,
                      payersModel,
                      combinationsModel,
                      employeesModel,
                      wageTypesModel,
                      __,
                    ) {
                      stepController ??= DashboardManagementStepController(
                        machine: machine,
                        companiesModel: companiesModel,
                        recipientsModel: recipientsModel,
                        payersModel: payersModel,
                        combinationsModel: combinationsModel,
                        employeesModel: employeesModel,
                        wageTypesModel: wageTypesModel,
                      );

                      stepController!.setViewModelByStep();

                      final DashboardManagementFetching viewModel =
                          stepController!.currentViewModel;

                      if (stepController!.endpointConfiguration !=
                          endpointConfigurationController
                              .endpointConfiguration) {
                        stepController!.updateEndpointConfiguration(
                            configuration: endpointConfigurationController
                                .endpointConfiguration);
                      }

                      Future.delayed(Duration.zero, () async {
                        final expandNotifier = context.read<ExpandNotifier>();

                        machine.addListener(() {
                          if (expandNotifier.initialExpandedValue) {
                            expandNotifier.setAllExpanded();
                          } else {
                            expandNotifier.setAllCollapsed();
                          }
                        });

                        final indexes = List.generate(
                            viewModel.list.length, (index) => index);
                        expandNotifier.initExpandableElements(indexes);
                      });

                      return CustomScrollViewWithScrollFetch(
                        onEndScroll: () {
                          stepController!.fetchNextByStep();
                        },
                        slivers: [
                          StickyPersistentHeader(
                            size: Size.fromHeight(sx(180)),
                            child: DashboardManagementHeader(
                              viewModel: viewModel,
                              expandableController: expandableController,
                              machine: machine,
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Consumer<ExpandNotifier>(
                                    builder: (_, expandNotifier, __) {
                                  return ExpandableDataViewWidget(
                                      dataInfo: viewModel.list[index],
                                      onCheck: viewModel.addIdToList,
                                      onRemoveCheck: viewModel.removeIdFromList,
                                      isCheckedId: viewModel.isCheckedId,
                                      isExpanded:
                                          expandNotifier.isExpanded(index),
                                      onChangeExpand: () {
                                        expandNotifier
                                            .onChangeExpandable(index);
                                      });
                                });
                              },
                              childCount: viewModel.list.length,
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(AppSpace.padding),
                            sliver: SliverToBoxAdapter(
                              child: Builder(
                                builder: (BuildContext context) {
                                  if (viewModel.hasError) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text('Error'),
                                            SizedBox(
                                              width: sx(100),
                                              height: sx(40),
                                              child: TextButton(
                                                  onPressed: () {
                                                    viewModel.clearError();
                                                  },
                                                  child:
                                                      const Text('Try again')),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: sx(AppSpace.padding)),
                                        Text(viewModel.errorMessage),
                                      ],
                                    );
                                  }

                                  if (viewModel.loading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (!viewModel.hasData) {
                                    return const Text('No data');
                                  } else if (viewModel.isCanFetch) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: sx(200),
                                          height: sx(40),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                stepController!
                                                    .fetchNextByStep();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
                                              ),
                                              child:
                                                  const Text('Load more...')),
                                        ),
                                      ],
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
