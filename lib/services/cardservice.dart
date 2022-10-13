import 'package:cloud_firestore/cloud_firestore.dart';

import 'userservice.dart';

class CardService {
  static Future<PersonCard> addCard(PersonCardData card) async {
    var userDocRef = UserService.getUserDocRef();
    var cardRef = await userDocRef.collection('cards').add(card.getAsMap());
    return PersonCard(cardRef.id, card);
  }

  static void modifyCard(PersonCard card) async {
    var cardDoc = UserService.getUserDocRef().collection('cards').doc(card.id);
    await cardDoc.set(card.data.getAsMap());
  }

  static Future<List<PersonCard>> getMasterDeck() async {
    var cardsRef = UserService.getUserDocRef().collection('cards');
    var cardsSnapshot = await cardsRef.get();
    return cardsSnapshot.docs.map((e) => PersonCard.fromDocument(e)).toList();
  }
}

class PersonCard {
  PersonCard(this.id, this.data);

  factory PersonCard.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    String id = snapshot.id;
    Map<String, dynamic> docData = snapshot.data()!;
    PersonCardData personCardData = PersonCardData.fromMap(docData);
    return PersonCard(id, personCardData);
  }

  final String id;
  final PersonCardData data;
}

class PersonCardData {
  PersonCardData({required this.name, required this.questions});

  final String name;
  final Map<String, String> questions;

  factory PersonCardData.fromMap(Map<String, dynamic> data) {
    return PersonCardData(
      name: data['name'],
      questions: data['questions'],
    );
  }

  Map<String, dynamic> getAsMap() {
    return <String, dynamic>{
      'name': name,
      'questions': questions,
    };
  }
}
