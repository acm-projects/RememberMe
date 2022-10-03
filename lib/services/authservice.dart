import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static bool isUserSignedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// Signs in the current user using the specified email and password.
  /// If an error occurs, the error message is returned as a string. Otherwise,
  /// null is returned.
  static Future<String?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// Creates a new user using the specified email and password, and gives
  /// them a display name. If an error occurs, the error message is returned
  /// as a string. Otherwise, null is returned.
  static Future<String?> signup(
      String email, String password, String displayname) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayname);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
