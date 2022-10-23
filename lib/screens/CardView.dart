import 'package:flutter/material.dart';

class CardView extends StatelessWidget
{
  @override

  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[400],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Alyssa Brown',
          style: TextStyle(fontSize: 30),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () {print("back pressed"); },
        ),

      ),
      backgroundColor: Colors.deepOrange[400],
      body: _Body(),

    );
  }
}


class _Text extends StatelessWidget
{
  @override

  Widget build(BuildContext context)
  {
    return Column(
          children: <Widget>[
            Container(
              width: 400,
              height: 125,
              alignment: Alignment(-0.7, -5.0),
              //make into colum
              child: Text(
                'Where We Met',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

            Container(
              width: 400,
              height: 125,
              alignment: Alignment(-0.7, -5.0),
              //make into colum
              child: Text(
                'ECSW',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )

              /*margin: EdgeInsets.only(top: 110, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange[100],
                borderRadius: BorderRadius.circular(50),
              ),
            ),*/
          ]
        );
  }
}



class _Body extends StatelessWidget
{
  @override

  Widget build(BuildContext context)
  {
    /*return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container (
            )),
        Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                  )
              ),
            ))
      ],
    ); */

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              color: Colors.deepOrange[400],
            ),
            Container(
              width: 411,
              height: 730,
              margin: EdgeInsets.only(top: 80),
              decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                  )
              ),
            ),
          ],
        ),
      ),
    );

  }

}

