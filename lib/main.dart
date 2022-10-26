import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rememberme/screens/homescreen.dart';
import 'package:rememberme/screens/login-signup.dart';
import 'package:rememberme/services/authservice.dart';
import 'firebase_options.dart';
import 'package:rememberme/screens/modifycard.dart';
import 'Screens/MemorySelect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 253, 142, 84);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorLight: const Color.fromARGB(255, 255, 199, 172),
        primaryColorDark: Colors.deepOrange[300],
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        cardTheme: const CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
      home: AuthService.isUserSignedIn() ? Homepage() : LoginOptions(),
    );
  }
}