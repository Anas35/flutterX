import 'dart:io' if (dart.library.html) 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/tweet/tweet_provider.dart';
import 'package:flutter_x/utils/extension.dart';
import 'package:go_router/go_router.dart';

class PostPage extends ConsumerStatefulWidget {
  const PostPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  List<PlatformFile> files = [];

  final _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(postProvider, (previous, next) {
      next.handleListen(data: () => context.pop(), error: (err) => context.snackbar(err));
    });
    final post = ref.watch(postProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_postController.text.isEmpty) {
                return;
              }
              ref.read(postProvider.notifier).post(_postController.text, files.map((e) => e.path!).toList());
            },
            child: const Text("Post"),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        child: FlutterLogo(),
                      ),
                      TextButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                          if (result != null) {
                            files.addAll(result.files);
                            setState(() {});
                          }
                        },
                        child: const Icon(Icons.image),
                      ),
                    ],
                  ),
                  TextField(
                    maxLines: 5,
                    controller: _postController,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: "Type About Flutter"),
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: files.map((file) {
                      return Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: DecorationImage(
                            image: FileImage(File(file.path!)),
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          if (post.isLoading) ...{
            const Center(
              child: CircularProgressIndicator(),
            ),
          }
        ],
      ),
    );
  }
}
