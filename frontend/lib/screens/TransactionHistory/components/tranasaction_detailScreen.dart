import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libaaryapay/libaaryapay.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: body(size, context),
      ),
    );
  }

  Widget body(Size size, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: size.width * 0.1,
                  // padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.of(context).pop(true),
                      },
                      child: SvgPicture.asset(
                        "assets/icons/close.svg",
                        width: 18,
                        height: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/check.svg',
                        width: 80,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff274233),
                          BlendMode.srcIn,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Payment Successful",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/rupee.svg",
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Text(
                              "250.00",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .merge(
                                    TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).colorScheme.outline),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transaction Number",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Initiated Mode",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Initiated Date/Time",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Verification Date/Time",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "1x09384852",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Offline",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  "May 2, 2023, 5:45 pm",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  "May 2, 2023, 5:45 pm",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sender Id",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                            height: 3.0, fontSize: 13),
                                      ),
                                ),
                                Text(
                                  "Sender Name",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Receiver Id",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Receiver Name",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "daze@test.com",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Arpan Koirala",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  "leo@test.com",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Leo Gupta",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CustomActionButton(
                      borderRadius: 10,
                      height: 60,
                      label: "Back to Home",
                    ),
                    CustomActionButton(
                      width: size.width * 0.23,
                      height: 60,
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: 10,
                      actionLogo: SvgPicture.asset(
                        "assets/icons/share.svg",
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.background,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () => {},
                    //   behavior: HitTestBehavior.opaque,
                    //   child: Container(
                    //     width: 70,
                    //     alignment: Alignment.center,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         color: Theme.of(context).colorScheme.outline,
                    //         borderRadius:
                    //             const BorderRadius.all(Radius.circular(10))),
                    //     child: SvgPicture.asset(
                    //       'assets/icons/share.svg',
                    //       width: 20,
                    //       height: 20,
                    //       colorFilter: const ColorFilter.mode(
                    //         Theme.of(context).colorScheme.background,
                    //         BlendMode.srcIn,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
