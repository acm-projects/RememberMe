import 'package:flutter/material.dart';
import 'package:rememberme/controllers/MemoryGameController.dart';
import 'package:rememberme/screens/Homescreen.dart';
import 'package:rememberme/screens/MemoryGame.dart';
import 'package:rememberme/controllers/MemoryGameController.dart';
import '../widgets/memorygameselectdialog.dart';

class EndPage extends StatefulWidget {
  const EndPage({super.key, required this.m});

  final MemoryGameController m;

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {

  @override
  Widget build(BuildContext context) {
    int correct = widget.m.correctGuesses;
    int wrong = widget.m.wrongGuesses;
    double accuracy = ((wrong - correct).abs() / correct) * 100;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                'Scoreboard',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  //decoration:TextDecoration.underline,
                ),
              ),
            ),
            Container(
              height: 300,
              width: 500,
              decoration: BoxDecoration(
                  color: const Color(0xFFBFEBE3),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Text(
                      'Attempts Made:        ${correct+wrong}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Missed Attempts:      ${wrong}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Text(
                      'Accuarcy:          ${accuracy}%',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              width: 300,
              child: ElevatedButton(
                onPressed: () => MemoryGameSelectDialog.showSelectDialog(context),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(255,164,116, 1),
                  shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Homepage()));
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(255,164,116, 1),
                  shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                child: const Text(
                  'End Game',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }


}

