import 'package:flutter/material.dart';

class GreyCard extends StatefulWidget {
  const GreyCard({
    Key? key,
  }) : super(key: key);

  @override
  _GreyCardState createState() => _GreyCardState();
}

class _GreyCardState extends State<GreyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),
      width: size.width,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(100, 150, 150, 150),
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromARGB(100, 237, 237, 237),
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.55,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              begin: Alignment(_animation.value, 0),
                              end: const Alignment(1, 0),
                              colors: const [
                                Color.fromARGB(100, 237, 237, 237),
                                Colors.white,
                                Color.fromARGB(100, 237, 237, 237),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              begin: Alignment(_animation.value, 0),
                              end: const Alignment(1, 0),
                              colors: const [
                                Color.fromARGB(100, 237, 237, 237),
                                Colors.white,
                                Color.fromARGB(100, 237, 237, 237),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
