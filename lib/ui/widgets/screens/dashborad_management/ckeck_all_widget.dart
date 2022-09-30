import 'package:flutter/material.dart';
import 'package:project/ui/widgets/custom_checkbox/custom_checkbox.dart';



class CheckAllWidget extends StatefulWidget {
  final void Function() onCheckAll;
  final void Function() onRemoveFromCheckAll;
  final bool? isChecked;

  const CheckAllWidget({
    Key? key,
    required this.onCheckAll,
    required this.onRemoveFromCheckAll,
    this.isChecked
  }) : super(key: key);

  @override
  State<CheckAllWidget> createState() => _CheckAllWidgetState();
}

class _CheckAllWidgetState extends State<CheckAllWidget> {

  @override
  Widget build(BuildContext context) {
    return CustomCheckbox(
      value: widget.isChecked,
      onChangeCallback: (bool isChecked) {
        if(isChecked) {
          widget.onCheckAll();
        } else {
          widget.onRemoveFromCheckAll();
        }
      },
    );
  }
}
