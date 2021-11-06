import 'package:flutter/material.dart';

class BoxAnimation extends StatefulWidget {
  const BoxAnimation(this.title);
  final String title;

  @override
  _BoxAnimationState createState() => _BoxAnimationState();
}

class _BoxAnimationState extends State<BoxAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _curve;
  bool isReverse = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 1.5),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.5, end: 1),
          weight: 50,
        ),
      ],
    ).animate(_curve);

    _sizeAnimation = Tween<double>(
      begin: isReverse ? 250 : 0,
      end: isReverse ? 0 : 250,
    ).animate(_controller);
  }

  void animate() {
    if (isReverse) {
      isReverse = false;
      _controller.reverse();
    } else {
      isReverse = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedBuilder(
                animation: _controller,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.orange,
                  ),
                ),
                builder: (_, Widget? child) {
                  return Transform.translate(
                    offset: Offset(0, -_sizeAnimation.value),
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _sizeAnimation.value / 250,
                        child: child,
                      ),
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: animate,
                child: Container(width: 50, height: 50, color: Colors.cyan),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
