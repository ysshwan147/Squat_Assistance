import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:squat_assistance/background_collecting_task.dart';
import 'package:squat_assistance/screens/settings_screen.dart';
import 'package:squat_assistance/widgets/user_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool isConnected = true;

  BluetoothDevice? deviceWithAcc;
  BluetoothDevice? deviceWithBuzzer;

  BackgroundCollectingTask? _collectingTaskWithAcc;
  BackgroundCollectingTask? _collectingTaskWithBuzzer;

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTaskWithAcc?.dispose();
    _collectingTaskWithBuzzer?.dispose();
    super.dispose();
  }

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
            onPressed: () async {
              final BluetoothDevice? selectedDevice =
                  await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingsScreen();
                  },
                ),
              );

              if (selectedDevice != null) {
                if (deviceWithAcc != null && deviceWithBuzzer != null) {
                  _collectingTaskWithAcc?.cancel();
                  _collectingTaskWithBuzzer?.cancel();
                  deviceWithAcc = null;
                  deviceWithBuzzer = null;
                } else if (deviceWithAcc != null && deviceWithBuzzer == null) {
                  deviceWithBuzzer = selectedDevice;
                  await _startBackgroundTaskWithBuzzer(deviceWithBuzzer!);
                } else {
                  deviceWithAcc = selectedDevice;
                  await _startBackgroundTaskWithAcc(deviceWithAcc!);
                }
                setState(() {
                  /* Update for `_collectingTask.inProgress` */
                });
              }
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

  Future<void> _startBackgroundTaskWithAcc(BluetoothDevice server) async {
    try {
      _collectingTaskWithAcc =
          await BackgroundCollectingTask.connectWithAcc(server);
      await _collectingTaskWithAcc!.start();
    } catch (ex) {
      _collectingTaskWithAcc?.cancel();
    }
  }

  Future<void> _startBackgroundTaskWithBuzzer(BluetoothDevice server) async {
    try {
      _collectingTaskWithBuzzer =
          await BackgroundCollectingTask.connectWithBuzzer(server);
      await _collectingTaskWithBuzzer!.start();
    } catch (ex) {
      _collectingTaskWithBuzzer?.cancel();
    }
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
          ],
        ),
      ),
    );
  }
}
