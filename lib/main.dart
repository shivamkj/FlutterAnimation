import 'package:flutter/material.dart';
import 'package:flutter_animation/animations/click_box_game.dart';
import 'animations/brust_animation/brust_counter.dart';
import 'animations/ripple_button.dart';
import 'animations/heart.dart';
import 'animations/box.dart';

void main() {
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      navigatorKey: navigatorKey,
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animation Examples')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildAnimBtn('Box Animation', BoxAnimation('Box Animation')),
                buildAnimBtn('Animated Button', AnimButton('Animated Button')),
                buildAnimBtn('Like Heart', Heart('Like Heart')),
                buildAnimBtn('Brust Counter', BrustCounter('Brust Counter')),
                buildAnimBtn('Click Box Game', ClickBoxGame()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAnimBtn(String name, Widget screen) {
    return ElevatedButton(
      onPressed: () => {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => screen),
        )
      },
      child: Text(name),
    );
  }
}
