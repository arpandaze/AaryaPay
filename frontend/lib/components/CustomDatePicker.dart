import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  DateField({
    this.dateTime,
    this.onChangeVal,
    super.key,
  });
  DateTime? dateTime;
  final Function? onChangeVal;

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  int _selectedDay = 1;
  String _selectedMonth = "January";
  int _selectedYear = DateTime.now().year;

  // DateTime _selectedDateTime =
  //     DateTime(DateTime.now().year, DateTime.january, 1);

  List<int> _getDayItems() {
    return List.generate(31, (index) => index + 1);
  }

  List<String> _getMonthItems() {
    return [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
  }

  List<int> _getYearItems() {
    return List.generate(100, (index) => DateTime.now().year - 99 + index);
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
                  height: 10,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 1.5, color: Color.fromARGB(50, 0, 00, 0)),
                    ),
                  ),
                ),
                items: _getDayItems().map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                value: _selectedDay,
                onChanged: (value) {
                  setState(() {
                    _selectedDay = value!;
                    widget.dateTime = DateTime(
                        _selectedYear,
                        _getMonthItems().indexOf(_selectedMonth) + 1,
                        _selectedDay);
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
                alignment: Alignment.center,
                underline: Container(
                  height: 10,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 1.5, color: Color.fromARGB(50, 0, 00, 0)),
                    ),
                  ),
                ),
                items: _getMonthItems().map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _selectedMonth,
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value!;
                    widget.dateTime = DateTime(
                        _selectedYear,
                        _getMonthItems().indexOf(_selectedMonth) + 1,
                        _selectedDay);
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
                items: _getYearItems().map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                value: _selectedYear,
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value!;
                    widget.dateTime = DateTime(
                        _selectedYear,
                        _getMonthItems().indexOf(_selectedMonth) + 1,
                        _selectedDay);
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
