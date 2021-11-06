import 'package:flutter/material.dart';

class GrowingText extends StatefulWidget {
  const GrowingText({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  State<StatefulWidget> createState() => _GrowingTextState();
}

class _GrowingTextState extends State<GrowingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween(begin: 1.0, end: 2.0).animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant GrowingText oldWidget) {
    if (oldWidget.count != widget.count) animate();
    super.didUpdateWidget(oldWidget);
  }

  void animate() {
    _animationController.forward().whenComplete(() => {
          _animationController.reverse(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${widget.count}",
        textScaleFactor: _animation.value,
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: widget.color,
        ),
      ),
    );
  }
}
