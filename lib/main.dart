import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rememberme/screens/Homescreen.dart';
import 'package:rememberme/screens/login-signup.dart';
import 'package:rememberme/services/authservice.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthService.isUserSignedIn() ? Homepage() : LoginOptions(),
    );
  }
}
