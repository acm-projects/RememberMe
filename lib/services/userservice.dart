import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rememberme/services/authservice.dart';

class UserService {
  /// Returns a document reference to the currently signed in user.
  /// Throws an error if the user is not signed in.
  static DocumentReference<Map<String, dynamic>> getUserDocRef() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (!AuthService.isUserSignedIn()) {
      throw Exception('The user is not signed in');
    } else {
      String userId = AuthService.getUser()!.uid;
      var userColRef = db.collection('users');
      return userColRef.doc(userId);
    }
  }
}
