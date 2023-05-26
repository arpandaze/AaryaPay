import 'package:aaryapay/constants.dart';
import 'package:flutter/material.dart';

class CircularLoadingAnimation extends StatefulWidget {
  final double width;
  final double height;
  final ImageType shape;

  const CircularLoadingAnimation({
    required this.width,
    required this.height,
    this.shape = ImageType.circle,
  });

  @override
  _CircularLoadingAnimationState createState() =>
      _CircularLoadingAnimationState();
}

class _CircularLoadingAnimationState extends State<CircularLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(period: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.shape == ImageType.circle
        ? Container(
            width: widget.width,
            height: widget.height,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey.withOpacity(0.5),
                  Colors.grey.withOpacity(0.7),
                  Colors.grey.withOpacity(0.5),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ClipRect(
                  child: Stack(
                    children: [
                      Positioned(
                        left: -widget.width +
                            (_animationController.value *
                                2 *
                                widget
                                    .width), // Adjust the multiplication factor as needed
                        child: Container(
                          width: widget.width * 0.9,
                          height: widget.height,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(35),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.25),
                                Colors.white.withOpacity(0.0),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey.withOpacity(0.5),
                  Colors.grey.withOpacity(0.7),
                  Colors.grey.withOpacity(0.5),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(
                      20)), 
                  child: Stack(
                    children: [
                      Positioned(
                        left: -widget.width +
                            (_animationController.value *
                                2 *
                                widget
                                    .width), // Adjust the multiplication factor as needed
                        child: Container(
                          width: widget.width * 0.95,
                          height: widget.height,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.25),
                                Colors.white.withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
