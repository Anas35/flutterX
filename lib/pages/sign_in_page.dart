import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/src/authentication/authentication_provider.dart';
import 'package:flutter_x/utils/extension.dart';
import 'package:flutter_x/utils/space_box.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset('assets/FlutterX.png'),
            const VerticalSpaceBox(30.0),
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
            const VerticalSpaceBox(30.0),
            Consumer(builder: (context, ref, _) {
              final signIn = ref.watch(authenticationNotifierProvider);
              ref.listen(authenticationNotifierProvider, (previous, next) {
                next.handleListen(
                  data: () {
                    context.goNamed('home');
                  },
                  error: context.snackbar,
                );
              });
              return ElevatedButton(
                onPressed: () {
                  if (_emailController.text.isEmpty) {
                    context.snackbar("Email is required");
                    return;
                  }
                  if (_passwordController.text.isEmpty) {
                    context.snackbar("Password is required");
                    return;
                  }
                  ref.read(authenticationNotifierProvider.notifier).signIn(_emailController.text, _passwordController.text);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                  ),
                ),
                child: Text(signIn.isLoading ? 'Loading' : 'Sign In'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
