import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormat extends StatefulWidget {
  const DateTimeFormat({Key? key}) : super(key: key);

  @override
  State<DateTimeFormat> createState() => _DateTimeFormatState();
}

class _DateTimeFormatState extends State<DateTimeFormat> {
  DateTime _date = DateTime.now();
  final DateTime _now = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    print('123');
    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: _date,
      selectableDayPredicate: (DateTime val) =>
          val.millisecond < _now.millisecond,
    );

    if (datePicker != null && datePicker != _date) {
      setState(() {
        _date = datePicker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MM.yyyy');

    return TextField(
      onTap: () {
        _selectDate(context);
      },
      readOnly: true,
      decoration: InputDecoration(
        hintText: formatter.format(_date),
        helperStyle: const TextStyle(color: Colors.black),
        helperText: 'Month and year',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
