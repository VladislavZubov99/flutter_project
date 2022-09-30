import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:project/domain/modules/dashboard_management/models/combinations/combination_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/common/notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/data_columns/data_columns.dart';
import 'package:project/domain/modules/dashboard_management/models/employees/employee_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/payers/payer_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/recipients/recipient_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/wage_types/wage_type_notifier.dart';
import 'package:project/domain/modules/dashboard_management/state_machine/dashboard_management_notifier.dart';
import 'package:project/domain/modules/dashboard_management/step_controller/dashboard_management_step_controller.dart';
import 'package:project/resources/resources.dart';
import 'package:project/ui/app_settings/app_colors.dart';
import 'package:project/ui/app_settings/app_space.dart';
import 'package:project/ui/widgets/custom_checkbox/custom_checkbox.dart';
import 'package:project/ui/widgets/screens/dashborad_management/ckeck_all_widget.dart';
import 'package:project/ui/widgets/screens/dashborad_management/expand_notifier.dart';
import 'package:project/ui/widgets/slivers/sticky_persistent_header.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

class DashboardManagementWidget extends StatefulWidget {
  const DashboardManagementWidget({Key? key}) : super(key: key);

  @override
  State<DashboardManagementWidget> createState() =>
      _DashboardManagementWidgetState();
}

