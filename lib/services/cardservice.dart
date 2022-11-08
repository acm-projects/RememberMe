import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rememberme/services/authservice.dart';
import 'package:rememberme/services/deckservice.dart';

import 'userservice.dart';

class CardService {
  static final Map<String, ImageProvider?> _imageCache = {};

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

  /// Returns an error object if failed because catching firebase exceptions
  /// is bugged
  static Future<FirebaseException?> updateCardImage(
      String cardId, File img) async {
    var storageRef = FirebaseStorage.instance.ref(
      '${AuthService.getUser()!.uid}/cards',
    );
    var imgRef = storageRef.child(cardId);
    try {
      await imgRef.putFile(img);
      _imageCache[cardId] = Image.file(img).image;
      return null;
    } on FirebaseException catch (e) {
      return e;
    }
  }

  static Future<ImageProvider?> getImage(String id) async {
    if (isImageCached(id)) getImageFromCache(id);

    var ref = FirebaseStorage.instance.ref(
      '${AuthService.getUser()!.uid}/cards/$id',
    );
    try {
      var url = await ref.getDownloadURL();
      var imageProvider = CachedNetworkImageProvider(url);
      _imageCache[id] = imageProvider;
      return imageProvider;
    } on Exception catch (_) {
      _imageCache[id] = null;
      return null;
    }
  }

  static bool isImageCached(String id) => _imageCache.containsKey(id);
  static ImageProvider? getImageFromCache(String id) => _imageCache[id];

  static Future<void> deleteCard(String id) async {
    await UserService.getUserDocRef().collection('cards').doc(id).delete();
    var docs = await DeckService.getAllDeckDocs();
    await DeckService.assignCardsToDecks(
      cardIds: [id],
      removeDecksIds: docs.map((e) => e.id).toList(),
    );
    try {
      await FirebaseStorage.instance
          .ref('${AuthService.getUser()!.uid}/cards/$id')
          .delete();
      _imageCache.remove(id);
    } on FirebaseException catch (_) {} // Catch 404 error
  }
}

class PersonCard {
  PersonCard({
    required this.id,
    required this.name,
    required this.questions,
  });

  final String id, name;
  final Map<String, String> questions;

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
}
