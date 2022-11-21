import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rememberme/services/authservice.dart';
import 'package:rememberme/services/deckservice.dart';
import 'package:crypto/crypto.dart';
import 'package:file/memory.dart';
import 'package:tuple/tuple.dart';

import 'userservice.dart';

typedef ImageNotifier = ValueNotifier<Map<String, ImageProvider?>>;

class CardService {
  static final ImageNotifier _imageNotifier = ValueNotifier({});
  static ImageNotifier get imageNotifier => _imageNotifier;

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
      var data = await _readFileSafely(img);
      await imgRef.putData(data);
      updateImageCache(cardId, Image.memory(data).image);
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
      updateImageCache(id, imageProvider);
      return imageProvider;
    } on Exception catch (_) {
      updateImageCache(id, null);
      return null;
    }
  }

  static bool isImageCached(String id) => imageNotifier.value.containsKey(id);
  static ImageProvider? getImageFromCache(String id) => imageNotifier.value[id];
  static void updateImageCache(String id, ImageProvider? img) {
    var val = {..._imageNotifier.value}; // Required so ValueNotifier updates
    val[id] = img;
    _imageNotifier.value = val;
  }

  static void removeIdFromCache(String id) {
    var val = {..._imageNotifier.value}; // Required so ValueNotifier updates
    val.remove(id);
    _imageNotifier.value = val;
  }

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
      removeIdFromCache(id);
    } on FirebaseException catch (_) {} // Catch 404 error
  }

  static String getPublicCardId() {
    assert(AuthService.isUserSignedIn());
    var bytes = utf8.encode(AuthService.getUser()!.uid);
    var hash = sha256.convert(bytes);
    return hash.toString().toUpperCase();
  }

  static Future<PersonCard> modifyPublicCard(PersonCard card) async {
    var id = getPublicCardId();
    var ref = FirebaseFirestore.instance.collection('public_cards').doc(id);
    await ref.set({
      'name': card.name,
      'questions': card.questions,
    });
    return card;
  }

  static Future<PersonCard> getPublicCard(String id) async {
    var ref = FirebaseFirestore.instance.collection('public_cards').doc(id);
    var doc = await ref.get();
    return PersonCard.fromDocument(doc);
  }

  static Future<bool> publicCardExists(String id) async {
    var ref = FirebaseFirestore.instance.collection('public_cards').doc(id);
    var doc = await ref.get();
    return doc.exists;
  }

  static Future<File?> getPublicImage(String id) async {
    var ref = FirebaseStorage.instance.ref(
      'public_cards/$id',
    );
    try {
      var mfs = MemoryFileSystem();
      var file = mfs.systemTempDirectory.childFile(
        id + DateTime.now().millisecondsSinceEpoch.toRadixString(16),
      );
      var data = await ref.getData();
      if (data == null) return null;
      await file.writeAsBytes(data.toList());
      return file;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<FirebaseException?> updatePublicImage(
      String id, File img) async {
    var ref = FirebaseStorage.instance.ref('public_cards');
    var imgRef = ref.child(id);
    try {
      var data = await _readFileSafely(img);
      await imgRef.putData(data);
      return null;
    } on FirebaseException catch (e) {
      return e;
    }
  }

  static Future<Tuple2<PersonCard, File?>?> getPublicCardAndImage({
    String? id,
  }) async {
    id ??= getPublicCardId();
    var exists = await CardService.publicCardExists(id);
    if (exists) {
      var items = await Future.wait<dynamic>([
        CardService.getPublicCard(id),
        CardService.getPublicImage(id),
      ]);
      return Tuple2.fromList(items);
    }
    return null;
  }

  static Future<Uint8List> _readFileSafely(File file) async {
    var data = await file.readAsBytes();
    return data;
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
