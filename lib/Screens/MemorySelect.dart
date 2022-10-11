import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

//Note, pubspec.yaml has been changed to make this work
//Also, I've had to use "flutter run --no-sound-null-safety" in the terminal
//And then hot reload works by typing "r" in the terminal


class MemorySelect extends StatefulWidget {
  const MemorySelect({Key? key}) : super(key: key);

  @override
  State<MemorySelect> createState() => _MemorySelect();
}


class _MemorySelect extends State<MemorySelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              title: Text('Memory Games'),
              centerTitle: true,
              titleTextStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
              backgroundColor: Color.fromARGB(255, 253, 142, 84),
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
        body: Column(
          children: <Widget>[
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


            Container(
              margin: EdgeInsets.fromLTRB(0,30,0,0),
              child: Text(
                'Choose Game',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(25),
              child: TextButton(
                child: Text('Matching Game'),
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
            Container(
              margin: EdgeInsets.fromLTRB(25,0,25,0),
              child: TextButton(

                child: Text('Question Game'),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.deepOrange[300],
                    onSurface: Colors.grey,
                    padding: EdgeInsets.fromLTRB(90,30,90,30),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    textStyle: TextStyle(
                        fontSize: 25
                    )
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

