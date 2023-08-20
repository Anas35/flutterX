import 'package:cloud_firestore/cloud_firestore.dart';

class LanguageRepository {
  final collection = FirebaseFirestore.instance.collection("translations");

  Future<String?> getTranslate(Translate translate) async {
    final data = await collection.where('tweetId', isEqualTo: translate.tweetId).get();
    if (data.docs.isEmpty) {
      await addTweet(translate);
      return null;
    }
    final map = data.docs.first.data()['output'] as Map;
    if (map.containsKey(translate.languageCode)) {
      return map[translate.languageCode];
    } else {
      await updateTweet(data.docs.first.id, translate.languageCode);
    }
    return null;
  }

  Future<void> addTweet(Translate translate) async {
    await collection.doc().set(translate.toJson());
  }

  Future<void> updateTweet(String docId, String languageCode) async {
    await collection.doc(docId).update({
      'languages': FieldValue.arrayUnion([languageCode]),
    });
  }
}

class Translate {
  final String tweetId;
  final String input;
  final String languageCode;

  Translate({required this.tweetId, required this.input, required this.languageCode});

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'input': input,
      'languages': FieldValue.arrayUnion([languageCode]),
    };
  }
}
