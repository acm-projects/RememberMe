import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/userservice.dart';
import '../widgets/CustomStatsWidget.dart';
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
    return Scaffold(
      appBar: PreferredSize(
        //WITHIN THE APPBAR, FIRSTLY DEALING WITH CHANGED SIZE
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            //HERE WE ADD A BACK BUTTON (CONNECT SCREEN LATER)
            automaticallyImplyLeading: false,
            leadingWidth: 100,
            leading: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_left, size: 45),
                label: const Text(''),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent)),

            //THIS ADDS THE TEXT IN THE APPBAR
            title: Text('Statistics'),
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold
            ),
            backgroundColor: Color.fromARGB(255, 253, 142, 84),
          )
      ),




      body: ListView(
          children: <Widget>[
            //For achievement heading on the Homepage-------------------------

            FutureBuilder(future: deckFuture, builder: (ctxt, snapshot)
            {
              if (snapshot.hasData) {
                return CustomStats(
                  titleText: "Cards Added",
                  achievement: "${snapshot.data!.cards.length} cards added!",
                );
              }
              else {
                return CircularProgressIndicator();
              }
            }),

            FutureBuilder(future: allDeckFuture, builder: (ctxt, snapshot)
            {
              if (snapshot.hasData) {
                return CustomStats(
                  titleText: "Number of Decks",
                  achievement: "${snapshot.data!.length} deck(s)",
                );
              }
              else {
                return CircularProgressIndicator();
              }
            }),

            FutureBuilder(future: allDeckFuture, builder: (ctxt, snapshot)
            {
              if (snapshot.hasData) {
                var master = snapshot.data!.firstWhere((element) => element.isMaster);
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
                sorted.sort((a,b)=>a.value.compareTo(b.value));
                var commonname = sorted.last;

                return CustomStats(
                  titleText: "Most Common",
                  achievement: "${commonname.value} ${commonname.key}(s)",
                );
              }
              else {
                return CircularProgressIndicator();
              }
            }),

            FutureBuilder(future: date, builder: (ctxt, snapshot)
            {
              if (snapshot.hasData) {

                return CustomStats(
                  titleText: "Days in a Row",
                  achievement: "${snapshot.data!}",
                );
              }
              else {
                return CircularProgressIndicator();
              }
            }),

            CustomStats(
                titleText: "High Score Today",
                achievement: "Memory Game: 90%"
            ),

          ]
      ),
    );
  }
}




