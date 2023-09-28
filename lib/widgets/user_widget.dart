import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:squat_assistance/background_collecting_task_with_acc.dart';
import 'package:squat_assistance/background_collecting_task_with_buzzer.dart';
import 'package:squat_assistance/screens/user_detail_screen.dart';

class User extends StatefulWidget {
  final String name;
  final BackgroundCollectingTaskWithAcc? collectingTaskWithAcc;
  final BackgroundCollectingTaskWithBuzzer? collectingTaskWithBuzzer;

  const User({
    super.key,
    required this.name,
    required this.collectingTaskWithAcc,
    required this.collectingTaskWithBuzzer,
  });

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    final BackgroundCollectingTaskWithAcc taskWithAcc =
        BackgroundCollectingTaskWithAcc.of(context, rebuildOnChange: true);
    final BackgroundCollectingTaskWithBuzzer taskWithBuzzer =
        BackgroundCollectingTaskWithBuzzer.of(context, rebuildOnChange: true);

    final isUsing = taskWithAcc.samplesWithAcc.isNotEmpty;

    final isEmergency = taskWithBuzzer.samplesWithBuzzer.isEmpty
        ? false
        : taskWithBuzzer.samplesWithBuzzer.last.isEmergency;

    final startTime =
        isUsing ? taskWithAcc.samplesWithAcc.first.timestamp : null;
    final currentTime = DateTime.now();
    final exerciseTime = isUsing ? currentTime.difference(startTime!) : null;

    String? temp;
    if (exerciseTime != null && exerciseTime.inHours < 10) {
      temp = "0${exerciseTime.toString()}";
    } else if (exerciseTime != null) {
      temp = exerciseTime.toString();
    }
    final strExerciseTime = temp?.substring(0, 8);

    final theme = Theme.of(context);
    Color bgColor =
        isUsing ? theme.colorScheme.primary : theme.colorScheme.secondary;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScopedModel<BackgroundCollectingTaskWithAcc>(
              model: widget.collectingTaskWithAcc!,
              child: ScopedModel<BackgroundCollectingTaskWithBuzzer>(
                model: widget.collectingTaskWithBuzzer!,
                child: UserDetailScreen(
                  name: widget.name,
                ),
              ),
            ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 24,
                      color: theme.colorScheme.background,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.warning_amber_rounded,
                    color: isUsing && isEmergency
                        ? theme.colorScheme.error
                        : bgColor,
                  ),
                ],
              ),
              Text(
                isUsing ? strExerciseTime! : "00:00:00",
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
