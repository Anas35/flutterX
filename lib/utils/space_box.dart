import 'package:flutter/material.dart';

class VerticalSpaceBox extends StatelessWidget {
  const VerticalSpaceBox(this.space, {super.key});

  final double space;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: space);
  }
}