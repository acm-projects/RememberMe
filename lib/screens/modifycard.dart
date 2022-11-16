import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:rememberme/widgets/cardavatar.dart';
import 'package:rememberme/widgets/catchpop.dart';
import 'package:rememberme/widgets/roundedpage.dart';

class ModifyCard extends StatefulWidget {
  const ModifyCard({super.key, this.existingCard});

  final PersonCard? existingCard;

  @override
  State<StatefulWidget> createState() => _ModifyCardState();
}

class _ModifyCardState extends State<ModifyCard> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  Map<String, String> _questions = {};
  final List<_QuestionWidget> _questionWidgets = [];
  File? _cardImage;

  List<String> _selectedDecks = [];
  Future<Map<String, String>>? _decksFuture;

  @override
  void initState() {
    if (widget.existingCard != null) {
      _name = widget.existingCard!.name;
      widget.existingCard!.questions.forEach((key, value) {
        _questionWidgets.add(
          _getDefaultQuestionWidget(key, value),
        );
      });
    } else {
      _questionWidgets.add(
        _getDefaultQuestionWidget(null, null),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedPage(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveCard(),
        child: const Icon(Icons.save),
      ),
      title: _name ?? 'New Card',
      child: CatchPop(
        withConfirmExit: true,
        child: Form(
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
                    child: Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.only(right: 8),
                          splashRadius: 12,
                          icon: CardAvatar(
                            card: widget.existingCard,
                            providerOverride: _cardImage != null
                                ? Image.file(_cardImage!).image
                                : null,
                          ),
                          onPressed: () => _showImagePickerDialog(),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(hintText: 'Name'),
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
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: TextButton.icon(
                      onPressed: () => _showDeckDialog(),
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      label: Text(
                        ' Add to Deck(s)',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
                ..._questionWidgets,
                RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      _questionWidgets.add(
                        _getDefaultQuestionWidget(null, null),
                      );
                    });
                  },
                  fillColor: Theme.of(context).primaryColor,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _QuestionWidget _getDefaultQuestionWidget(String? question, String? answer) {
    return _QuestionWidget(
      initialQuestion: question,
      initialAnswer: answer,
      key: UniqueKey(),
      onSaved: (newValue) {
        // Assume not-null because save is called after validation
        _questions[newValue!.key!] = newValue.value!;
      },
      onDelete: (key) {
        setState(() {
          _questionWidgets.removeWhere((element) => element.key == key);
        });
      },
    );
  }

  void _showDeckDialog() {
    // Dont make a request for decks until theyre needed. This will
    // also cache the result
    _decksFuture ??= DeckService.getAllDeckDocs().then((docs) {
      Map<String, String> decks = {};
      for (var doc in docs) {
        var data = doc.data();
        decks[doc.id] = data['name'];
        if (widget.existingCard != null) {
          List cards = data['cards'];
          if (cards.contains(widget.existingCard!.id)) {
            _selectedDecks.add(doc.id);
          }
        }
      }
      return decks;
    });

    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder(
        future: _decksFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.hasError) {
            if (snapshot.data != null) {
              // SHOW ACTUAL OPTIONS:
              return MultiSelectDialog(
                title: const Text('Select Deck(s)'),
                searchable: true,
                items: snapshot.data!.entries
                    .map((deck) => MultiSelectItem(deck.key, deck.value))
                    .toList(),
                initialValue: _selectedDecks,
                onConfirm: (values) => _selectedDecks = values,
              );
            } else {
              // SHOW ERROR MESSAGE
              return const AlertDialog(
                content: Text('There was an error.'),
              );
            }
          } else {
            // SHOW LOADING SCREEN:
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _showImagePickerDialog() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (image != null) {
      setState(() {
        _cardImage = File(image.path);
      });
    }
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) return;
    _questions = {}; // Clear old values
    _formKey.currentState!.save();

    try {
      PersonCard card;
      if (widget.existingCard == null) {
        card = await CardService.addCard(
          name: _name!,
          questions: _questions,
        );
      } else {
        card = await CardService.modifyCard(PersonCard(
          id: widget.existingCard!.id,
          name: _name!,
          questions: _questions,
        ));
      }
      // Update image if needed
      if (_cardImage != null) {
        var err = await CardService.updateCardImage(card.id, _cardImage!);
        if (err != null) {
          // Recreate the error because firebase is stupid
          throw err;
        }
      }

      // Only update decks if the deck status was requested at all
      if (_decksFuture != null) {
        var allDecks = await _decksFuture!;
        var removeDecks =
            allDecks.keys.where((e) => !_selectedDecks.contains(e)).toList();
        await DeckService.assignCardsToDecks(
          cardIds: [card.id],
          addDecksIds: _selectedDecks,
          removeDecksIds: removeDecks,
        );
      }

      if (mounted) Navigator.of(context).pop(card);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'There was an unknown error.'),
        ),
      );
    }
  }
}

class _QuestionWidget extends FormField<MapEntry<String?, String?>> {
  _QuestionWidget({
    Key? key,
    initialQuestion,
    initialAnswer,
    FormFieldSetter<MapEntry<String?, String?>>? onSaved,
    void Function(Key? key)? onDelete,
  }) : super(
          onSaved: onSaved,
          key: key,
          initialValue: MapEntry(initialQuestion, initialAnswer),
          builder: (FormFieldState<MapEntry<String?, String?>> state) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'Prompt'),
                          style: TextStyle(fontSize: 21),
                          initialValue: initialQuestion,
                          onChanged: (value) {
                            state.didChange(
                              MapEntry(value, state.value?.value),
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a prompt';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'Answer'),
                          style: TextStyle(fontSize: 21),
                          initialValue: initialAnswer,
                          onChanged: (value) {
                            state.didChange(
                              MapEntry(state.value?.key, value),
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an answer';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    Positioned(
                      top: -16,
                      right: -16,
                      child: IconButton(
                        iconSize: 24,
                        splashRadius: 24,
                        onPressed: (() {
                          if (onDelete != null) onDelete(key);
                        }),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
}