class _DashboardManagementWidgetState extends State<DashboardManagementWidget> {
  final ExpandableController expandableController = ExpandableController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CompanyNotifier>(
            create: (_) => CompanyNotifier()),
        ChangeNotifierProvider<RecipientNotifier>(
            create: (_) => RecipientNotifier()),
        ChangeNotifierProvider<PayerNotifier>(create: (_) => PayerNotifier()),
        ChangeNotifierProvider<CombinationNotifier>(
            create: (_) => CombinationNotifier()),
        ChangeNotifierProvider<EmployeeNotifier>(
            create: (_) => EmployeeNotifier()),
        ChangeNotifierProvider<WageTypeNotifier>(
            create: (_) => WageTypeNotifier()),
        ChangeNotifierProvider<DashboardManagementMachineNotifier>(
            create: (_) => DashboardManagementMachineNotifier()),
        ChangeNotifierProvider<ExpandNotifier>(create: (_) => ExpandNotifier())
      ],
      child: RelativeBuilder(
        builder: (context, height, width, sy, sx) {
          return SafeArea(
            top: true,
            child: Scaffold(
              endDrawer: Drawer(
                  child: Center(
                child: Column(
                  children: const <Widget>[Text('End Drawer')],
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
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpace.padding),
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
                        final stepController =
                            DashboardManagementStepController(
                          machine: machine,
                          companiesModel: companiesModel,
                          recipientsModel: recipientsModel,
                          payersModel: payersModel,
                          combinationsModel: combinationsModel,
                          employeesModel: employeesModel,
                          wageTypesModel: wageTypesModel,
                        );

                        stepController.setViewModelByStep();

                        final DashboardManagementFetching viewModel =
                            stepController.currentViewModel;

                        Future.delayed(Duration.zero, () async {
                          final _expandNotifier =
                              context.read<ExpandNotifier>();

                          machine.addListener(() {
                            if (_expandNotifier.initialExpandedValue) {
                              _expandNotifier.setAllExpanded();
                            } else {
                              _expandNotifier.setAllCollapsed();
                            }
                          });

                          final indexes = List.generate(
                              viewModel.list.length, (index) => index);
                          _expandNotifier.initExpandableElements(indexes);
                        });

                        return CustomScrollViewWithScrollFetch(
                          onEndScroll: () {
                            stepController.fetchNextByStep();
                          },
                          slivers: [
                            StickyPersistentHeader(
                              size: Size.fromHeight(sx(120)),
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
                                        onRemoveCheck:
                                            viewModel.removeIdFromList,
                                        isCheckedId: viewModel.isCheckedId,
                                        isExpanded:
                                            expandNotifier.isExpanded(index),
                                        onChangeExpand: () {
                                          print('onchange');

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
                                                  stepController
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
      ),
    );
  }
}

class DashboardManagementHeader extends StatefulWidget {
  final DashboardManagementFetching viewModel;
  final ExpandableController expandableController;
  final DashboardManagementMachineNotifier machine;

  const DashboardManagementHeader({
    Key? key,
    required this.viewModel,
    required this.expandableController,
    required this.machine,
  }) : super(key: key);

  @override
  State<DashboardManagementHeader> createState() =>
      _DashboardManagementHeaderState();
}

class _DashboardManagementHeaderState extends State<DashboardManagementHeader> {
  bool? isChecked;

  onStepChange() {
    setState(() {
      isChecked = false;
    });
  }

  onCheckAll() {
    setState(() {
      isChecked = true;
      widget.viewModel.addAllIdsList();
    });
  }
  onRemoveFromCheckAll() {
    setState(() {
      isChecked = false;
      widget.viewModel.removeAllIdsList();
    });
  }

  @override
  void initState() {
    widget.machine.addListener(onStepChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.machine.removeListener(onStepChange);
    widget.machine.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Container(
        padding: EdgeInsets.all(sx(AppSpace.padding)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(sx(AppSpace.borderRadius)),
            bottomRight: Radius.circular(sx(AppSpace.borderRadius)),
          )
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: sx(120),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (widget.expandableController.expanded) {
                            widget.expandableController.value = false;
                            context
                                .read<ExpandNotifier>()
                                .setInitialExpandedValue(
                                    widget.expandableController.expanded);
                            context.read<ExpandNotifier>().setAllCollapsed();
                          } else {
                            widget.expandableController.value = true;
                            context
                                .read<ExpandNotifier>()
                                .setInitialExpandedValue(
                                    widget.expandableController.expanded);
                            context.read<ExpandNotifier>().setAllExpanded();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: Text(widget.expandableController.expanded
                          ? 'Collapse All'
                          : 'Expand All')),
                ),
                SizedBox(width: sx(10)),
                CheckAllWidget(
                  isChecked: isChecked,
                  onCheckAll: onCheckAll,
                  onRemoveFromCheckAll: onRemoveFromCheckAll,
                ),
                const Text('Select All'),
              ],
            ),
            SizedBox(height: sx(AppSpace.padding)),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                      onPressed: widget.machine.isFirstStep
                          ? null
                          : () {
                              widget.machine.toBackStep();

                              if (widget.viewModel is! CompanyNotifier) {
                                widget.viewModel.resetData();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Prev')),
                ),
                SizedBox(width: sx(10)),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                      onPressed: widget.machine.isLastStep
                          ? null
                          : () {
                              widget.machine.toNextStep();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Next')),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: sx(AppSpace.padding)),
                  child: Text(
                      'Total: ${widget.viewModel.list.isNotEmpty ? widget.viewModel.list.length : '-'} of ${widget.viewModel.dataWithPagination?.totalCount != 0 ? widget.viewModel.dataWithPagination?.totalCount.toString() ?? '-' : '-'}'),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}

class CustomScrollViewWithScrollFetch extends StatefulWidget {
  final List<Widget> slivers;
  final void Function() onEndScroll;

  static void _initialEndScroll() {}

  const CustomScrollViewWithScrollFetch({
    Key? key,
    required this.slivers,
    this.onEndScroll = _initialEndScroll,
  }) : super(key: key);

  @override
  State<CustomScrollViewWithScrollFetch> createState() =>
      _CustomScrollViewWithScrollFetchState();
}

class _CustomScrollViewWithScrollFetchState
    extends State<CustomScrollViewWithScrollFetch> {
  final ScrollController _controller = ScrollController();

  void _onScrollEvent() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
      print('_onScrollEvent');
      widget.onEndScroll();
      // fetchNextPage();
    }
  }

  @override
  void initState() {
    _controller.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollEvent);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: widget.slivers,
    );
  }
}

class ExpandableDataViewWidget extends StatefulWidget {
  final DataToColumns dataInfo;
  final void Function() onChangeExpand;
  final void Function(int id) onCheck;
  final void Function(int id) onRemoveCheck;
  final bool Function(int id) isCheckedId;
  final bool isExpanded;

  const ExpandableDataViewWidget({
    super.key,
    required this.dataInfo,
    required this.onCheck,
    required this.onRemoveCheck,
    required this.isCheckedId,
    required this.onChangeExpand,
    required this.isExpanded,
  });

  @override
  State<ExpandableDataViewWidget> createState() =>
      _ExpandableDataViewWidgetState();
}

class _ExpandableDataViewWidgetState extends State<ExpandableDataViewWidget> {
  final ExpandableController innerExpandableController = ExpandableController();

  setExpand() {
    innerExpandableController.value = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final currentData = widget.dataInfo;
    final ColumnDataList columnInfo = ColumnDataList(currentData);

    if (columnInfo.id == null) return Container();

    Future.delayed(Duration.zero, () async {
      setExpand();
    });

    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return ExpandableNotifier(
          initialExpanded: true,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sx(AppSpace.borderRadius)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                ExpandablePanel(
                  controller: innerExpandableController,
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                    tapHeaderToExpand: true,
                    hasIcon: true,
                  ),
                  header: InkWell(
                    onTap: widget.onChangeExpand,
                    child: Padding(
                      padding: EdgeInsets.all(sx(AppSpace.padding)),
                      child: Row(
                        children: [
                          CustomCheckbox(
                            value: widget.isCheckedId(columnInfo.id),
                            onChangeCallback: (bool isChecked) {
                              if (isChecked) {
                                widget.onCheck(columnInfo.id);
                              } else {
                                widget.onRemoveCheck(columnInfo.id);
                              }
                            },
                          ),
                          SizedBox(width: sx(AppSpace.padding)),
                          Flexible(
                            child: Text(
                              columnInfo.title,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  collapsed: Container(),
                  expanded: _buildMobileTable(columnInfo.list),
                ),
              ],
            ),
          ));
    });
  }

  _buildMobileTable(List<ColumnData> columns) {
    return Column(
      children: columns
          .asMap()
          .entries
          .map((entry) => Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: entry.key % 2 != 0
                      ? AppColors.primary.withOpacity(0.7)
                      : AppColors.primary.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.value.name,
                      style: TextStyle(
                        color: entry.key % 2 != 0 ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      entry.value.value,
                      style: TextStyle(
                        color: entry.key % 2 != 0 ? Colors.white : Colors.black,
                      ),
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
