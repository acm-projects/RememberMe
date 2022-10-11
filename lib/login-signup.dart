import 'package:flutter/material.dart';
import 'package:rememberme/main.dart';
import 'login.dart';
import 'signup.dart';

class LoginOptions extends StatelessWidget {
  //const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/OrangeFlower.jpg'
            ),
            fit: BoxFit.cover,
          ),
        ),
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget> [
              Container(
                height: 470,
                width: 500,
                color: Colors.transparent,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(251,248,248, 0.9),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(47.0), topRight: Radius.circular(47.0), bottomLeft: Radius.zero, bottomRight: Radius.zero),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget> [
                        const Text(
                          'Welcome to RememberMe!',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: const Text(
                            'Your solution to remembering: “Who was that person again?”',
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center,
                          ),

                        ),
                        SizedBox(
                          height: 80,
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(255,164,116, 1),
                              shape: RoundedRectangleBorder( //to set border radius to button
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUp()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder( //to set border radius to button
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          child: const Text(
                              'Sign Up',
                            style: TextStyle(
                              color: Color(0xFFFFA474),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
