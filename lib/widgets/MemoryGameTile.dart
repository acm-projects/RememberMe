import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/controllers/MemoryGameController.dart';
import 'package:rememberme/services/cardservice.dart';

class MemoryGameTile extends StatefulWidget {
  const MemoryGameTile({
    required super.key,
    required this.card,
    required this.data,
    required this.isQuestion,
    required this.controller,
  });

  final PersonCard card;
  final String data;
  final bool isQuestion;
  final MemoryGameController controller;

  @override
  State<MemoryGameTile> createState() => _MemoryGameTileState();
}

class _MemoryGameTileState extends State<MemoryGameTile>
    with TickerProviderStateMixin {
  late AnimationController _selectAnimationController;
  late Animation<double> _selectAnimation;
  bool _selected = false;

  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  late AnimationController _colorAnimationController;
  late Animation<Color?> _colorAnimation;

  late ValueNotifier<Key?> _instanceNotifier;

  @override
  void initState() {
    super.initState();

    // SELECTION ANIMATION
    _selectAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _selectAnimation = CurvedAnimation(
      parent: _selectAnimationController,
      curve: Curves.linearToEaseOut,
    );
    _selectAnimation.addListener(() => setState(() {}));

    // COLOR ANIMATION
    var baseColor =
        widget.isQuestion ? const Color(0xFFBFEBE3) : const Color(0xFFF8D7A7);
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 0.5,
    );
    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(
          begin: const Color(0xFFC3EB70),
          end: baseColor,
        ),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: baseColor,
          end: const Color(0xFFF77272),
        ),
        weight: 0.5,
      )
    ]).animate(_colorAnimationController);
    _colorAnimation.addListener(() => setState(() {}));

    // FADE ANIMATION
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    );
    _fadeAnimation.addListener(() => setState(() {}));

    // LISTENERS FOR UPDATING SELECT ANIMATION
    if (widget.isQuestion) {
      _instanceNotifier = widget.controller.questionNotifier;
    } else {
      _instanceNotifier = widget.controller.answerNotifier;
    }
    _instanceNotifier.addListener(() {
      // Update the select visuals for any tile that needs it
      if (_instanceNotifier.value == widget.key && !_selected) {
        setState(() {
          _selected = true;
          _selectAnimationController.forward();
        });
      } else if (_instanceNotifier.value != widget.key && _selected) {
        setState(() {
          _selected = false;
          _selectAnimationController.reverse();
        });
      }
    });

    // LISTENERS FOR WRONG/CORRECT GUESSES
    widget.controller.guessNotifier.addListener(() async {
      var guess = widget.controller.guessNotifier.value;
      if (guess != null) {
        if (widget.key == guess.item2 || widget.key == guess.item3) {
          if (guess.item1) {
            _colorAnimationController.animateTo(0);
            _fadeAnimationController.forward();
          } else {
            await _colorAnimationController.forward();
            _colorAnimationController.animateTo(0.5);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1 - _fadeAnimation.value,
      child: Card(
        margin: EdgeInsets.all((1 - _selectAnimation.value) * 4 + 2),
        elevation: _selectAnimation.value * 6,
        color: _colorAnimation.value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6 * (1 - _selectAnimation.value) + 14),
          ),
        ),
        child: InkWell(
          onTap: () {
            if (_instanceNotifier.value == widget.key) {
              _instanceNotifier.value = null;
            } else {
              _instanceNotifier.value = widget.key;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridTile(
              header: widget.isQuestion
                  ? Text(
                      widget.card.name,
                      textAlign: TextAlign.center,
                    )
                  : null,
              child: Padding(
                padding: EdgeInsets.only(top: (widget.isQuestion ? 16 : 0)),
                child: Center(
                  child: AutoSizeText(
                    widget.data,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    wrapWords: false,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _selectAnimationController.dispose();
    super.dispose();
  }
}
