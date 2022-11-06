import 'package:flutter/material.dart';
import 'package:rememberme/screens/login-signup.dart';
import 'package:rememberme/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //backgroundColor: const Color(0xFFFF8F54),
          backgroundColor: Theme.of(context).primaryColorDark,
          elevation: 0,
          centerTitle: true,
          title: const Text(
              'My Profile',
              style: TextStyle(
                color: Colors.white,
                //fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
        ),
        leading: IconButton(
          icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
            Navigator.pop(context);
          }

          ), // IconButton
    ),

      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFF8F54),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 730,
                  width: 500,
                  color: Colors.transparent,

                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(251,250,250, 1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(47.0), topRight: Radius.circular(47.0), bottomLeft: Radius.zero, bottomRight: Radius.zero),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget> [
                        const Padding(
                          padding: EdgeInsets.all(30),
                          child: SizedBox(
                            height: 170,
                            width: 170,
                            child: CircleAvatar(
                              // add image to assets folder or get image from firebase and put here
                              backgroundImage: AssetImage('assets/avatar.webp'),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                'Name:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                displayName(),
                                style: TextStyle(
                                  color: Colors.black,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 27,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: Text(
                                'Email:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 60),
                              child: Text(
                                displayEmail(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 27,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 80,
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              auth.signOut();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginOptions()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(255,164,116, 1),
                              shape: RoundedRectangleBorder( //to set border radius to button
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            child: const Text(
                              'Sign Out',
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String displayName() {
    String name = "";
    if (AuthService.getUser() != null) {
      if (AuthService.getUser()?.displayName != null) {
        name = (AuthService.getUser()?.displayName).toString();
      }
    }
    return name;
  }

  String displayEmail() {
    String email = "";
    if (AuthService.getUser() != null) {
      if (AuthService.getUser()?.email != null) {
        email = (AuthService.getUser()?.email).toString();
      }
    }
    return email;
  }


  }
