import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/screens/MemoryGame.dart';
import 'package:rememberme/services/deckservice.dart';

class MemoryGameSelectDialog extends StatefulWidget {
  const MemoryGameSelectDialog({
    super.key,
    required this.decks,
  }) : assert(decks.length > 0);

  final List<Deck> decks;

  static Future<void> showSelectDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: DeckService.getAllDecks(),
          builder: (context, snapshot) {
            if (snapshot.hasData || snapshot.hasError) {
              if (snapshot.data != null) {
                return MemoryGameSelectDialog(
                  decks: snapshot.data!,
                );
              }
              return AlertDialog(
                content: const Text('Failed to load decks.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Exit'),
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }

  @override
  State<MemoryGameSelectDialog> createState() => _MemoryGameSelectDialogState();
}

class _MemoryGameSelectDialogState extends State<MemoryGameSelectDialog> {
  late Deck _selectedDeck;
  List<Deck> _sortedDecks = [];

  @override
  void initState() {
    super.initState();
    _selectedDeck = widget.decks.firstWhere((deck) => deck.isMaster);
    _sortedDecks = widget.decks.sublist(0);
    _sortedDecks.sort(
      (a, b) => _getQuestionCount(b).compareTo(_getQuestionCount(a)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a deck'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back'),
        ),
      ],
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          padding: const EdgeInsets.all(4),
          children: _sortedDecks.map(
            (deck) {
              var qCount = _getQuestionCount(deck);
              var color = qCount > 5
                  ? Theme.of(context).primaryColorLight
                  : const Color(0xffcccccc);
              return Card(
                color: color,
                child: InkWell(
                  onTap: () {
                    if (qCount > 5) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MemoryGame(
                            deck: _selectedDeck,
                          ),
                        ),
                      );
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AutoSizeText(
                        deck.name,
                        textAlign: TextAlign.center,
                        minFontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  int _getQuestionCount(Deck deck) {
    return deck.cards.fold(
      0,
      (val, card) => val + card.questions.length,
    );
  }
}
