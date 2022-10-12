import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:project/domain/modules/dashboard_management/models/data_columns/data_columns.dart';
import 'package:project/ui/app_settings/app_colors.dart';
import 'package:project/ui/app_settings/app_space.dart';
import 'package:project/ui/widgets/custom_checkbox/custom_checkbox.dart';
import 'package:relative_scale/relative_scale.dart';

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
                    hasIcon: false,
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
