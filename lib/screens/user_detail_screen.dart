import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  final String name;

  const UserDetailScreen({
    super.key,
    required this.name,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  bool isEmergency = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color bgColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: theme.colorScheme.background,
        title: Text(
          widget.name,
          style: const TextStyle(fontSize: 28),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.warning_amber_rounded,
              color: isEmergency ? theme.colorScheme.error : bgColor,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "2023.08.19",
              style: TextStyle(
                fontSize: 40,
                color: bgColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Machine 1 사용중",
              style: TextStyle(
                fontSize: 28,
                color: bgColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "시작",
                      style: TextStyle(
                        fontSize: 28,
                        color: bgColor,
                      ),
                    ),
                    Text(
                      "경과",
                      style: TextStyle(
                        fontSize: 28,
                        color: bgColor,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "11:11:11",
                        style: TextStyle(
                          fontSize: 28,
                          color: bgColor,
                        ),
                      ),
                      Text(
                        "00:30:00",
                        style: TextStyle(
                          fontSize: 28,
                          color: bgColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "27회",
              style: TextStyle(
                fontSize: 36,
                color: bgColor,
              ),
            ),
            Container(
              width: 370,
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: bgColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
