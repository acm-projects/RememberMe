import 'package:flutter/material.dart';

class DeckView extends StatelessWidget
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
          'CS Class',
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

class _Body extends StatelessWidget
{
  @override

  Widget build(BuildContext context)
  {

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


            Container(
              width: 400,
              height: 125,
              child: Center(
                child: Text(
                  'Alyssa Brown',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),


              margin: EdgeInsets.only(top: 110, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange[100],
                borderRadius: BorderRadius.circular(50),
              ),

            ),

            Container(
              width: 400,
              height: 125,
              child: Center(
                child: Text(
                  'Arya Patel',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),

              margin: EdgeInsets.only(top: 255, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange[100],
                borderRadius: BorderRadius.circular(50),
              ),
            ),

            Container(
              width: 400,
              height: 125,
              child: Center(
                child: Text(
                  'Braxton White',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),

              margin: EdgeInsets.only(top: 400, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange[100],
                borderRadius: BorderRadius.circular(50),
              ),
            ),

            Container(
              width: 400,
              height: 125,
              child: Center(
                child: Text(
                  'Courtney Cox',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),

              margin: EdgeInsets.only(top: 545, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange[100],
                borderRadius: BorderRadius.circular(50),
              ),
            ),

            Container(
              width: 400,
              height: 125,
              child: Center(
                child: Text(
                  'Naomi Kurian',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),

              margin: EdgeInsets.only(top: 690, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange[100],
                borderRadius: BorderRadius.circular(50),
              ),
            ),

            /*
            Container(
              width: 30,
              height: 30,

              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.remove,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {print("remove card"); },
              ),

              margin: EdgeInsets.only(top: 110, left: 350),
              decoration: new BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),

            Container(
              width: 30,
              height: 30,

              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.remove,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {print("remove card"); },
              ),

              margin: EdgeInsets.only(top: 255, left: 350),
              decoration: new BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),

            Container(
              width: 30,
              height: 30,

              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.remove,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {print("remove card"); },
              ),

              margin: EdgeInsets.only(top: 400, left: 350),
              decoration: new BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),

            Container(
              width: 30,
              height: 30,

              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.remove,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {print("remove card"); },
              ),

              margin: EdgeInsets.only(top: 545, left: 350),
              decoration: new BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),

            Container(
              width: 30,
              height: 30,

              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.remove,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {print("remove card"); },
              ),

              margin: EdgeInsets.only(top: 690, left: 350),
              decoration: new BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
*/
          ],
        ),
      ),
    );

  }

}

