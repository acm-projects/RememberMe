import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/services/cardservice.dart';

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

  @override
  void initState() {
    if (widget.existingCard != null) {
      _name = widget.existingCard!.data.name;
      widget.existingCard!.data.questions.forEach((key, value) {
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
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  initialValue: _name,
                  onSaved: (newValue) => _name = newValue,
                ),
              ),
            ),
            ..._questionWidgets,
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _questionWidgets.add(
                    _getDefaultQuestionWidget(null, null),
                  );
                });
              },
              child: const Text('Add New Section'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _questions = {}; // Clear old values
                  _formKey.currentState!.save();
                  _saveCard();
                }
              },
              child: const Text('Save'),
            ),
          ],
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

  void _saveCard() {
    var data = PersonCardData(
      name: _name!,
      questions: _questions,
    );

    try {
      if (widget.existingCard == null) {
        CardService.addCard(data);
      } else {
        CardService.modifyCard(
          PersonCard(
            widget.existingCard!.id,
            data,
          ),
        );
      }
      Navigator.pop(context);
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
          initialValue: MapEntry(initialQuestion, initialQuestion),
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
