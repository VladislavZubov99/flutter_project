import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:project/core/api_configurations.dart';
import 'package:project/domain/modules/dashboard_management/models/common/sort_names.dart';
import 'package:project/ui/app_settings/app_space.dart';
import 'package:project/ui/app_settings/app_text_styles.dart';
import 'package:project/ui/widgets/custom_checkbox/custom_checkbox.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

extension DateTimeExtension on DateTime {
  DateTime get lastDayOfMonth =>
      month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);

  DateTime get firstDayOfMonth => DateTime(year, month, 1);
}

class FiltersWidget extends StatefulWidget {
  final Function(
      {List<String>? dateRange,
      bool? orderByDesc,
      int? pageSize,
      String? sortField}) onUpdateFilers;
  final DashboardManagementEndpointConfiguration initialFilters;

  const FiltersWidget({Key? key, required this.onUpdateFilers, required this.initialFilters, })
      : super(key: key);

  @override
  State<FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  final DateRangePickerController _controller = DateRangePickerController();

  static DateTimeRange _initialDateTimeRange = DateTimeRange(
      start: DateTime.now().firstDayOfMonth,
      end: DateTime.now().lastDayOfMonth);

  DateTimeRange dateTimeRange = _initialDateTimeRange;
  DateTimeRange updatingDateTimeRange = _initialDateTimeRange;
  String sortField = SortNames.name;
  bool orderByDesc = true;

  List<String> get formattedDateRange => [
        DateFormat('MMMM y').format(dateTimeRange.start),
        DateFormat('MMMM y').format(dateTimeRange.end),
      ];

  List<String> get dateRange => [
        dateTimeRange.start.toIso8601String(),
        dateTimeRange.end.toIso8601String(),
      ];

