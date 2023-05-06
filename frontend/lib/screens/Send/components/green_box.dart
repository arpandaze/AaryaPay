import 'package:aaryapay/screens/Send/components/CustomWhiteCircularAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GreenBox extends StatelessWidget {
  final Widget? photo;
  final String recipient;
  final String sender;
  final String amount;
  final String date;
  final String status;
  const GreenBox(
      {super.key,
      this.photo,
      required this.recipient,
      required this.amount,
      required this.date,
    required this.sender,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 5, 25, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    photo ??
                        const CustomWhiteCircularAvatar(
                          size: 35,
                          imageSrc: AssetImage("assets/images/pfp.jpg"),
                        ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Recipient",
                              style:
                                  Theme.of(context).textTheme.titleSmall!.merge(
                                        TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background),
                                      ),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(recipient,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .merge(
                                        TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset('assets/icons/star.svg',
                    width: 25,
                    height: 25,
                    colorFilter:
                        ColorFilter.mode(
                        Theme.of(context).colorScheme.background,
                        BlendMode.srcIn)),
              ],
            ),
          ),
          Container(
            height: 100,
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        "Date",
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        date,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        "Sender",
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Susraya Bir Sing Tuladhar",
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        "Sent Status",
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        status,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
