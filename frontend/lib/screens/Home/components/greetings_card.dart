import 'package:flutter/material.dart';

class GreetingsCard extends StatelessWidget {
  const GreetingsCard({Key? key, required this.size}) : super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        image: DecorationImage(
            image: AssetImage("assets/images/background.jpeg"),
            fit: BoxFit.cover),
        border: Border.all(color: Colors.black26),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(5, 5), // changes position of shadow
          ),
        ],
      ),
      child: SizedBox(
        // width: size.width * 0.8,
        width: double.infinity,
        height: 200,
        child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good Morning,",
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      "Rushab Humagain",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                Text(
                  "Chamatkarik Bachat Khata",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  "0857038109352401",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  // width: 150,
                  child: Container(
                    // decoration: BoxDecoration(
                    //     border: Border.all(
                    //         color: Theme.of(context).colorScheme.onBackground)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(
                            "Balance",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Container(
                          // decoration: BoxDecoration(
                          //     border: Border.all(
                          //         color: Theme.of(context)
                          //             .colorScheme
                          //             .onBackground)),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "\$18,564.33",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
