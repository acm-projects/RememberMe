import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rememberme/screens/CardView.dart';
import 'package:rememberme/screens/modifydeck.dart';
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
        floatingActionButton: _deck.isMaster
            ? null
            : Hero(
                tag: 'deckCardViewFloatingButton',
                child: SpeedDial(
                  spaceBetweenChildren: 10,
                  children: [
                    SpeedDialChild(
                      label: 'Edit Deck',
                      child: const Icon(Icons.edit),
                      onTap: () async {
                        Deck? res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ModifyDeck(existingDeck: _deck),
                          ),
                        );
                        if (res != null) {
                          setState(() {
                            _deck = res;
                          });
                        }
                      },
                    ),
                    SpeedDialChild(
                      label: 'Delete Deck',
                      child: const Icon(Icons.delete),
                      onTap: () async {
                        await DeckService.deleteDeck(_deck.id);
                        if (mounted) Navigator.of(context).pop();
                      },
                    ),
                  ],
                  activeChild: const Icon(Icons.close),
                  child: const Icon(Icons.settings),
                ),
              ),
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
                leading: Hero(
                  tag: card.id,
                  child: CardAvatar(
                    card: card,
                    radius: 24,
                  ),
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
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      childCurrent: widget,
                      child: CardView(
                        initialCard: card,
                      ),
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
        //child:
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
