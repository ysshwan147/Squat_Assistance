import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final String name;

  const UserDetailScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.background,
        title: Text(
          name,
          style: const TextStyle(fontSize: 28),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "2023.08.19",
                  style: TextStyle(
                    fontSize: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "시작",
                            style: TextStyle(
                              fontSize: 28,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            "11:11:11",
                            style: TextStyle(
                              fontSize: 28,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "경과",
                            style: TextStyle(
                              fontSize: 28,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            "00:30:00",
                            style: TextStyle(
                              fontSize: 28,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 100,
                ),
                Text(
                  "27회",
                  style: TextStyle(
                    fontSize: 36,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            Container(
              width: 370,
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary,
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
