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

  @override
  void initState() {
    super.initState();
    _selectedDeck = widget.decks.firstWhere((deck) => deck.isMaster);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MemoryGame(
                deck: _selectedDeck,
              ),
            ),
          ),
          child: const Text('Play!'),
        ),
      ],
      content: Column(
        children: widget.decks.map(
          (deck) {
            var qCount = deck.cards.fold(
              0,
              (val, card) => val + card.questions.length,
            );
            return RadioListTile(
              groupValue: _selectedDeck,
              value: deck,
              onChanged: (value) {
                if (value != null && qCount >= 5) {
                  setState(() {
                    _selectedDeck = value;
                  });
                }
              },
              title: Text(
                deck.name,
                style: TextStyle(
                  color: qCount >= 5 ? Colors.black : Colors.grey,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
