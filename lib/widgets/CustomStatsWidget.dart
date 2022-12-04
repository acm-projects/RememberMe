import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';

class CustomStats extends StatelessWidget {
  final String titleText;
  final String achievement;

  const CustomStats({
    super.key,
    required this.titleText,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      child: ListTile(
        title: Text(
          titleText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        subtitle: Text(
          achievement,
          style: const TextStyle(fontSize: 20),
        ),
        leading: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color.fromARGB(70, 60, 200, 10),
            shape: BoxShape.circle,
          ),
          child: const DecoratedIcon(
            icon: Icon(Icons.star, size: 35, color: Colors.yellow),
            decoration: IconDecoration(
              shadows: [
                Shadow(
                  blurRadius: 20,
                  offset: Offset(1, 0),
                  color: Colors.brown,
                )
              ],
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xfffaf8f8),
                  Color(0xfffae16c),
                  Color.fromARGB(128, 250, 148, 75),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
