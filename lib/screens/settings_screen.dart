import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:squat_assistance/screens/connect_machine.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color bgColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
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
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final BluetoothDevice? selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const ConnectMachineScreen(
                              checkAvailability: false);
                        },
                      ),
                    );

                    Navigator.of(context).pop(selectedDevice);
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
                            "횟수 센서 연결",
                            style: TextStyle(
                              fontSize: 24,
                              color: theme.colorScheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final BluetoothDevice? selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const ConnectMachineScreen(
                              checkAvailability: false);
                        },
                      ),
                    );

                    Navigator.of(context).pop(selectedDevice);
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
                            "비상 센서 연결",
                            style: TextStyle(
                              fontSize: 24,
                              color: theme.colorScheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
