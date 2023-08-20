import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.description, required this.onConfirm});

  final String description;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(description, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            context.pop(context);
          },
          child: const Text("No"),
        )
      ],
    );
  }
}
