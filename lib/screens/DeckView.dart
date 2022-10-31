import 'package:flutter/material.dart';
import 'package:rememberme/screens/CardView.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:rememberme/widgets/cardavatar.dart';
import 'package:rememberme/widgets/catchpop.dart';
import 'package:rememberme/widgets/roundedpage.dart';

class DeckView extends StatefulWidget {
  const DeckView({super.key, required this.initialDeck});

  final Deck initialDeck;

  @override
  State<DeckView> createState() => _DeckViewState();
}

class _DeckViewState extends State<DeckView> {
  late Deck _deck;

  @override
  void initState() {
    _deck = widget.initialDeck;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CatchPop(
      popValue: _deck,
      child: RoundedPage(
        title: _deck.name,
        onRefresh: () async {
          var newDeck = await DeckService.getDeckById(_deck.id);
          setState(() {
            _deck = newDeck;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _deck.cards.map((card) {
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              color: Theme.of(context).primaryColorLight,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                leading: CardAvatar(
                  card: card,
                  radius: 24,
                ),
                trailing: IconButton(
                  icon: Icon(
                    _deck.isMaster ? Icons.delete_forever : Icons.close,
                  ),
                  onPressed: () => _showCardDeleteDialog(card),
                ),
                title: Text(card.name),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CardView(initialCard: card),
                    ),
                  );
                  var newDeck = await DeckService.getDeckById(_deck.id);
                  setState(() {
                    _deck = newDeck;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _showCardDeleteDialog(PersonCard card) async {
    if (_deck.isMaster) {
      var res = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Warning'),
          content: const Text(
            'Are you sure you want to delete this card forever?',
          ),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.pop(ctx, false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.pop(ctx, true),
            ),
          ],
        ),
      );
      if (res != true) return;
      await CardService.deleteCard(card.id);
    } else {
      await DeckService.assignCardsToDecks(
        cardIds: [card.id],
        removeDecksIds: [_deck.id],
      );
    }
    setState(() {
      _deck.cards.removeWhere((elem) => elem.id == card.id);
    });
  }
}
