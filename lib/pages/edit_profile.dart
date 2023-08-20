import 'dart:io' if (dart.library.html) 'dart:html';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/user/user.dart';
import 'package:flutter_x/src/user/user_provider.dart';
import 'package:flutter_x/utils/extension.dart';
import 'package:flutter_x/utils/space_box.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  PlatformFile? file;
  late XUser user;

  ImageProvider<Object> getImage() {
    if (file != null) {
      return FileImage(File(file!.path!));
    } else {
      return NetworkImage(user.profileUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    user = ref.watch(getCurrentUserProvider).valueOrNull!;
    _emailController.text = user.email;
    _nameController.text = user.name;
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Text("Update Profile", style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w600)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const VerticalSpaceBox(10.0),
              GestureDetector(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    file = result.files.first;
                    setState(() {});
                  }
                },
                child: CircleAvatar(
                  radius: 54.0,
                  backgroundImage: getImage(),
                  child: Visibility(
                    visible: file == null,
                    child: const Center(
                      child: Icon(Icons.add, size: 32.0),
                    ),
                  ),
                ),
              ),
              const VerticalSpaceBox(20.0),
              TextFormField(
                initialValue: '@${user.userName}',
                decoration: const InputDecoration(
                  labelText: 'User Name',
                ),
              ),
              const VerticalSpaceBox(20.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const VerticalSpaceBox(20.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const VerticalSpaceBox(32.0),
              Consumer(builder: (context, ref, _) {
                final update = ref.watch(updateProvider);
                ref.listen(updateProvider, (previous, next) {
                  next.handleListen(
                    data: () {
                      context.snackbar("Updated Successfully");
                      ref.invalidate(getCurrentUserProvider);
                    },
                    error: context.snackbar,
                  );
                });
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0),
                        ),
                      ),
                    ),
                    onPressed: update.isLoading
                        ? null
                        : () {
                            if (_nameController.text.isEmpty) {
                              context.snackbar("Name should not be empty");
                              return;
                            }
                            if (_emailController.text.isEmpty) {
                              context.snackbar("Email is required");
                              return;
                            }
                            user = XUser(
                              profileUrl: user.profileUrl,
                              id: user.id,
                              userName: user.name,
                              email: _emailController.text,
                              name: _nameController.text,
                            );
                            ref.read(updateProvider.notifier).updateUser(user, file?.path);
                          },
                    child: update.isLoading ? const Text('Loading') : const Text('Update'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
