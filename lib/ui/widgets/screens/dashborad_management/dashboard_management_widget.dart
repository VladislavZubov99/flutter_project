import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_view.dart';
import 'package:project/domain/modules/dashboard_management/state_machine/dashboard_management_notifier.dart';
import 'package:project/resources/resources.dart';
import 'package:project/ui/app_settings/app_colors.dart';
import 'package:project/ui/app_settings/app_space.dart';
import 'package:project/ui/widgets/custom_checkbox/custom_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

class DashboardManagementWidget extends StatefulWidget {
  const DashboardManagementWidget({Key? key}) : super(key: key);

  @override
  State<DashboardManagementWidget> createState() =>
      _DashboardManagementWidgetState();
}

class _DashboardManagementWidgetState extends State<DashboardManagementWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CompanyNotifier>(
            create: (_) => CompanyNotifier()),
        ChangeNotifierProvider<DashboardManagementMachineNotifier>(
            create: (_) => DashboardManagementMachineNotifier()),
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
                title: const Text('Dashboard Management'),
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
                  Consumer2<CompanyNotifier, CompanyNotifier>(
                    builder: (_, companiesModel,  recipientsModel, __) {
                      return CustomScrollViewWithScrollFetch(
                        onEndScroll: () {
                          Provider.of<CompanyNotifier>(context, listen: false).fetchNext();
                        },
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(AppSpace.padding),
                            sliver: SliverToBoxAdapter(
                              child:
                                  Consumer<DashboardManagementMachineNotifier>(
                                builder: (_, machine, __) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                            ),
                                            child: const Text('Load data')),
                                      ),
                                      SizedBox(width: sx(10)),
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                            onPressed: machine.isFirstStep
                                                ? null
                                                : () {
                                                    machine.toBackStep();
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                            ),
                                            child: const Text('Prev')),
                                      ),
                                      SizedBox(width: sx(10)),
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                            onPressed: machine.isLastStep
                                                ? null
                                                : () {
                                                    machine.toNextStep();
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                            ),
                                            child: const Text('Next')),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: sx(AppSpace.padding)),
                                        child: Text(machine.currentStep.name),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ExpandableDataViewWidget(
                                  dataInfo: companiesModel.list[index],
                                );
                              },
                              childCount: companiesModel.list.length,
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(AppSpace.padding),
                            sliver: SliverToBoxAdapter(
                              child: Builder(
                                builder: (BuildContext context) {
                                  if (companiesModel.loading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (!companiesModel.hasData) {
                                    return const Text('No data');
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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

  void fetchNextPage() {
    Provider.of<CompanyNotifier>(context, listen: false).fetchNext();

    // final nextPage =
    //     Provider.of<CompanyNotifier>(context, listen: false).nextPage;
    //
    // Provider.of<CompanyNotifier>(context, listen: false)
    //     .fetchCompanies(page: nextPage);
  }

  void _onScrollEvent() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
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

class ExpandableDataViewWidget extends StatelessWidget {
  final DataToColumns dataInfo;

  const ExpandableDataViewWidget({super.key, required this.dataInfo});

  @override
  Widget build(BuildContext context) {
    final currentData = dataInfo;
    ColumnDataList? columnInfo;

    if (currentData is CompanyView) {
      columnInfo = ColumnDataList.company(currentData);
    }

    if (columnInfo == null) return Container();

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
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                    tapHeaderToExpand: false,
                  ),
                  header: Padding(
                      padding: EdgeInsets.all(sx(AppSpace.padding)),
                      child: Row(
                        children: [
                          const CustomCheckbox(),
                          SizedBox(width: sx(AppSpace.padding)),
                          Text(columnInfo!.title),
                        ],
                      )),
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
