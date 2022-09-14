import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/models/dashboard_management/company_notifier.dart';
import 'package:project/domain/models/dashboard_management/company_view.dart';
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
            create: (_) => CompanyNotifier())
      ],
      child: RelativeBuilder(
        builder: (context, height, width, sy, sx) {
          return SafeArea(
            top: true,
            child: Scaffold(
              endDrawer: Drawer(
                  child: Center(
                child: Column(
                  children: <Widget>[Text('End Drawer')],
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
                  Consumer<CompanyNotifier>(
                    builder: (_, companiesModel, __) {
                      return CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(AppSpace.padding),
                            sliver: SliverToBoxAdapter(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                        onPressed: () =>
                                            Provider.of<CompanyNotifier>(
                                                    context,
                                                    listen: false)
                                                .fetchCompanies(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                        ),
                                        child: const Text('Load data')),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ExpandableCompanyViewWidget(
                                  companyView:
                                      companiesModel.companiesList[index],
                                );
                              },
                              childCount: companiesModel.companiesList.length,
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
                          // SliverPersistentHeader(
                          //   pinned: true,
                          //   floating: true,
                          //   delegate: FilterDelegate(
                          //     child: PreferredSize(
                          //         preferredSize: Size.fromHeight(sx(180)),
                          //         child: const FilterWidget()),
                          //   ),
                          // ),
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

class ExpandableCompanyViewWidget extends StatelessWidget {
  final CompanyView companyView;

  const ExpandableCompanyViewWidget({super.key, required this.companyView});

  @override
  Widget build(BuildContext context) {
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
                      Text(companyView.companyName),
                    ],
                  )),
              collapsed: Container(),
              expanded: _buildMobileTable(companyView.columnList),
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
