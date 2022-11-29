import 'package:animate_gradient/animate_gradient.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rememberme/widgets/memorygameselectdialog.dart';

class MemoryGameButton extends StatefulWidget {
  const MemoryGameButton({super.key});

  @override
  State<MemoryGameButton> createState() => _MemoryGameButtonState();
}

class _MemoryGameButtonState extends State<MemoryGameButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 36),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AnimateGradient(
          primaryBegin: Alignment.topLeft,
          primaryEnd: Alignment.bottomLeft,
          secondaryBegin: Alignment.bottomRight,
          secondaryEnd: Alignment.topRight,
          primaryColors: const [
            Color(0xFFFFA77C),
            Color(0xFFFFA77C),
            Color(0xFFFFD15B),
          ],
          secondaryColors: const [
            Color(0xFFFFD15B),
            Color(0xFFFFA77C),
            Color(0xFFFFA77C),
          ],
          child: ElevatedButton.icon(
            icon: const Icon(
              FontAwesomeIcons.brain,
              size: 48,
            ),
            label: const AutoSizeText(
              '  Memory Game',
              maxLines: 1,
              minFontSize: 28,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0x00000000),
              elevation: 0,
              minimumSize: const Size(double.infinity, 160),
            ),
            onPressed: () => MemoryGameSelectDialog.showSelectDialog(context),
          ),
        ),
      ),
    );
  }
}
