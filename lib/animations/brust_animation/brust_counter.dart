import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'growing_text.dart';
import 'model.dart';


class BrustCounter extends StatefulWidget {
  const BrustCounter(this.title);
  final String title;

  @override
  _BrustCounterState createState() => _BrustCounterState();
}

class _BrustCounterState extends State<BrustCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Color> colors = [
    Color(0xffffc100),
    Color(0xffff9a00),
    Color(0xffff7400),
    Color(0xffff4d00),
    Color(0xffff0000)
  ];

  final GlobalKey _boxKey = GlobalKey();
  final Random random = Random();

  final double gravity = 9.81,
      dragCof = 0.47,
      airDensity = 1.1644,
      fps = 1 / 24;

  late Timer timer;
  Rect boxSize = Rect.zero;
  List<Particle> particles = [];
  dynamic counterText = {"count": 1, "color": Color(0xffffc100)};
  bool isReverve = false;

  @override
  void initState() {
    // AnimationController for initial Burst Animation of Text
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));

    // Getting the Initial size of Container as soon as the First Frame Renders
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Size size = _boxKey.currentContext!.size!;
      boxSize = Rect.fromLTRB(0, 0, size.width, size.height);
    });

    // Refreshing State at Rate of 24/Sec
    timer = Timer.periodic(
        Duration(milliseconds: (fps * 1000).floor()), frameBuilder);

    super.initState();
  }

  void frameBuilder(Timer timer) {
    // Looping though particles to calculate their new position
    particles.forEach((pt) {
      //Calculating Drag Force (DRAG FORCE HAS TO BE NEGATIVE - MISSED THIS IN THE TUTORIAL)
      double dragForceX =
          -0.5 * airDensity * pow(pt.velocity.x, 2) * dragCof * pt.area;
      double dragForceY =
          -0.5 * airDensity * pow(pt.velocity.y, 2) * dragCof * pt.area;

      dragForceX = dragForceX.isInfinite ? 0.0 : dragForceX;
      dragForceY = dragForceY.isInfinite ? 0.0 : dragForceY;

      // Calculating Acceleration
      double accX = dragForceX / pt.mass;
      double accY = gravity + dragForceY / pt.mass;

      // Calculating Velocity Change
      pt.velocity.x += accX * fps;
      pt.velocity.y += accY * fps;

      // Calculating Position Change
      pt.position.x += pt.velocity.x * fps * 100;
      pt.position.y += pt.velocity.y * fps * 100;

      // Calculating Position and Velocity Changes after Wall Collision
      boxCollision(pt);
    });
  }

  burstParticles() {
    // Removing Some Old particles each time FAB is Clicked (PERFORMANCE)
    if (particles.length > 200) {
      particles.removeRange(0, 75);
    }

    _animationController.forward().whenComplete(() => {
          _animationController.reverse(),
        });

    double colorRandom = random.nextDouble();

    Color color = colors[(colorRandom * colors.length).floor()];
    String previousCount = "${counterText['count']}";
    Color prevColor = counterText['color'];
    counterText['count'] = counterText['count'] + 1;
    counterText['color'] = color;
    int count = random.nextInt(25).clamp(5, 25);

    for (int x = 0; x < count; x++) {
      double randomX = random.nextDouble() * 4.0;
      if (x % 2 == 0) {
        randomX = -randomX;
      }
      double randomY = random.nextDouble() * -7.0;
      Particle p = Particle();
      p.radius = (random.nextDouble() * 10.0).clamp(2.0, 10.0);
      p.color = prevColor;
      p.position = PVector(boxSize.center.dx, boxSize.center.dy);
      p.velocity = PVector(randomX, randomY);
      particles.add(p);
    }

    List<String> numbers = previousCount.split("");
    for (int x = 0; x < numbers.length; x++) {
      double randomX = random.nextDouble();
      if (x % 2 == 0) {
        randomX = -randomX;
      }
      double randomY = random.nextDouble() * -7.0;
      Particle p = Particle();
      p.type = ParticleType.TEXT;
      p.text = numbers[x];
      p.radius = 25;
      p.color = color;
      p.position = PVector(boxSize.center.dx, boxSize.center.dy);
      p.velocity = PVector(randomX * 4.0, randomY);
      particles.add(p);
    }
  }

  boxCollision(Particle pt) {
    // Collision with Right of the Box Wall
    if (pt.position.x > boxSize.width - pt.radius) {
      pt.velocity.x *= pt.jumpFactor;
      pt.position.x = boxSize.width - pt.radius;
    }
    // Collision with Bottom of the Box Wall
    if (pt.position.y > boxSize.height - pt.radius) {
      pt.velocity.y *= pt.jumpFactor;
      pt.position.y = boxSize.height - pt.radius;
    }
    // Collision with Left of the Box Wall
    if (pt.position.x < pt.radius) {
      pt.velocity.x *= pt.jumpFactor;
      pt.position.x = pt.radius;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SizedBox(
        key: _boxKey,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (_, Widget? child) {
            return Stack(
              children: [
                GrowingText(
                  count: counterText['count'],
                  color: counterText['color'],
                ),
                ...particles.map((pt) {
                  if (pt.type == ParticleType.TEXT) {
                    return Positioned(
                        top: pt.position.y,
                        left: pt.position.x,
                        child: Text(
                          "${pt.text}",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: pt.color),
                        ));
                  } else {
                    return Positioned(
                      top: pt.position.y,
                      left: pt.position.x,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: pt.color),
                        child: SizedBox(
                          width: pt.radius * 2,
                          height: pt.radius * 2,
                        ),
                      ),
                    );
                  }
                }).toList()
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: burstParticles,
        backgroundColor: counterText['color'],
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel and Dispose off timer and Animation Controller
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }
}

