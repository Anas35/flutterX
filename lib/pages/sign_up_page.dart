import 'dart:io' if (dart.library.html) 'dart:html';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/authentication/authentication_provider.dart';
import 'package:flutter_x/src/user/user.dart';
import 'package:flutter_x/src/user/user_provider.dart';
import 'package:flutter_x/utils/extension.dart';
import 'package:flutter_x/utils/space_box.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();

  PlatformFile? file;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Center(
                  child: Text("FlutterX", style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w800)),
                ),
                const VerticalSpaceBox(30.0),
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
                    backgroundImage: file != null ? FileImage(File(file!.path!)) : null,
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                const VerticalSpaceBox(16.0),
                TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    labelText: 'Unique User Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "UserName is required";
                    }
                    return null;
                  },
                ),
                const VerticalSpaceBox(16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                const VerticalSpaceBox(16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                const VerticalSpaceBox(32.0),
                Consumer(builder: (context, ref, _) {
                  final signUp = ref.watch(authenticationNotifierProvider);
                  ref.listen(authenticationNotifierProvider, (previous, next) {
                    next.handleListen(
                      data: () {
                        context.goNamed('home');
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
                      onPressed: signUp.isLoading
                          ? null
                          : () async {
                              if (file == null) {
                                context.snackbar("Please add profile picture");
                                return;
                              }

                              if (!(_formKey.currentState?.validate() ?? true)) {
                                return;
                              }

                              bool isUnique = await ref.read(uniqueNameProvider(_userNameController.text).future);

                              if (!isUnique && context.mounted) {
                                context.snackbar("Please enter unique User Name");
                                return;
                              }

                              final user = XUser(
                                profileUrl: file!.path!,
                                id: '',
                                email: _emailController.text,
                                name: _nameController.text,
                                userName: _userNameController.text,
                              );

                              ref.read(authenticationNotifierProvider.notifier).signUp(user, _passwordController.text);
                            },
                      child: signUp.isLoading ? const Text('Loading') : const Text('Sign Up'),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
