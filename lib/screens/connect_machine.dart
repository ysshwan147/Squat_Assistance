import 'package:flutter/material.dart';

class ConnectMachineScreen extends StatelessWidget {
  const ConnectMachineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.background,
        title: const Text(
          "운동기구 연결",
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: const Placeholder(),
    );
  }
}
