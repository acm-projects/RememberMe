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
      _questionWidgets.add(_getDefaultQuestionWidget(null, null));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  initialValue: _name,
                  onSaved: (newValue) => _name = newValue!,
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
        ),
      ),
    );
  }

  _QuestionWidget _getDefaultQuestionWidget(String? question, String? answer) {
    return _QuestionWidget(
      initialQuestion: question,
      initialAnswer: answer,
      onSaved: (newValue) {
        // Assume not-null because save is called after validation
        _questions[newValue!.key!] = newValue.value!;
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
    } catch (e) {}
  }
}

class _QuestionWidget extends FormField<MapEntry<String?, String?>> {
  final String? initialQuestion, initialAnswer;

  _QuestionWidget({
    this.initialQuestion,
    this.initialAnswer,
    FormFieldSetter<MapEntry<String?, String?>>? onSaved,
  }) : super(
          onSaved: onSaved,
          builder: (FormFieldState<MapEntry<String?, String?>> state) {
            return Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Question'),
                  initialValue: initialQuestion,
                  onChanged: (value) {
                    state.didChange(MapEntry(value, state.value?.value ?? ''));
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Answer'),
                  initialValue: initialAnswer,
                  onChanged: (value) {
                    state.didChange(MapEntry(state.value?.key ?? '', value));
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an answer';
                    }
                    return null;
                  },
                ),
              ],
            );
          },
        );
}
