import 'package:flutter/material.dart';
import 'package:rememberme/screens/CardView.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:rememberme/widgets/catchpop.dart';
import 'package:rememberme/widgets/roundedpage.dart';

import '../services/cardservice.dart';

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
              child: InkWell(
                onTap: () async {
                  PersonCard? res = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CardView(initialCard: card),
                    ),
                  );
                  var newDeck = await DeckService.getDeckById(_deck.id);
                  setState(() {
                    _deck = newDeck;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(card.name),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
