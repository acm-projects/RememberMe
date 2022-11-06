import 'package:flutter/material.dart';

class MemoryGame extends StatelessWidget
{
  final numbers = List.generate(10, (index) => '$index');
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

      itemCount: numbers.length,
    itemBuilder: (context, index){
      final item = numbers[index];

      return buildNumber(item);
    },
  );

  Widget buildNumber(String number) => Container(
    padding: EdgeInsets.all(16.0),
    color: Color.fromRGBO(92, 193, 175, 100),

    child: GridTile(
      header: Text(
        'Name',
        textAlign: TextAlign.center,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
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