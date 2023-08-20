import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/comments/comments.dart';
import 'package:flutter_x/src/comments/comments_repository.dart';
import 'package:flutter_x/src/user/user_provider.dart';

final commentProvider = Provider<CommentsRepository>((ref) {
  return CommentsRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});

class PostNotifier extends AsyncNotifier<bool> {
  
  @override
  Future<bool> build() async => false;

  Future<void> comment(String parentId, String text) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.watch(commentProvider);
      final user = await ref.watch(getCurrentUserProvider.future);
      repo.createComment(parentId, text, user);
      return true;
    });
  }
}

final addCommentProvider = AsyncNotifierProvider<PostNotifier, bool>(PostNotifier.new);

final getCommentsProvider = AutoDisposeStreamProviderFamily<List<Comments>, String>((ref, id) {
  return ref.watch(commentProvider).getComments(id);
});

final commentLikeProvider = AutoDisposeFutureProviderFamily<void, String>((ref, id) async {
  final comment = ref.watch(commentProvider);
  await comment.addLikes(id, FirebaseAuth.instance.currentUser!.uid);
});

final commentRemoveLikeProvider = AutoDisposeFutureProviderFamily<void, String>((ref, id) async {
  final comment = ref.watch(commentProvider);
  await comment.removeLikes(id, FirebaseAuth.instance.currentUser!.uid);
});

final getUserTweet = AutoDisposeFutureProviderFamily<List<Comments>, String>((ref, uid) async {
  final tweet = ref.watch(commentProvider);
  return await tweet.getUserComment(uid);
});