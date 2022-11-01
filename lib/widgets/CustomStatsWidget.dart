
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



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

        //
        Icon(
            Icons.star,
            size: 35,
            color: Colors.lightGreen

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
                            fontSize: 25,
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
                            fontSize: 25
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