  @override
  void initState() {
    _initialDateTimeRange = DateTimeRange(
        start: DateTime.parse(widget.initialFilters.dateRange.first),
        end: DateTime.parse(widget.initialFilters.dateRange.last));
    sortField = widget.initialFilters.sortField;
    orderByDesc = widget.initialFilters.orderByDesc;

    _controller.view = DateRangePickerView.year;
    _controller.selectedRange =
        PickerDateRange(_initialDateTimeRange.start, _initialDateTimeRange.end);

    _controller.addPropertyChangedListener(_onSelectionChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removePropertyChangedListener(_onSelectionChanged);
    super.dispose();
  }

  void _onSelectionChanged(String propertyName) {
    if (propertyName == 'selectedRange') {
      setState(() {
        updatingDateTimeRange = DateTimeRange(
            start: _controller.selectedRange!.startDate!,
            end: _controller.selectedRange!.endDate ??
                _controller.selectedRange!.startDate!);
      });
    }
  }

  void _onConfirmCalendar() {
    setState(() {
      dateTimeRange = updatingDateTimeRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      final appTextStyles = AppTextStyles(scaling: sx);
      return Padding(
        padding: EdgeInsets.all(sx(AppSpace.padding)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Range:',
              style: appTextStyles.commonTitleText,
            ),
            SizedBox(height: sx(AppSpace.padding / 2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${formattedDateRange[0]} | ${formattedDateRange[1]}',
                    style: appTextStyles.secondaryTitleText),
                Flexible(
                  child: MonthDateRangeWidget(
                    controller: _controller,
                    onConfirm: _onConfirmCalendar,
                    initialSelectedRange: PickerDateRange(
                      dateTimeRange.start,
                      dateTimeRange.end,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sx(AppSpace.padding)),
            Row(
              children: [
                CustomCheckbox(
                  value: orderByDesc,
                  onChangeCallback: (isChecked) {
                    setState(() {
                      orderByDesc = isChecked;
                    });
                  },
                ),
                SizedBox(width: sx(AppSpace.padding)),
                Text('Order by desc', style: appTextStyles.commonTitleText),
              ],
            ),
            SizedBox(height: sx(AppSpace.padding)),
            CheckSortNamesWidget(
              value: sortField,
              onChangeSortName: (sortFieldName) {
                setState(() {
                  sortField = sortFieldName;
                });
              },
            ),
            SizedBox(height: sx(AppSpace.padding)),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: sx(40),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          dateTimeRange = _initialDateTimeRange;
                          updatingDateTimeRange = _initialDateTimeRange;
                          sortField = SortNames.name;
                          orderByDesc = true;
                        });
                        widget.onUpdateFilers(
                            dateRange: dateRange,
                            sortField: sortField,
                            orderByDesc: orderByDesc);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: Text(
                        'Clear Filters',
                        style: appTextStyles.commonButtonText,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: sx(AppSpace.padding),
                ),
                Expanded(
                  child: SizedBox(
                    height: sx(40),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onUpdateFilers(
                            dateRange: dateRange,
                            sortField: sortField,
                            orderByDesc: orderByDesc);
                      },
                      child: Text(
                        'Confirm',
                        style: appTextStyles.commonButtonText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class MonthDateRangeWidget extends StatefulWidget {
  final DateRangePickerController controller;
  final PickerDateRange initialSelectedRange;
  final void Function() onConfirm;

  const MonthDateRangeWidget({
    Key? key,
    required this.controller,
    required this.initialSelectedRange,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<MonthDateRangeWidget> createState() => _MonthDateRangeWidgetState();
}

class _MonthDateRangeWidgetState extends State<MonthDateRangeWidget> {
  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      final appTextStyles = AppTextStyles(scaling: sx);
      return TextButton(
        child: Text(
          'Open Calendar',
          style: appTextStyles.commonButtonText,
        ),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Choose Date Range'),
              titlePadding: EdgeInsets.all(sx(AppSpace.padding)),
              contentPadding: EdgeInsets.all(sx(AppSpace.padding)),
              children: [
                SizedBox(
                  width: sx(350),
                  height: sx(300),
                  child: SfDateRangePicker(
                    controller: widget.controller,
                    onCancel: () {
                      setState(() {
                        widget.controller.selectedRange =
                            widget.initialSelectedRange;
                      });
                      Navigator.of(context).pop();
                    },
                    onSubmit: (_) {
                      Navigator.of(context).pop();
                      widget.onConfirm();
                    },
                    viewSpacing: sx(40),
                    headerStyle: DateRangePickerHeaderStyle(
                        textStyle: appTextStyles.secondaryTitleText
                            .copyWith(fontSize: sx(24))),
                    yearCellStyle: DateRangePickerYearCellStyle(
                      textStyle: appTextStyles.commonTitleText.copyWith(
                        color: Colors.black
                      ),
                      todayTextStyle: appTextStyles.secondaryTitleText,
                      leadingDatesTextStyle: appTextStyles.commonTitleText,
                      disabledDatesTextStyle:
                          appTextStyles.commonTitleText.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    selectionTextStyle: appTextStyles.secondaryTitleText
                        .copyWith(color: Colors.white),
                    rangeTextStyle: appTextStyles.secondaryTitleText,
                    showActionButtons: true,
                    view: DateRangePickerView.year,
                    selectionMode: DateRangePickerSelectionMode.range,
                    allowViewNavigation: false,
                    initialSelectedRange: widget.initialSelectedRange,
                    maxDate: DateTime.now(),
                  ),
                )
              ],
            );
          },
        ),
      );
    });
  }
}

class CheckSortNamesWidget extends StatefulWidget {
  final void Function(String val) onChangeSortName;

  final String value;

  const CheckSortNamesWidget({
    Key? key,
    required this.onChangeSortName,
    required this.value,
  }) : super(key: key);

  @override
  State<CheckSortNamesWidget> createState() => _CheckSortNamesWidgetState();
}

class _CheckSortNamesWidgetState extends State<CheckSortNamesWidget> {
  changeSortableFieldName(String value) {
    widget.onChangeSortName(value);
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return ExpandableNotifier(
        initialExpanded: false,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(sx(5)),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 0),
                    blurRadius: 4)
              ]),
          clipBehavior: Clip.antiAlias,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: false,
              tapHeaderToExpand: true,
              hasIcon: false,
            ),
            header: Padding(
              padding: EdgeInsets.all(sx(AppSpace.padding)),
              child: Row(
                children: [
                  const Text('Sort by field: '),
                  SizedBox(width: sx(AppSpace.padding)),
                  Text(widget.value)
                ],
              ),
            ),
            collapsed: Container(),
            expanded: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: SortNames.sortNameList
                  .map((sortName) => _buildTile(sortName))
                  .toList(),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTile(String val) {
    return ListTile(
      title: GestureDetector(
          onTap: () => changeSortableFieldName(val), child: Text(val)),
      leading: Radio<String>(
        value: val,
        groupValue: widget.value,
        onChanged: (_) => changeSortableFieldName(val),
      ),
    );
  }
}
