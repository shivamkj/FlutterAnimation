import 'package:flutter/material.dart';

class Heart extends StatefulWidget {
  const Heart(this.title);
  final String title;

  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> with SingleTickerProviderStateMixin {
  bool isFav = false;

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.red,
    ).animate(_controller);

    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 30, end: 45),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 45, end: 30),
          weight: 50,
        ),
      ],
    ).animate(_controller);
  }

  void animate() {
    if (isFav)
      _controller.reverse().whenComplete(() => {isFav = false});
    else {
      _controller.forward().whenComplete(() => {isFav = true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, _) {
            return IconButton(
              icon: Icon(
                Icons.favorite,
                color: _colorAnimation.value,
                size: _sizeAnimation.value,
              ),
              onPressed: animate,
            );
          },
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
