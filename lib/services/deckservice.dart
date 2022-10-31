import 'package:cloud_firestore/cloud_firestore.dart';

import 'cardservice.dart';
import 'userservice.dart';

typedef QueryDeckDoc = QueryDocumentSnapshot<Map<String, dynamic>>;
typedef DeckDoc = DocumentSnapshot<Map<String, dynamic>>;

class DeckService {
  static Future<Deck> getMasterDeck() async {
    var cardsRef = UserService.getUserDocRef().collection('cards');
    var cardsSnapshot = await cardsRef.get();
    var cards = cardsSnapshot.docs.map((e) => PersonCard.fromDocument(e));
    return Deck(
      id: 'master',
      name: 'Master Deck',
      cards: cards.toList(),
    );
  }

  static CollectionReference<Map<String, dynamic>> getDecksRef() {
    return UserService.getUserDocRef().collection('decks');
  }

  static Future<List<QueryDeckDoc>> getAllDeckDocs() async {
    var decksSnapshot = await getDecksRef().get();
    return decksSnapshot.docs;
  }

  /// Returns every deck created by this user.
  /// Only uses two network calls.
  static Future<List<Deck>> getAllDecks() async {
    Deck masterDeck = await getMasterDeck();
    var docs = await getAllDeckDocs();
    List<Deck> decks = [];
    for (var elem in docs) {
      if (elem.exists) {
        var deckData = elem.data();
        List cardIds = deckData['cards'];
        decks.add(Deck(
          id: elem.id,
          name: deckData['name'],
          cards: masterDeck.cards
              .where((element) => cardIds.contains(element.id))
              .toList(),
        ));
      }
    }
    decks.add(masterDeck);
    decks.sort(((a, b) => a.cards.length.compareTo(b.cards.length)));
    return decks;
  }

  /// Creates a new deck. Returns the new deck's id
  static Future<String> addDeck(String name, List<String> cards) async {
    var deckRef = await getDecksRef().add({
      'name': name,
      'cards': cards,
    });
    return deckRef.id;
  }

  /// Creates a new deck. Returns a popluated Deck object
  static Future<Deck> addAndReturnDeck(String name, List<String> cards) async {
    var id = await addDeck(name, cards);
    var personCards = await CardService.getByIds(cards);
    return Deck(
      id: id,
      name: name,
      cards: personCards,
    );
  }

  static Future<void> assignCardsToDecks({
    required List<String> cardIds,
    List<String> addDecksIds = const [],
    List<String> removeDecksIds = const [],
  }) async {
    if (cardIds.isEmpty || (addDecksIds.isEmpty && removeDecksIds.isEmpty)) {
      return;
    }

    final batch = FirebaseFirestore.instance.batch();
    var decksRef = getDecksRef();
    for (String id in addDecksIds) {
      batch.update(decksRef.doc(id), {
        'cards': FieldValue.arrayUnion(cardIds),
      });
    }
    for (String id in removeDecksIds) {
      batch.update(decksRef.doc(id), {
        'cards': FieldValue.arrayRemove(cardIds),
      });
    }
    await batch.commit();
  }

  static Future<Deck> getDeckFromDoc(DeckDoc doc) async {
    List<dynamic> cards = doc['cards'];
    List<String> mappedCards = cards.map((elem) => elem.toString()).toList();
    return Deck(
      id: doc.id,
      name: doc['name'],
      cards: await CardService.getByIds(mappedCards),
    );
  }

  static Future<Deck> getDeckById(String id) async {
    if (id == 'master') return await getMasterDeck();
    var deckRef = getDecksRef().doc(id);
    var deckDoc = await deckRef.get();
    return await getDeckFromDoc(deckDoc);
  }
}

class Deck {
  Deck({
    required this.id,
    required this.name,
    required this.cards,
  }) : isMaster = id == 'master';

  final String id, name;
  final List<PersonCard> cards;
  final bool isMaster;
}
