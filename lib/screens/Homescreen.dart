import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Stats.dart';

//Note, pubspec.yaml has been changed to make this work
//Also, I've had to use "flutter run --no-sound-null-safety" in the terminal
//And then hot reload works by typing "r" in the terminal


class Homepage extends StatefulWidget {
const Homepage({Key? key}) : super(key: key);

@override
State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //STARTS WITH LOTS OF STUFF WITHIN SCAFFOLD!
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
              title: Text('Welcome'),
              centerTitle: true,
              titleTextStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
              backgroundColor: Color.fromARGB(255, 253, 142, 84),

              //THIS IS TO ADD THE SEARCH BUTTON ICON AND MAKE IT SHOW SEARCH BAR
              actions: [
                IconButton(
                  onPressed: () {
                    // method to show the search bar
                    showSearch(
                        context: context,
                        // delegate to customize the search bar
                        delegate: CustomSearchDelegate()
                    );
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            )
        ),

        //For plus button
        floatingActionButton: Container(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            child:FloatingActionButton(
                onPressed: () {
                  //connect to next screen??
                },
              backgroundColor: Colors.orange,
              child: const Icon(
                  Icons.add,
                  size: 30
              ),
            )
          )


        ),

        //HERE THE BODY STARTS, MAKE INTO A COLUMN WITH CONTAINERS AND SUCH
        body: Column(
          children: <Widget>[
            //For achievement heading on the Homepage--------------------------
            Container(
              margin: EdgeInsets.fromLTRB(0,30,0,10),
              child: TextButton(
                child: Text('Achievement'),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  //backgroundColor: Colors.deepOrange[300],
                  //onSurface: Colors.grey,
                  //padding: EdgeInsets.fromLTRB(90,30,90,30),
                  //shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  textStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Stats())
                  );
                },
              ),
            ),


            //For the actual achievement---------------------
            Container(
              margin: EdgeInsets.fromLTRB(0,0,0,10),
              child: Text(
                'Added 10 cards!',
                style: TextStyle(
                    fontSize: 25,
                ),
              ),
            ),

            //THIS CONTAINER IS FOR THE "Decks" TEXT
            Container(
              margin: EdgeInsets.fromLTRB(0,30,0,0),
              child: Text(
                'Decks',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            //THIS IS TO SET UP THE CAROUSEL
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: cardList.map((card){
                return Builder(
                    builder:(BuildContext context){
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.white,
                          child: card,
                        ),
                      );
                    }
                );
              }).toList(),
            ),



            //THIS IS FOR A TEXT BUTTON TO SELECT 'Memory Games'
            //CHANGE ON-PRESSED ACTION TO GO TO ANOTHER SCREEN
            Container(
              margin: EdgeInsets.fromLTRB(25,40,25,25),
              child: TextButton(
                child: Text('Memory Games'),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.deepOrange[300],
                  onSurface: Colors.grey,
                  padding: EdgeInsets.fromLTRB(90,30,90,30),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  textStyle: TextStyle(
                      fontSize: 25
                  ),
                ),
                onPressed: () {
                  print('Pressed');
                },
              ),
            ),

          ],
        )
    );
  }
}


//OUTSIDE OF SCAFFOLD:

//THIS IS FOR THE CARDS ('ITEMS') LIST FOR THE CAROUSEL SLIDER
int _currentIndex=0;
List cardList=[
  Item1(),
  Item2(),
  Item3(),
  Item4()
];
List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

//THIS IS TO MAKE ITEM1 (CARD ONE) IN CAROUSEL SLIDER

//CHANGE ON-PRESSED ACTION TO LEAD TO ANOTHER SCREEN
class Item1 extends StatelessWidget {
  const Item1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5,20,5,20),
      child: TextButton(
        child: Text('Master Deck'),
        style: TextButton.styleFrom(
            primary: Colors.black,
            backgroundColor: Colors.deepOrange[200],
            onSurface: Colors.grey,
            padding: EdgeInsets.fromLTRB(90,30,90,30),
            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            textStyle: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.italic
            )
        ),
        onPressed: () {
          print('Pressed');
        },
      ),
    );
  }
}

//THIS IS TO MAKE ITEM2 (CARD 2) IN CAROUSEL

//CHANGE ON-PRESSED ACTION TO LEAD TO ANOTHER SCREEN
class Item2 extends StatelessWidget {
  const Item2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5,20,5,20),
      child: TextButton(
        child: Text('Deck 1'),
        style: TextButton.styleFrom(
            primary: Colors.black,
            backgroundColor: Colors.deepOrange[200],
            onSurface: Colors.grey,
            padding: EdgeInsets.fromLTRB(90,40,90,40),
            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            textStyle: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.italic
            )
        ),
        onPressed: () {
          print('Pressed');
        },
      ),
    );
  }
}

//ITEM 3 (CARD 3) IN CAROUSEL

//CHANGE ON-PRESSED ACTION TO LEAD TO ANOTHER SCREEN
class Item3 extends StatelessWidget {
  const Item3({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5,20,5,20),
      child: TextButton(
        child: Text('Deck 2'),
        style: TextButton.styleFrom(
            primary: Colors.black,
            backgroundColor: Colors.deepOrange[200],
            onSurface: Colors.grey,
            padding: EdgeInsets.fromLTRB(90,40,90,40),
            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            textStyle: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.italic
            )
        ),
        onPressed: () {
          print('Pressed');
        },
      ),
    );
  }
}

//ITEM 4 (CARD 4) IN CAROUSEL

//CHANGE ON-PRESSED ACTION TO LEAD TO ANOTHER SCREEN
class Item4 extends StatelessWidget {
  const Item4({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5,20,5,20),
      child: TextButton(
        child: Text('Deck 3'),
        style: TextButton.styleFrom(
            primary: Colors.black,
            backgroundColor: Colors.deepOrange[200],
            onSurface: Colors.grey,
            padding: EdgeInsets.fromLTRB(90,40,90,40),
            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            textStyle: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.italic
            )
        ),
        onPressed: () {
          print('Pressed');
        },
      ),
    );
  }
}


//THIS IS SETTING UP THE LIST OF NAMES FOR THE SEARCHBAR

//EDIT THIS TO BE DECKS ADDED??
class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];

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
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}

