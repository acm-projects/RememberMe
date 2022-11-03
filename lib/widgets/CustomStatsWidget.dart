
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';



class CustomStats extends StatelessWidget {
  final String titleText;
  final String achievement;

  const CustomStats({required this.titleText, required this.achievement});



  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        //Space between left edge and star
        Container(
            margin: EdgeInsets.fromLTRB(50, 90, 0, 0)
        ),

        Container(
        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[


            Icon(
              Icons.circle,
              size: 70,
              color: Color.fromARGB(70,60,200,10),
            ),

            DecoratedIcon(
                icon: Icon(
                    Icons.star,
                    size: 30,
                    color: Colors.yellow
                ),
                decoration: IconDecoration(
                    shadows: [Shadow(blurRadius: 20, offset: Offset(1, 0), color: Colors.brown)],
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
        ),
        //Space between star and text
        Container(
            margin: EdgeInsets.fromLTRB(50, 90, 0, 0)
        ),

        //Space above text
        Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                      ' '
                  ),
                ],
              ),
              //More space above text
              Column(
                children: <Widget>[
                  Text(
                      ' '
                  ),
                ],
              ),

              //More space above text
              Column(
                children: <Widget>[
                  Text(
                      ' '
                  ),
                ],
              ),

              //Bolded text
              Column(
                children: <Widget>[
                  SizedBox(
                    width: 225,
                    child: Text(
                        titleText,
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                ],
              ),

              //Space between bolded and unbolded text
              Column(
                children: <Widget>[
                  Text(
                      ' '
                  ),
                ],
              ),

//Unbolded text
              Column(
                children: <Widget>[
                  SizedBox(
                    width: 225,
                    child: Text(
                        achievement,
                        style: TextStyle(
                            fontSize: 23
                        )
                    ),
                  ),
                ],
              ),
            ]
        ),
      ],
    );
  }
}



