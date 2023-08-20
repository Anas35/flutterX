import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/authentication/authentication_provider.dart';
import 'package:flutter_x/utils/extension.dart';
import 'package:flutter_x/utils/theme_mode.dart';
import 'package:flutter_x/widgets/dialog.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authenticationNotifierProvider, (previous, next) {
      next.handleListen(
        data: () {
          context.pop();
          context.goNamed('landing');
        },
        error: (e) => context.snackbar(e),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            onTap: () {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Select Theme Mode'),
                    content: SizedBox(
                      width: 250,
                      height: 150,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final mode = ref.watch(themeModeProvider);
                          return ListView(
                            shrinkWrap: true,
                            children: ThemeMode.values.map((theme) {
                              return ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  ref.watch(themeModeProvider.notifier).update((state) => theme);
                                },
                                title: Text(theme.name),
                                selected: theme == mode,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            title: const Text("Theme Mode"),
            trailing: const Icon(Icons.brightness_low),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return ConfirmationDialog(
                    description: "Are you sure you want to Log Out?",
                    onConfirm: () {
                      ref.watch(authenticationNotifierProvider.notifier).signOut();
                    },
                  );
                },
              );
            },
            title: const Text("Log Out"),
            trailing: const Icon(Icons.logout),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return ConfirmationDialog(
                    description: "Are you sure you want to delete everything?",
                    onConfirm: () {
                      ref.watch(authenticationNotifierProvider.notifier).deleteUser();
                    },
                  );
                },
              );
            },
            title: const Text("Delete Account"),
            subtitle: Column(
              children: [
                const Text(
                  "WARNING! ALL YOUR DATA WILL BE REMOVED AND CAN'T BE RECOVERED",
                  style: TextStyle(color: Colors.redAccent),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_bubble_fill,
                        size: 36.0,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "This Features uses Firebase Delete User Data Extension",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.delete),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
