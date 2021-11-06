import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ClickBoxGame extends StatefulWidget {
  const ClickBoxGame({Key? key}) : super(key: key);

  @override
  _ClickBoxGameState createState() => _ClickBoxGameState();
}

class _ClickBoxGameState extends State<ClickBoxGame> {
  final _random = Random();

  Color _color = Colors.red;
  double _width = 100;
  double _height = 100;
  double _radius = 50;
  Alignment _alignment = const Alignment(0.5, 0.5);

  int _score = 0;
  Timer? _timer;
  int _countDown = 10;
  bool _isPlaying = false;

  void _randomize() {
    _color = Color.fromARGB(
      _random.nextInt(255),
      _random.nextInt(255),
      _random.nextInt(255),
      _random.nextInt(255),
    );
    _width = _random.nextDouble() * 120 + 10;
    _height = _random.nextDouble() * 120 + 10;
    _radius = _random.nextDouble() * 50 + 10;
    _alignment = Alignment(
      _random.nextDouble() * 2 - 1,
      _random.nextDouble() * 2 - 1,
    );
  }

  void _startGame() {
    _score = 0;
    _countDown = 10;
    _isPlaying = true;
    _randomize();
    _startTimer();
  }

  void _increaseScore() {
    _score++;
  }

  void updateTimer() {
    if (_countDown < 1) {
      _isPlaying = false;
      _timer?.cancel();
    } else {
      _countDown = _countDown - 1;
    }
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(updateTimer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: const Color(0xFF15202D),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Score: $_score',
                    style: const TextStyle(color: Colors.white, fontSize: 48),
                  ),
                  (!_isPlaying)
                      ? GestureDetector(
                          onTap: () => setState(_startGame),
                          child: const Text(
                            'Start',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                        )
                      : Text(
                          '$_countDown',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 28),
                        ),
                ],
              ),
            ),
            (_isPlaying)
                ? GestureDetector(
                    onTap: () => setState(() {
                      _increaseScore();
                      _randomize();
                    }),
                    // AnimatedAlign : Implicit Animation
                    child: AnimatedAlign(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 500),
                      alignment: _alignment,
                      // AnimatedContainer : Implicit Animation
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: _width,
                        height: _height,
                        decoration: BoxDecoration(
                          color: _color,
                          borderRadius: BorderRadius.circular(_radius),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
