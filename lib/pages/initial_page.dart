/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/pages/landing_page.dart';
import 'package:flutter_x/src/authentication/authentication_provider.dart';
import 'package:flutter_x/utils/extension.dart';
import 'package:flutter_x/widgets/layout.dart';

class InitialPage extends ConsumerWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider);
    return user.withDefault(
      data: (data) {
        if (data == null) {
          return const LandingPage();
        } else {
          return const Dashboard();
        }
      },
    );
  }
}
*/