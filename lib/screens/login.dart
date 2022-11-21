import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/screens/Homescreen.dart';
import 'package:rememberme/services/authservice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFF8F54),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(50, 40, 40, 50),
                    child: Text(
                      'Ready to Remember?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    height: 700,
                    width: 500,
                    color: Colors.transparent,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(251, 248, 248, 0.9),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(47.0),
                            topRight: Radius.circular(47.0),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.zero),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
                                child: Text(
                                  'Enter Your Email',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 0, 40, 40),
                                child: TextFormField(
                                  decoration:
                                      const InputDecoration(hintText: 'Email'),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email';
                                    }
                                    return null;
                                  },
                                  onSaved: ((value) => _email = value!),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(30),
                                child: Text(
                                  'Enter Your Password',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 0, 40, 70),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'Password'),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    return null;
                                  },
                                  onSaved: ((value) => _password = value!),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                width: 300,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Updates _email and _password
                                      _formKey.currentState!.save();
                                      _submit();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(255, 164, 116, 1),
                                    shape: RoundedRectangleBorder(
                                        //to set border radius to button
                                        borderRadius:
                                            BorderRadius.circular(20)),
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
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 65, 0, 0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFFCD8C),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: Offset(0, 0.3),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    String? message = await AuthService.login(_email, _password);
    if (message != null) {
      print("ERROR OCCURED WHEN LOGGING IN");
    } else {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Homepage()),
          (route) => false,
        );
      }
    }
    //else {
    // print
    //}*/
    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FutureBuilder<String?> (
          future: AuthService.login(_email, _password),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return Text(snapshot.data!);
               // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Profile()));

              } else {
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Profile()));
                return const Text('Logged in!');
              }
            }
            else {
               return const Text('Logging in...');
            }
          },
        ),
      ),
    );*/
  }
}
