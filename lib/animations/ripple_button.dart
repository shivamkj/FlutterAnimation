import 'package:flutter/material.dart';

class AnimButton extends StatelessWidget {
  AnimButton(this.title);

  final String title;
  final isOpenNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: GestureDetector(
          onTap: () => isOpenNotifier.value = !isOpenNotifier.value,
          child: SizedBox(
            width: 50,
            height: 100,
            child: ValueListenableBuilder<bool>(
              valueListenable: isOpenNotifier,
              builder: (context, isOpen, _) {
                return AnimatedContainer(
                  duration: Duration(seconds: 2),
                  curve: Curves.easeOutQuart,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.lightBlue,
                    boxShadow: [
                      if (isOpen)
                        for (var i = 0; i < 5; i++)
                          BoxShadow(
                            spreadRadius: i * 40.0,
                            color: Colors.lightBlue.withAlpha((255 ~/ 5)),
                          ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
