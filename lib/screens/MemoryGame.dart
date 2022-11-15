import 'package:flutter/material.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/services/deckservice.dart';

class MemoryGame extends StatefulWidget
{
  MemoryGame({super.key, required this.deck});

  final Deck deck;

  @override
  State<StatefulWidget> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<_TileData> tileDataList = [];

  @override
  void initState() {
    super.initState();
    List<List<_TileData>> tileDataPairs = [];
    widget.deck.cards.forEach((element) {
      element.questions.entries.forEach((entry) {
        tileDataPairs.add([
          _TileData(card: element, data: entry.key, isQuestion: true),
          _TileData(card: element, data: entry.value, isQuestion: false),
        ]);
      });
    });

    tileDataPairs.shuffle();
    tileDataPairs = tileDataPairs.sublist(0,5); // Get first 5 pairs
    tileDataList = tileDataPairs.expand((i) => i).toList(); // Flatten Array
    tileDataList.shuffle();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ready To Remember?',
          style: TextStyle(
            color: const Color.fromRGBO(255, 164, 116, 1),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            }

        ), // IconButton
      ),
      body: buildGridView(),
    );
  }

  Widget buildGridView() => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1/.80
    ),
    padding: const EdgeInsets.all(16),

    itemCount: tileDataList.length,
    itemBuilder: (context, index){
      final item = tileDataList[index];

      return buildNumber(item);
    },
  );

  Widget buildNumber(_TileData data) => Container(
    padding: EdgeInsets.all(16.0),
    color: Color.fromRGBO(92, 193, 175, 100),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),

    ),

    child: GridTile(
      header: Text(
        data.card.name,
        textAlign: TextAlign.center,
      ),
      child: Center(
        child: Text(
          data.data,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

class _TileData {
  final PersonCard card;
  final String data;
  final bool isQuestion;

  _TileData({required this.card, required this.data, required this.isQuestion});
}

// body: SafeArea(
//   child: Column(
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.all(16.0),
//          child: GridView.builder(
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//              itemBuilder: (context, index) => Container(
//                margin: EdgeInsets.all(4.0),
//                color: const Color.fromRGBO(92, 193, 175, 100),
//              ),
//            itemCount: 5,
//          ),
//        )
//      ],
//   )
// ),


// body: Stack(
//   alignment: Alignment.topLeft,
//   children: [
//     Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//       ),
//       child: Column(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//               itemBuilder: (context, index) => Container(
//                 margin: EdgeInsets.all(4.0),
//                 color: const Color.fromRGBO(92, 193, 175, 100),
//               ),
//               itemCount: 5,
//             ),
//           )
//         ],
//
//       ),
//     )
//   ],
// ),