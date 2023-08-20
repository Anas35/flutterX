import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/authentication/authentication_repository.dart';
import 'package:flutter_x/src/user/user.dart';
import 'package:flutter_x/src/user/user_provider.dart';

final authProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

class AUthenticationNotifier extends AutoDisposeAsyncNotifier<bool> {

  @override
  bool build() => false;

  Future<void> signUp(XUser user, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.watch(authProvider);
      final userRepository = ref.watch(userProvider);
      final result = await auth.signUp(user.email, password, user.userName);
      await userRepository.createUserDoc(user.copyWith(id: result!.uid));
      return true;
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.watch(authProvider);
      await auth.signIn(email, password);
      return true;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.watch(authProvider);
      await auth.signOut();
      return true;
    });
  }

  Future<void> deleteUser() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.watch(authProvider);
      await auth.deleteUser();
      return true;
    });
  }

}

final authenticationNotifierProvider = AsyncNotifierProvider.autoDispose<AUthenticationNotifier, bool>(AUthenticationNotifier.new);

final userStreamProvider = StreamProvider<User?>((ref) {
  return ref.watch(authProvider).authStateChanges;
});
