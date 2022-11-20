import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

class MemoryGameController {
  MemoryGameController() {
    questionNotifier.addListener(() => _checkForAnswer());
    answerNotifier.addListener(() => _checkForAnswer());
  }

  final ValueNotifier<Key?> questionNotifier = ValueNotifier(null);
  final ValueNotifier<Key?> answerNotifier = ValueNotifier(null);

  final ValueNotifier<Tuple3<bool, Key, Key>?> _guessNotifier =
      ValueNotifier(null);
  ValueNotifier<Tuple3<bool, Key, Key>?> get guessNotifier => _guessNotifier;

  int _correctGuesses = 0;
  int _wrongGuesses = 0;
  int get correctGuesses => _correctGuesses;
  int get wrongGuesses => _wrongGuesses;

  final Map<Key, Key> _pairs = {};
  void registerPair({required Key question, required Key answer}) {
    _pairs[question] = answer;
  }

  void dispose() {
    questionNotifier.dispose();
    answerNotifier.dispose();
    _guessNotifier.dispose();
  }

  void _checkForAnswer() {
    var qVal = questionNotifier.value;
    var aVal = answerNotifier.value;
    if (qVal != null && aVal != null) {
      if (_pairs.containsKey(qVal)) {
        var correct = _pairs[qVal] == aVal;
        var tuple = Tuple3(correct, qVal, aVal);
        if (_guessNotifier.value == tuple) {
          // Set notifier to a temp value if the value hasn't changed
          _guessNotifier.value = null;
        }
        _guessNotifier.value = tuple;
        if (correct) {
          _correctGuesses++;
        } else {
          _wrongGuesses++;
        }

        questionNotifier.value = null;
        answerNotifier.value = null;
      }
    }
  }
}
