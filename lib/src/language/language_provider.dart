import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/language/language_repository.dart';

final languageProvider = Provider<LanguageRepository>((ref) {
  return LanguageRepository();
});

class TranslateNotifier extends AutoDisposeAsyncNotifier<String?> {
  @override
  Future<String?> build() async => null;

  Future<void> translateData(Translate translate) async {
    state = const AsyncValue.data(null);
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(languageProvider);
      final output = await repository.getTranslate(translate);
      if (output != null) {
        return output;
      }
      await Future.delayed(const Duration(seconds: 2));
      return await repository.getTranslate(translate);
    });
  }
}

final translateProvider = AutoDisposeAsyncNotifierProvider<TranslateNotifier, String?>(TranslateNotifier.new);