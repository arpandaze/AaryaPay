import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DateField extends StatefulWidget {
  const DateField({super.key});

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  int? _selectedDay = null;
  String? _selectedMonth = null;
  int? _selectedYear = null;

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
    // print(months[1]);
    List<DropdownMenuItem<String>> items = [];
    for (int key in months.keys) {
      items.add(DropdownMenuItem(
        value: months[key].toString(),
        child: Text("${months[key]}"),
      ));
      // print(key);
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
                value: _selectedDay,
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value!;
                  });
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
                value: _selectedMonth,
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
                    _selectedMonth = value!;
                  });
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
                value: _selectedYear,
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
                    _selectedYear = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
