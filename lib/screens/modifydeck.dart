import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:rememberme/widgets/cardavatar.dart';
import 'package:rememberme/widgets/catchpop.dart';
import 'package:rememberme/widgets/roundedpage.dart';

class ModifyDeck extends StatefulWidget {
  const ModifyDeck({super.key, this.existingDeck});

  final Deck? existingDeck;

  @override
  State<StatefulWidget> createState() => _ModifyDeckState();
}

class _ModifyDeckState extends State<ModifyDeck> {
  final _formKey = GlobalKey<FormState>();
  final _masterDeckFuture = DeckService.getMasterDeck();

  String? _name;
  List<String> _selectedCards = [];

  @override
  void initState() {
    if (widget.existingDeck != null) {
      _selectedCards = widget.existingDeck!.cards.map((e) => e.id).toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedPage(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveDeck(),
        child: const Icon(Icons.save),
      ),
      title: _name ?? 'New Deck',
      child: CatchPop(
        withConfirmExit: true,
        child: FutureBuilder(
          future: _masterDeckFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData || snapshot.hasError) {
              if (snapshot.data != null) {
                return _getLoadedBody(snapshot.data!);
              } else {
                return const Text(
                  'Failed to load cards. Please try again later',
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _getLoadedBody(Deck masterDeck) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'Deck Name'),
                  style: TextStyle(fontSize: 20),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  initialValue: _name,
                  onChanged: (value) => setState(() => _name = value),
                  onSaved: (newValue) => _name = newValue,
                ),
              ),
            ),
            ...masterDeck.cards.map((card) {
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  secondary: CardAvatar(
                    card: card,
                    radius: 24,
                  ),
                  title: Text(card.name),
                  onChanged: (bool? value) {
                    if (value == true) {
                      if (!_selectedCards.contains(card.id)) {
                        setState(() {
                          _selectedCards.add(card.id);
                        });
                      }
                    } else if (value == false) {
                      if (_selectedCards.contains(card.id)) {
                        setState(() {
                          _selectedCards.remove(card.id);
                        });
                      }
                    }
                  },
                  value: _selectedCards.contains(card.id),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDeck() async {
    if (!_formKey.currentState!.validate()) return;
    var name = _name!; // Not null because of validation

    try {
      Deck newDeck;
      if (widget.existingDeck == null) {
        newDeck = await DeckService.addAndReturnDeck(name, _selectedCards);
      } else {
        newDeck = await DeckService.modifyDeck(
          widget.existingDeck!.id,
          name,
          _selectedCards,
        );
      }
      if (mounted) Navigator.of(context).pop(newDeck);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'There was an unknown error.'),
        ),
      );
    }
  }
}
