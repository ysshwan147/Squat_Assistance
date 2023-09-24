import 'package:flutter/material.dart';
import 'package:squat_assistance/screens/connect_machine.dart';
import 'package:squat_assistance/screens/edit_user_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color bgColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.background,
        title: const Text(
          "설정",
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: Column(
        children: [
          Container(
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
                Settings(name: "사용자 편집", screen: EditUserScreen()),
                Settings(name: "운동 기구 연결", screen: ConnectMachineScreen())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Settings extends StatelessWidget {
  final String name;
  final Widget screen;

  const Settings({
    super.key,
    required this.name,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color bgColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: const Border(
            bottom: BorderSide(
              width: 3,
              color: Colors.white,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  color: theme.colorScheme.background,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
