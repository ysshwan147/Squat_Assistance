import 'package:flutter/material.dart';

class EditUserScreen extends StatelessWidget {
  const EditUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.background,
        title: const Text(
          "사용자 편집",
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: const Placeholder(),
    );
  }
}
