import 'package:cloud_firestore/cloud_firestore.dart';

import 'userservice.dart';

class CardService {
  static Future<PersonCard> addCard({
    required name,
    required questions,
  }) async {
    var userDocRef = UserService.getUserDocRef();
    var cardRef = await userDocRef.collection('cards').add({
      'name': name,
      'questions': questions,
    });
    return PersonCard(
      name: name,
      questions: questions,
      id: cardRef.id,
    );
  }

  static Future<PersonCard> modifyCard(PersonCard card) async {
    var cardDoc = UserService.getUserDocRef().collection('cards').doc(card.id);
    await cardDoc.set({
      'name': card.name,
      'questions': card.questions,
    });
    return card;
  }

  static Future<List<PersonCard>> getByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    var cardsRef = UserService.getUserDocRef()
        .collection('cards')
        .where('__name__', whereIn: ids);
    var cardsSnapshot = await cardsRef.get();
    var personCards = cardsSnapshot.docs.map((e) => PersonCard.fromDocument(e));
    return personCards.toList();
  }

  static Future<PersonCard> getById(String id) async {
    var cardRef = UserService.getUserDocRef().collection('cards').doc(id);
    var cardDoc = await cardRef.get();
    return PersonCard.fromDocument(cardDoc);
  }
}

class PersonCard {
  PersonCard({
    required this.id,
    required this.name,
    required this.questions,
  });

  factory PersonCard.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    String id = snapshot.id;
    Map<String, dynamic> docData = Map.from(snapshot.data()!);
    return PersonCard(
      id: id,
      name: docData['name'],
      questions: _fixDynamicMap(docData['questions']),
    );
  }

  static Map<String, T> _fixDynamicMap<T>(dynamic buggedMap) {
    Map<String, dynamic> castedMap = buggedMap;
    return castedMap.map((key, value) => MapEntry(key, value as T));
  }

  final String id, name;
  final Map<String, String> questions;
}
