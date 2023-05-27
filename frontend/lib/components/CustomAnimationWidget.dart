import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAnimationWidget extends StatefulWidget {
  final double width;
  final double height;
  final bool repeat;
  CustomAnimationWidget({super.key,this.width = 200, this.height = 200, this.repeat=false,required this.assetSrc});
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
      width: widget.width,
      height: widget.height,
      controller: _controller,
      onLoaded: (composition) {
        // Configure the AnimationController with the duration of the
        // Lottie file and start the animation.
        _controller
          .duration = composition.duration;
          widget.repeat
              ? _controller.repeat()
              : _controller.forward().whenComplete(() => _controller.reset());
      },
    );
  }
}
