import 'package:flutter/material.dart';

class TransactionDetails extends StatelessWidget {
  final String recieverID;
  final String transactionNo;
  final String time;
  const TransactionDetails({
    super.key, required this.recieverID, required this.transactionNo, required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.fromLTRB(25, 5, 25, 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(
              "Transaction Details",
              style: Theme.of(context).textTheme.titleMedium!.merge(
                    const TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Receiver Id",
                  style: Theme.of(context).textTheme.bodyLarge!),
              Text(
                recieverID,
                style: Theme.of(context).textTheme.bodyLarge!.merge(
                      const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900),
                    ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transcation Number",
                  style: Theme.of(context).textTheme.bodyLarge!),
              Text(
                transactionNo,
                style: Theme.of(context).textTheme.bodyLarge!.merge(
                      const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900),
                    ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Time", style: Theme.of(context).textTheme.bodyLarge!),
              Text(
                time,
                style: Theme.of(context).textTheme.bodyLarge!.merge(
                      const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
