import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rememberme/screens/CardView.dart';
import 'package:rememberme/screens/Stats.dart';
import 'package:rememberme/screens/modifycard.dart';
import 'package:rememberme/screens/profile.dart';
import 'package:rememberme/screens/modifydeck.dart';
import 'package:rememberme/screens/qrscan.dart';
import 'package:rememberme/screens/qrview.dart';
import 'package:rememberme/services/authservice.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:rememberme/widgets/MemoryGameButton.dart';
import 'package:rememberme/widgets/deckcarousel.dart';
import 'package:rememberme/widgets/roundedpage.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:rememberme/widgets/useravatar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<PersonCard> _masterCardList = [];

  @override
  void initState() {
    super.initState();
    DeckService.getMasterDeck().then((value) {
      setState(() {
        _masterCardList = value.cards;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RoundedPage(
      title: 'Welcome ${AuthService.getUser()?.displayName?.split(' ')[0]}!',
      useListView: false,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        childrenButtonSize: Size(70, 70),
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            label: 'New Card',
            labelStyle: TextStyle(fontSize: 22),
            child: const Icon(Icons.note_add,
                size: 30, color: Color.fromRGBO(239, 119, 55, 1.0)),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ModifyCard()),
            ),
          ),
          SpeedDialChild(
            label: 'New Deck',
            labelStyle: TextStyle(fontSize: 22),
            child: const Icon(Icons.collections_bookmark,
                size: 30, color: Color.fromRGBO(239, 119, 55, 1.0)),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ModifyDeck()),
            ),
          ),
          SpeedDialChild(
            label: 'QR Code',
            labelStyle: TextStyle(fontSize: 22),
            child: const Icon(Icons.qr_code_outlined,
                size: 30, color: Color.fromRGBO(239, 119, 55, 1.0)),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const QRScan()),
            ),
            onLongPress: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const QRView()),
            ),
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
                  cards: _masterCardList,
                ));
          },
          icon: const Icon(Icons.search),
        )
      ],
      leading: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          child: const Hero(
            tag: 'userAvatar',
            child: UserAvatar(
              radius: 64,
            ),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Stats()),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(70, 60, 200, 10),
                shape: BoxShape.circle,
              ),
              child: const DecoratedIcon(
                icon: Icon(Icons.star, size: 35, color: Colors.yellow),
                decoration: IconDecoration(
                  shadows: [
                    Shadow(
                      blurRadius: 20,
                      offset: Offset(1, 0),
                      color: Colors.brown,
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xfffaf8f8),
                      Color(0xfffae16c),
                      Color.fromARGB(128, 250, 148, 75),
                    ],
                  ),
                ),
              ),
            ),
            label: Text(
              ' ${_masterCardList.length} cards added!    ',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ),

          //To add a logo image:
          // new SizedBox(
          //   height: 100,
          //   width: 100,
          //   child: Image.asset('assets/logo.png')
          // ),

          // SPACER
          Container(
            margin: const EdgeInsets.only(bottom: 10),
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 10),
          ),

          //THIS IS TO SET UP THE CAROUSEL
          const DeckCarousel(),

          Container(
            margin: const EdgeInsets.only(bottom: 60),
          ),

          const MemoryGameButton(),
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
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CardView(initialCard: result),
            ),
          ),
        );
      },
    );
  }
}
