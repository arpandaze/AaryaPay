import 'package:aaryapay/screens/Register/components/register_wrapper.dart';
import 'package:aaryapay/screens/Send/offline_send.dart';
import 'package:flutter/material.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RegisterWrapper(
      backButton: true,
      backButttonFunction: () => {
        Navigator.pop(context),
      },
      title: "Completed",
      actionButtonLabel: "Done",
      actionButtonFunction: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const OfflineSend(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ),
      children: _midsection(context, size),
    );
  }

  Widget _midsection(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You Are, All Set",
              style: Theme.of(context).textTheme.headlineLarge!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                "Does anyone even read this text. No. Why are you reading this text. Just login already, this text is worthless.",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .merge(const TextStyle(height: 1.5)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
