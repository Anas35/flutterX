import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/user/user.dart';
import 'package:flutter_x/src/user/user_repository.dart';

final userProvider = Provider<UserRepository>((ref) {
  return UserRepository(firestore: FirebaseFirestore.instance, storage: FirebaseStorage.instance);
});

final getUserProvider = AutoDisposeFutureProvider.family<XUser, String>((ref, uid) async {
  return ref.watch(userProvider).getUser(uid);
});

final getCurrentUserProvider = FutureProvider<XUser>((ref) async {
  return ref.watch(userProvider).getUser(FirebaseAuth.instance.currentUser!.uid);
});

class UpdateProfileNotifier extends AutoDisposeAsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return false;
  }

  Future<void> updateUser(XUser user, String? file) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(userProvider);
      await repository.update(user, file);
      return true;
    });
  }
}

final updateProvider = AutoDisposeAsyncNotifierProvider<UpdateProfileNotifier, bool>(UpdateProfileNotifier.new);

final uniqueNameProvider = AutoDisposeFutureProviderFamily<bool, String>((ref, userName) {
  return ref.watch(userProvider).isDuplicateUniqueName(userName);
});