import 'package:flutter/material.dart';

class IconedOperations extends StatelessWidget {
  const IconedOperations(
      {Key? key, required this.imageSrc, required this.label})
      : super(key: key);

  final AssetImage imageSrc;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      
      // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                child: ImageIcon(
              imageSrc,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            )),
            Container(
                width: 60,
                // decoration:
                //     BoxDecoration(border: Border.all(color: Colors.black)),
                child: Text(

              label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
            ))
          ]),
    );
  }
}
