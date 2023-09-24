import 'package:flutter/material.dart';
import 'package:squat_assistance/screens/settings_screen.dart';
import 'package:squat_assistance/widgets/user_widget.dart';

class HomeScreen extends StatelessWidget {
  final bool isConnected = true;

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.background,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.settings,
              size: 35,
              color: theme.colorScheme.background,
            ),
          ),
        ],
        title: const Text(
          "사용 현황",
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: isConnected
          ? const UserList()
          : const Center(
              child: Text(
                "There are no connected machines",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 3,
              color: Colors.white,
            ),
          ),
        ),
        child: const Column(
          children: [
            User(
              name: "User1",
            ),
            User(
              name: "User2",
            ),
            User(
              name: "User3",
            ),
          ],
        ),
      ),
    );
  }
}
