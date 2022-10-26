import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMemorySelect extends StatelessWidget {
  final String deckName;

  const CustomMemorySelect({required this.deckName});

  @override
  Widget build(BuildContext context) {
    return
      /*Container or whatever*/
      Container(
        margin: EdgeInsets.fromLTRB(5,20,5,20),
        child: TextButton(
          child: Text(deckName),
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
            print('Pressed');//how to make the button go to the corresponding screen?
          },
        ),
      );
  }
}



