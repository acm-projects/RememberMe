import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/CustomStatsWidget.dart';
import 'package:rememberme/services/deckservice.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _Stats();
}

class _Stats extends State<Stats> {
  final Future<Deck> deckFuture = DeckService.getMasterDeck();

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
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
            backgroundColor: Color.fromARGB(255, 253, 142, 84),
          )
      ),




      body: Column(
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

            CustomStats(
                titleText: "High Score Today",
                achievement: "Memory Game: 90%"
            ),
            CustomStats(
                titleText: "Days in a Row",
                achievement: "5 Days in a Row"
            ),
          ]
      ),
    );
  }
}




