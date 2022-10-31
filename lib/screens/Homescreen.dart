import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rememberme/screens/CardView.dart';
import 'package:rememberme/screens/deckview.dart';
import 'package:rememberme/screens/modifycard.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:rememberme/widgets/roundedpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<List<Deck>> _decksFuture = DeckService.getAllDecks();
  List<Deck> _decks = [];

  @override
  Widget build(BuildContext context) {
    return RoundedPage(
      title: 'Welcome!',
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            label: 'New Card',
            child: const Icon(Icons.note_add),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ModifyCard()),
            ),
          ),
          SpeedDialChild(
            label: 'New Deck',
            child: const Icon(Icons.collections_bookmark),
          ),
        ],
      ),
      appBarActions: [
        IconButton(
          onPressed: () {
            // method to show the search bar
            showSearch(
                context: context,
                // delegate to customize the search bar
                delegate: _CustomSearchDelegate(
                  cards: _decks.firstWhere((elem) => elem.isMaster).cards,
                ));
          },
          icon: const Icon(Icons.search),
        )
      ],
      child: Column(
        children: <Widget>[
          //For achievement heading on the Homepage--------------------------
          Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: Text(
              'Achievement:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          //For the actual achievement---------------------
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              'Added 10 cards!',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),

          //THIS CONTAINER IS FOR THE "Decks" TEXT
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: const Text(
              'Decks',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),

          //THIS IS TO SET UP THE CAROUSEL
          FutureBuilder<List<Deck>>(
            future: _decksFuture,
            builder: (context, snapshot) {
              List<Widget> items = [];

              if (snapshot.hasData || snapshot.hasError) {
                if (snapshot.data != null) {
                  _decks = snapshot.data!;
                  items = _decks.map((deck) {
                    return Card(
                      color: Theme.of(context).primaryColorLight,
                      child: InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DeckView(
                                initialDeck: deck,
                              ),
                            ),
                          );
                          setState(() {
                            _decksFuture = DeckService.getAllDecks();
                          });
                        },
                        child: Center(
                            child: Text(
                          deck.name,
                          style: const TextStyle(fontSize: 22),
                        )),
                      ),
                    );
                  }).toList();
                } else {
                  items = [
                    const Card(
                      child: Center(
                        child: Text('There was an error loading decks.'),
                      ),
                    ),
                  ];
                }
              } else {
                items = [
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ];
              }

              return CarouselSlider(
                options: CarouselOptions(
                  height: 160.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  aspectRatio: 2.0,
                ),
                items: items,
              );
            },
          ),

          //THIS IS FOR A TEXT BUTTON TO SELECT 'Memory Games'
          //CHANGE ON-PRESSED ACTION TO GO TO ANOTHER SCREEN
          Container(
            margin: EdgeInsets.fromLTRB(25, 40, 25, 25),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColorDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 30,
                ),
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                textStyle: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                print('Pressed');
              },
              child: Text('Memory Games'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSearchDelegate extends SearchDelegate {
  final List<PersonCard> cards;

  _CustomSearchDelegate({required this.cards});

  //MORE CODE FOR MAKING THE SEARCHBAR WORK:
  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    return _getListWidgetFromQuery();
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    return _getListWidgetFromQuery();
  }

  Widget _getListWidgetFromQuery() {
    List<PersonCard> matchQuery = [];
    for (var card in cards) {
      if (card.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(card);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CardView(initialCard: result),
            ),
          ),
        );
      },
    );
  }
}
