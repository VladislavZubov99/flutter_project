import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/models/expand_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/common/notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_notifier.dart';
import 'package:project/domain/modules/dashboard_management/state_machine/dashboard_management_notifier.dart';
import 'package:project/ui/app_settings/app_colors.dart';
import 'package:project/ui/app_settings/app_space.dart';
import 'package:project/ui/app_settings/app_text_styles.dart';
import 'package:project/ui/widgets/dashboard_management/check_all_widget/ckeck_all_widget.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:provider/provider.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      final Size buttonSize = Size(sx(150), sx(40));
      final AppTextStyles appTextStyles = AppTextStyles(scaling: sx);
      return Container(
        padding: EdgeInsets.all(sx(AppSpace.padding)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(sx(AppSpace.borderRadius)),
              bottomRight: Radius.circular(sx(AppSpace.borderRadius)),
            )),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: buttonSize.width,
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
                        fixedSize: buttonSize,
                        maximumSize: buttonSize,
                        minimumSize: buttonSize,
                      ),
                      child: Text(
                        widget.expandableController.expanded
                            ? 'Collapse All'
                            : 'Expand All',
                        style: appTextStyles.commonButtonText,
                      )),
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
                  width: buttonSize.width,
                  height: buttonSize.height,
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
                        // fixedSize: Size(sx(100), sy(14)),
                        fixedSize: buttonSize,
                        maximumSize: buttonSize,
                        minimumSize: buttonSize,
                      ),
                      child: Text(
                        'Prev',
                        style: appTextStyles.commonButtonText,
                      )),
                ),
                SizedBox(width: sx(10)),
                SizedBox(
                  width: buttonSize.width,
                  child: ElevatedButton(
                      onPressed: widget.machine.isLastStep
                          ? null
                          : () {
                              widget.machine.toNextStep();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        fixedSize: buttonSize,
                        maximumSize: buttonSize,
                        minimumSize: buttonSize,
                      ),
                      child: Text(
                        'Next',
                        style: appTextStyles.commonButtonText,
                      )),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: sx(AppSpace.padding)),
                  child: Text(
                    'Total: ${widget.viewModel.list.isNotEmpty ? widget.viewModel.list.length : '-'} of ${widget.viewModel.dataWithPagination?.totalCount != 0 ? widget.viewModel.dataWithPagination?.totalCount.toString() ?? '-' : '-'}',
                    style: appTextStyles.commonButtonText,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
