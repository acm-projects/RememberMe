import 'package:flutter/material.dart';
import 'package:rememberme/widgets/roundedpage.dart';
import 'package:rememberme/services/userservice.dart';
import 'package:rememberme/widgets/CustomStatsWidget.dart';
import 'package:rememberme/services/deckservice.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _Stats();
}

class _Stats extends State<Stats> {
  final Future<Deck> deckFuture = DeckService.getMasterDeck();
  final Future<List<Deck>> allDeckFuture = DeckService.getAllDecks();
  final Future<int> date = UserService.getDaysLogged();

  @override
  Widget build(BuildContext context) {
    return RoundedPage(
      title: 'Statistics',
      child: Column(
        children: [
          FutureBuilder(
            future: deckFuture,
            builder: (ctxt, snapshot) {
              if (snapshot.hasData) {
                return CustomStats(
                  titleText: "Cards Added",
                  achievement: "${snapshot.data!.cards.length} cards added!",
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          FutureBuilder(
            future: allDeckFuture,
            builder: (ctxt, snapshot) {
              if (snapshot.hasData) {
                return CustomStats(
                  titleText: "Number of Decks",
                  achievement: "${snapshot.data!.length} deck(s)",
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          FutureBuilder(
            future: allDeckFuture,
            builder: (ctxt, snapshot) {
              if (snapshot.hasData) {
                var master =
                    snapshot.data!.firstWhere((element) => element.isMaster);
                Map<String, int> map = {};
                for (var card in master.cards) {
                  final split = card.name.split(' ');
                  final firstname = split[0];
                  if (!map.containsKey(firstname)) {
                    map[firstname] = 0;
                  }
                  map[firstname] = map[firstname]! + 1;
                }
                var sorted = map.entries.toList();
                sorted.sort((a, b) => a.value.compareTo(b.value));
                var commonname = sorted.last;

                return CustomStats(
                  titleText: "Most Common",
                  achievement: "${commonname.value} ${commonname.key}(s)",
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          FutureBuilder(
              future: date,
              builder: (ctxt, snapshot) {
                if (snapshot.hasData) {
                  return CustomStats(
                    titleText: "Days in a Row",
                    achievement: "${snapshot.data!}",
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          const CustomStats(
            titleText: "High Score Today",
            achievement: "Memory Game: 100%",
          ),
        ],
      ),
    );
  }
}
