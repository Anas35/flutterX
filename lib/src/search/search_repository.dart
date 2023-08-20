import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:algolia_insights/algolia_insights.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_x/src/tweet/tweet.dart';
import 'package:flutter_x/src/user/user.dart';
import 'package:flutter_x/utils/credential.dart';

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<Tweet> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(Tweet.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}

class HitsPageUser {
  const HitsPageUser(this.items, this.pageKey, this.nextPageKey);

  final List<XUser> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPageUser.fromResponse(SearchResponse response) {
    try {
      print(response.hits);
      final items = response.hits.map(XUser.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPageUser(items, response.page, nextPageKey);
    } catch (e, stk) {
      print(stk);
      print(e);
      return const HitsPageUser([], 0, 1);
    }
  }
}

class TrackEvent {
  static final _insights = Insights('QOWDETTO44', '6b767067ab7488d89c66f85a0a6f32c5')..userToken = FirebaseAuth.instance.currentUser!.uid;

  static void sendClickEvent(String id, EventName name) {
    _insights.clickedObjects(
      indexName: 'FlutterX',
      eventName: name.name,
      objectIDs: [id],
    );
  }
}

enum EventName {
  clickedTweet,
  clickedTranslate,
  clickedLanguage,
  clickedProfile,
}


class UserSearchRepository {

  final userSearcher = HitsSearcher(
    applicationID: Credential.algoliaApplicationID,
    apiKey: Credential.algoliaAPIKey,
    indexName: 'userIndex',
  );

  void query(String query) {
    userSearcher.applyState((state) => state.copyWith(
      query: query,
      analytics: true
    ));
  }

  late final Stream<List<XUser>> suggestions = userSearcher.responses.map((response) {
    return response.hits.map(XUser.fromJson).toList();
  });

  void dispose() {
    userSearcher.dispose();
  }
}
