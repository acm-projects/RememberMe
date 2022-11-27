import 'package:flutter/material.dart';
import 'package:rememberme/controllers/MemoryGameController.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:rememberme/widgets/MemoryGameTile.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key, required this.deck});

  final Deck deck;

  @override
  State<StatefulWidget> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<MemoryGameTile> _tileWidgets = [];
  late MemoryGameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MemoryGameController(onGameEnd: onGameEnd);
    List<List<MemoryGameTile>> widgetPairs = [];
    for (var card in widget.deck.cards) {
      for (var entry in card.questions.entries) {
        widgetPairs.add([
          // Question first always
          MemoryGameTile(
            key: UniqueKey(),
            card: card,
            data: entry.key,
            isQuestion: true,
            controller: _controller,
          ),
          MemoryGameTile(
            key: UniqueKey(),
            card: card,
            data: entry.value,
            isQuestion: false,
            controller: _controller,
          ),
        ]);
      }
    }

    widgetPairs.shuffle();
    assert(widgetPairs.length >= 5); // Decks should be checked before
    widgetPairs = widgetPairs.sublist(0, 5);
    for (var pair in widgetPairs) {
      _controller.registerPair(question: pair[0].key!, answer: pair[1].key!);
    }
    _tileWidgets = widgetPairs.expand((i) => i).toList(); // Flatten list
    _tileWidgets.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ready To Remember?',
          style: TextStyle(
            color: Color.fromRGBO(255, 164, 116, 1),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ), // IconButton
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: getGridChildAspectRatio(4),
        ),
        padding: const EdgeInsets.all(4),
        children: _tileWidgets,
      ),
    );
  }

  double getGridChildAspectRatio(double padding) {
    // https://stackoverflow.com/questions/48405123
    var size = MediaQuery.of(context).size;
    final pad = padding * 2;
    final double itemHeight = (size.height - kToolbarHeight - 24 - pad) / 5;
    final double itemWidth = (size.width - pad) / 2;
    return itemWidth / itemHeight;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onGameEnd() {
    // add end game logic here
  }
}
