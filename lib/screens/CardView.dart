import 'package:flutter/material.dart';
import 'package:rememberme/screens/modifycard.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/widgets/catchpop.dart';
import 'package:rememberme/widgets/roundedpage.dart';

class CardView extends StatefulWidget {
  final PersonCard initialCard;

  const CardView({super.key, required this.initialCard});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  late PersonCard _card;

  @override
  void initState() {
    _card = widget.initialCard;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CatchPop(
      popValue: _card,
      child: RoundedPage(
        title: _card.name,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            PersonCard? res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ModifyCard(
                  existingCard: _card,
                ),
              ),
            );
            if (res != null) {
              setState(() {
                _card = res;
              });
            }
          },
          child: const Icon(Icons.edit),
        ),
        onRefresh: () async {
          var newCard = await CardService.getById(_card.id);
          setState(() {
            _card = newCard;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _card.questions.entries.map((question) {
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              color: Theme.of(context).primaryColorLight,
              child: ListTile(
                title: Text(question.key),
                subtitle: Text(question.value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
