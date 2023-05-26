import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAnimationWidget extends StatefulWidget {
  const CustomAnimationWidget({super.key, required this.assetSrc});
  final String assetSrc;
  @override
  State<CustomAnimationWidget> createState() => _MyAppState();
}

class _MyAppState extends State<CustomAnimationWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.assetSrc,
      width: 200,
      height: 200,
      controller: _controller,
      onLoaded: (composition) {
        // Configure the AnimationController with the duration of the
        // Lottie file and start the animation.
        _controller
          ..duration = composition.duration
          ..forward();
      },
    );
  }
}
