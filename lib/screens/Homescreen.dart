import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rememberme/Screens/MemorySelect.dart';
import 'package:rememberme/screens/CardView.dart';
import 'package:rememberme/screens/Stats.dart';
import 'package:rememberme/screens/deckview.dart';
import 'package:rememberme/screens/modifycard.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:rememberme/widgets/roundedpage.dart';
import 'package:icon_decoration/icon_decoration.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Future<Deck> deckFuture = DeckService.getMasterDeck();
  Future<List<Deck>> _decksFuture = DeckService.getAllDecks();
  List<Deck> _decks = [];

  @override
  Widget build(BuildContext context) {
    return
      RoundedPage(
        title: 'Welcome',
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

          Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(40, 90, 0, 0)
                ),

                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[


                    Icon(
                      Icons.circle,
                      size: 70,
                      color: Color.fromARGB(90,60,200,10),
                    ),

                    DecoratedIcon(
                      icon: Icon(
                          Icons.star,
                          size: 30,
                          color: Colors.yellow
                      ),
                      decoration: IconDecoration(
                      shadows: [Shadow(blurRadius: 30, offset: Offset(1, 0), color: Colors.brown)],
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Color(0xfffaf8f8),
                              Color(0xfffae16c),
                              Color.fromARGB(128, 250, 148, 75),
                            ],
                          )
                      )
                    ),

                  ],
                ),

                Container(
                    margin: EdgeInsets.fromLTRB(20, 90, 10, 0)
                ),

                Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 5),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Stats()),
                            );
                          },
                          child: Text('Achievement'),
                        ),
                      ),



                      //For the actual achievement---------------------
                      FutureBuilder(future: deckFuture, builder: (ctxt, snapshot)
                      {
                        if (snapshot.hasData) {
                          return
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                '${snapshot.data!.cards.length} cards added',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            );

                        }
                        else {
                          return CircularProgressIndicator();
                        }
                      }),
                    ]
                ),

                Container(
                    margin: EdgeInsets.fromLTRB(20, 90, 10, 0)
                ),
            ],
          ),

          //To add a logo image:
          // new SizedBox(
          //   height: 100,
          //   width: 100,
          //   child: Image.asset('assets/logo.png')
          // ),



          //THIS CONTAINER IS FOR THE "Decks" TEXT
          Container(
            margin: const EdgeInsets.fromLTRB(0, 40, 0, 10),
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
                backgroundColor: Color.fromARGB(170,60,200,10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 30,
                ),
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                textStyle: TextStyle(fontSize: 25),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MemorySelect()),
                );
              },
              child: Text('Memory Games'),
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 25),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(170,60,200,10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 30,
                ),
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                textStyle: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Stats()),
                );
              },
              child: Text(' View Statistics '),
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
