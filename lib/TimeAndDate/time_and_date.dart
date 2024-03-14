
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeAndDate{

  Future<String?> showDatePickerDialog(BuildContext context) async {
    DateTime? selectedDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2040),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      final dateFormat = DateFormat("MMMM dd, yyyy");
      return dateFormat.format(pickedDate);
    }
    return null;
  }


}