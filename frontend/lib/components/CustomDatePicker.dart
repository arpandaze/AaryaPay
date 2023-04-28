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

class DateField extends StatefulWidget {
  final Function(DateTime)? dateTime;
  const DateField({this.dateTime, super.key});

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime _selectedDate = DateTime.now();

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
        SvgPicture.asset(
          "assets/icons/calendar.svg",
          height: 25,
          width: 25,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<int>(
                menuMaxHeight: 300,
                hint: Text(
                  'Day',
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary),
                      ),
                ),
                underline: Container(
                  // width: 1000,
                  height: 10,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 1.5, color: Color.fromARGB(50, 0, 00, 0)),
                    ),
                  ),
                ),
                items: _getDayItems(),
                value: _selectedDate.day,
                onChanged: (value) {
                  setState(() {
                    _selectedDate = DateTime(
                        _selectedDate.year, _selectedDate.month, value!);
                  });
                  widget.dateTime!(_selectedDate);
                },
                alignment: Alignment.center,
              ),
              DropdownButton<String>(
                menuMaxHeight: 300,
                hint: Text(
                  'Month',
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary),
                      ),
                ),
                // isExpanded: true,
                value: months[_selectedDate.month],
                alignment: Alignment.center,
                underline: Container(
                  // width: 1000,
                  height: 10,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 1.5, color: Color.fromARGB(50, 0, 00, 0)),
                    ),
                  ),
                ),
                items: _getMonthItems(),
                onChanged: (value) {
                  setState(() {
                    _selectedDate = DateTime(
                        _selectedDate.year,
                        months.keys
                            .firstWhere((element) => months[element] == value!),
                        _selectedDate.day);
                  });
                  widget.dateTime!(_selectedDate);
                },
              ),
              DropdownButton<int>(
                menuMaxHeight: 300,
                hint: Text(
                  'Year(AD)',
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary),
                      ),
                ),
                // isExpanded: true,
                value: _selectedDate.year,
                alignment: Alignment.center,
                underline: Container(
                  // width: 1000,
                  height: 10,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 1.5, color: Color.fromARGB(50, 0, 00, 0)),
                    ),
                  ),
                ),
                items: _getYearItems(),
                onChanged: (value) {
                  setState(() {
                    _selectedDate = DateTime(
                        value!, _selectedDate.month, _selectedDate.day);
                    // widget.dateTime!["year"] = value.toString();
                  });
                  widget.dateTime!(_selectedDate);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
