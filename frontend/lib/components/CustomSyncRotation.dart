import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSyncRotation extends StatefulWidget {
  final bool? syncing;

  const CustomSyncRotation({super.key, this.syncing});
  @override
  _CustomSyncRotationState createState() => _CustomSyncRotationState();
}

class _CustomSyncRotationState extends State<CustomSyncRotation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.syncing!) {
      _controller.reset();
    }

    if (widget.syncing!) {
      _controller.repeat();
    }

    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: SvgPicture.asset(
        "assets/icons/sync.svg",
        height: 14,
        width: 14,
      ),
    );
  }
}
