import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/tweet/tweet.dart';
import 'package:flutter_x/src/tweet/tweet_repository.dart';
import 'package:flutter_x/src/user/user_provider.dart';

final tweetProvider = Provider<TweetRepository>((ref) {
  return TweetRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});

class PostNotifier extends AsyncNotifier<bool> {
  
  @override
  Future<bool> build() async => false;

  Future<void> post(String text, List<String> images) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.watch(tweetProvider);
      final user = await ref.watch(getCurrentUserProvider.future);
      repo.createTweet(text, images, user);
      return true;
    });
  }
}

final postProvider = AsyncNotifierProvider<PostNotifier, bool>(PostNotifier.new);

final postsProvider = StreamProvider<List<Tweet>>((ref) {
  return ref.watch(tweetProvider).getTweets();
});

/*class TweetNotifier extends AutoDisposeFamilyNotifier<Tweet, Tweet> {
 
  @override
  Tweet build(Tweet arg) {
    return arg;
  }

  Future<void> liked(bool isLiked) async {
    final repo = ref.read(tweetProvider);
    if (isLiked) {
    } else {
      
    }
  }
}*/

final tweetLikeProvider = AutoDisposeFutureProviderFamily<void, String>((ref, id) async {
  final tweet = ref.watch(tweetProvider);
  await tweet.addLikes(id, FirebaseAuth.instance.currentUser!.uid);
});

final tweetRemoveLikeProvider = AutoDisposeFutureProviderFamily<void, String>((ref, id) async {
  final tweet = ref.watch(tweetProvider);
  await tweet.removeLikes(id, FirebaseAuth.instance.currentUser!.uid);
});

final getUserTweet = AutoDisposeFutureProviderFamily<List<Tweet>, String>((ref, id) async {
  final tweet = ref.watch(tweetProvider);
  return await tweet.getUserTweet(id);
});

final getTweet = AutoDisposeStreamProviderFamily<Tweet, String>((ref, id) {
  final tweet = ref.watch(tweetProvider);
  return tweet.getTweet(id);
});