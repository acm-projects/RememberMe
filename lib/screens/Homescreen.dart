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
import 'package:rememberme/widgets/deckcarousel.dart';
import 'package:rememberme/widgets/memorygameselectdialog.dart';
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
          Row(
            children: <Widget>[
              Container(margin: EdgeInsets.fromLTRB(40, 90, 0, 0)),
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  InkWell(
                    child: Icon(
                      Icons.circle,
                      size: 70,
                      color: Color.fromARGB(90, 60, 200, 10),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Stats()),
                      );
                    },
                  ),
                  InkWell(
                    child: DecoratedIcon(
                        icon: Icon(Icons.star, size: 30, color: Colors.yellow),
                        decoration: IconDecoration(
                            shadows: [
                              Shadow(
                                  blurRadius: 30,
                                  offset: Offset(1, 0),
                                  color: Colors.brown)
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xfffaf8f8),
                                Color(0xfffae16c),
                                Color.fromARGB(128, 250, 148, 75),
                              ],
                            ))),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Stats()),
                      );
                    },
                  ),
                ],
              ),
              Container(margin: EdgeInsets.fromLTRB(20, 90, 10, 0)),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        textStyle: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Stats()),
                        );
                      },
                      child: Text('${_masterCardList.length} cards added'),
                    ),
                  ),
                ],
              ),
              Container(margin: EdgeInsets.fromLTRB(20, 90, 10, 0)),
            ],
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
            margin: const EdgeInsets.only(bottom: 10),
          ),
          //Image.asset('assets/human-brain.png', height: 100, width: 100),

          //THIS IS FOR A TEXT BUTTON TO SELECT 'Memory Games'
          //CHANGE ON-PRESSED ACTION TO GO TO ANOTHER SCREEN
          Container(
            margin: EdgeInsets.fromLTRB(25, 40, 25, 25),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/human-brain.png'),
                    fit: BoxFit.fill)),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 30,
                ),
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                textStyle: TextStyle(fontSize: 25),
              ),
              onPressed: () => MemoryGameSelectDialog.showSelectDialog(context),
              child: Text(' Memory Game ',
                  style: TextStyle(fontFamily: 'Poppins')),
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 25),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
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
              child: Text(' View Statistics ',
                  style: TextStyle(fontFamily: 'Poppins')),
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
