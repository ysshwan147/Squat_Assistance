import 'package:flutter/material.dart';
import 'package:squat_assistance/background_collecting_task_with_acc.dart';
import 'package:squat_assistance/background_collecting_task_with_buzzer.dart';

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
  @override
  Widget build(BuildContext context) {
    final BackgroundCollectingTaskWithAcc taskWithAcc =
        BackgroundCollectingTaskWithAcc.of(context, rebuildOnChange: true);

    final BackgroundCollectingTaskWithBuzzer taskWithBuzzer =
        BackgroundCollectingTaskWithBuzzer.of(context, rebuildOnChange: true);

    bool isUsing = taskWithAcc.samplesWithAcc.isNotEmpty;

    bool isEmergency = taskWithBuzzer.samplesWithBuzzer.isEmpty
        ? false
        : taskWithBuzzer.samplesWithBuzzer.last.isEmergency;

    int count = taskWithAcc.samplesWithAcc.isEmpty
        ? 0
        : taskWithAcc.samplesWithAcc.last.squatCount;

    final today = DateTime.now();
    final year = today.year;
    final month = today.month;
    final day = today.day;

    final startTime =
        isUsing ? taskWithAcc.samplesWithAcc.first.timestamp : null;
    final strStartTime = startTime?.toIso8601String().substring(11, 19);

    final exerciseTime = isUsing ? today.difference(startTime!) : null;

    String? temp;
    if (exerciseTime != null && exerciseTime.inHours < 10) {
      temp = "0${exerciseTime.toString()}";
    } else if (exerciseTime != null) {
      temp = exerciseTime.toString();
    }
    final strExerciseTime = temp?.substring(0, 8);

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
              color: isUsing && isEmergency ? theme.colorScheme.error : bgColor,
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
              "$year.$month.$day",
              style: TextStyle(
                fontSize: 40,
                color: bgColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              isUsing ? "Machine 1 사용중" : "Not connected",
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
                        isUsing ? strStartTime! : "00:00:00",
                        style: TextStyle(
                          fontSize: 28,
                          color: bgColor,
                        ),
                      ),
                      Text(
                        isUsing ? strExerciseTime! : "00:00:00",
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
              "$count 회",
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
