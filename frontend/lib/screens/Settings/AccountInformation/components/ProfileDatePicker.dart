import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:core';

Map<int, String> months = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December",
};

class ProfileDateField extends StatefulWidget {
  final Function(DateTime)? dateTime;
  const ProfileDateField({this.dateTime, super.key});

  @override
  _ProfileDateFieldState createState() => _ProfileDateFieldState();
}

class _ProfileDateFieldState extends State<ProfileDateField> {
  DateTime _selectedDate = DateTime.now();
  bool firstDay = true;
  bool firstMonth = true;
  bool firstYear = true;
  // @override
  // void initState() {
  //   super.initState();
  // }

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

  List<DropdownMenuItem<String>> _getMonthItems() {
    List<DropdownMenuItem<String>> items = [];
    for (int key in months.keys) {
      items.add(DropdownMenuItem(
        value: months[key],
        child: Text("${months[key]}"),
      ));
      // print(key);
    }
    return items;
  }

  List<DropdownMenuItem<int>> _getYearItems() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = DateTime.now().year; i >= 1900; i--) {
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButton<int>(
                  menuMaxHeight: 300,
                  hint: Text(
                    'Day',
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.onTertiary),
                        ),
                  ),
                  underline: SizedBox(),
                  items: _getDayItems(),
                  value: firstDay ? null : _selectedDate.day,
                  onChanged: (value) {
                    firstDay = false;
                    setState(() {
                      _selectedDate = DateTime(
                          _selectedDate.year, _selectedDate.month, value!);
                    });
                    widget.dateTime!(_selectedDate);
                  },
                  alignment: Alignment.center,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButton<String>(
                  menuMaxHeight: 300,
                  hint: Text(
                    'Month',
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.onTertiary),
                        ),
                  ),
                  // isExpanded: true,
                  value: firstMonth ? null : months[_selectedDate.month],
                  alignment: Alignment.center,
                  underline: SizedBox(),
                  items: _getMonthItems(),
                  onChanged: (value) {
                    firstMonth = false;
                    setState(() {
                      _selectedDate = DateTime(
                          _selectedDate.year,
                          months.keys.firstWhere(
                              (element) => months[element] == value!),
                          _selectedDate.day);
                    });
                    widget.dateTime!(_selectedDate);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButton<int>(
                  menuMaxHeight: 300,
                  hint: Text(
                    'Year(AD)',
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.onTertiary),
                        ),
                  ),
                  // isExpanded: true,
                  value: firstYear ? null : _selectedDate.year,
                  alignment: Alignment.center,
                  underline: SizedBox(), 
                  items: _getYearItems(),
                  onChanged: (value) {
                    firstYear = false;
                    setState(() {
                      _selectedDate = DateTime(
                          value!, _selectedDate.month, _selectedDate.day);
                      // widget.dateTime!["year"] = value.toString();
                    });
                    widget.dateTime!(_selectedDate);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
