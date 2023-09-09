import 'package:flutter/material.dart';
import 'package:squat_assistance/screens/user_detail_screen.dart';

class User extends StatefulWidget {
  final String name;

  const User({
    super.key,
    required this.name,
  });

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  bool isUsing = false;
  bool isEmergency = false;

  void setIsUsingByBLE() {
    setState(() {
      isUsing = !isUsing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color bgColor =
        isUsing ? theme.colorScheme.primary : theme.colorScheme.secondary;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailScreen(
              name: widget.name,
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
                    color: isEmergency ? theme.colorScheme.error : bgColor,
                  ),
                ],
              ),
              Text(
                "Time",
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
