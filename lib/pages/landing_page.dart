import 'package:flutter/material.dart';
import 'package:flutter_x/utils/space_box.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/FlutterX.png'),
            const VerticalSpaceBox(40.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(250.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              ),
              onPressed: () {
                context.pushNamed('signup');
              },
              child: const Text('Create Account', textAlign: TextAlign.center),
            ),
            const SizedBox(height: 30),
            TextButton(              
              style: TextButton.styleFrom(
                fixedSize: const Size.fromWidth(250.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                elevation: 8.0,                
              ),
              onPressed: () {
                context.pushNamed('signin');
              },
              child: const Text('Welcome Back! Sign In Here!', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}