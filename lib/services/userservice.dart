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

  static Future<int> updateUserLoginDate() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (!AuthService.isUserSignedIn()){
      return 0;
    }
    var doc = await getUserDocRef().get();
    var data = doc.data();
    var dayslogged = 0;
    var currenttime = DateTime.now();
    if (data!.containsKey('lastlogin') && data.containsKey('dayslogged')) {
      Timestamp date = data['lastlogin'];
      var difference = DateTime.now().difference(date.toDate());

      if (difference.inDays < 1) {
        dayslogged = data['dayslogged'];
        currenttime = date.toDate();
      } else if (difference.inDays < 2){
        dayslogged = data['dayslogged'] + 1;
      }
    }


    await getUserDocRef().set({'lastlogin':currenttime,'dayslogged':dayslogged});
    return dayslogged;
  }

  static Future<int> getDaysLogged() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (!AuthService.isUserSignedIn()){
      throw Exception('User is not signed in');
    }
    var doc = await getUserDocRef().get();
    var data = doc.data();
    if (data!.containsKey('dayslogged')) {
      return data['dayslogged'];
    }
    return 0;
  }
}
