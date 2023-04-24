import 'package:flutter/material.dart';

class DateField extends StatefulWidget {
  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  int _selectedDay = 1;
  int _selectedMonth = 1;
  int _selectedYear = 2022;

  List<DropdownMenuItem<int>> _getDayItems() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 1; i <= 31; i++) {
      items.add(DropdownMenuItem(
        value: i,
        child: Text(i.toString()),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<int>> _getMonthItems() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 1; i <= 12; i++) {
      items.add(DropdownMenuItem(
        value: i,
        child: Text(i.toString()),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<int>> _getYearItems() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 2022; i >= 1900; i--) {
      items.add(DropdownMenuItem(
        value: i,
        child: Text(i.toString()),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<int>(
          value: _selectedDay,
          items: _getDayItems(),
          onChanged: (value) {
            setState(() {
              _selectedDay = value!;
            });
          },
        ),
        DropdownButton<int>(
          value: _selectedMonth,
          items: _getMonthItems(),
          onChanged: (value) {
            setState(() {
              _selectedMonth = value!;
            });
          },
        ),
        DropdownButton<int>(
          value: _selectedYear,
          items: _getYearItems(),
          onChanged: (value) {
            setState(() {
              _selectedYear = value!;
            });
          },
        ),
      ],
    );
  }
}
