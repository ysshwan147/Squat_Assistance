import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:squat_assistance/background_collecting_task_with_acc.dart';
import 'package:squat_assistance/background_collecting_task_with_buzzer.dart';
import 'package:squat_assistance/notification.dart';
import 'package:squat_assistance/screens/settings_screen.dart';
import 'package:squat_assistance/widgets/user_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isConnectedWithAcc;
  late bool isConnectedWithBuzzer;

  BluetoothDevice? deviceWithAcc;
  BluetoothDevice? deviceWithBuzzer;

  BackgroundCollectingTaskWithAcc? _collectingTaskWithAcc;
  BackgroundCollectingTaskWithBuzzer? _collectingTaskWithBuzzer;

  @override
  void initState() {
    super.initState();
    isConnectedWithAcc = false;
    isConnectedWithBuzzer = false;

    FlutterLocalNotification.init();

    // 3초 후 권한 요청
    Future.delayed(const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission());
  }

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
                  isConnectedWithAcc = false;
                  isConnectedWithBuzzer = false;
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
      body: isConnectedWithAcc && isConnectedWithBuzzer
          ? SingleChildScrollView(
              child: Container(
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
                    ScopedModel<BackgroundCollectingTaskWithBuzzer>(
                      model: _collectingTaskWithBuzzer!,
                      child: ScopedModel<BackgroundCollectingTaskWithAcc>(
                          model: _collectingTaskWithAcc!,
                          child: User(
                            name: "User1",
                            collectingTaskWithAcc: _collectingTaskWithAcc,
                            collectingTaskWithBuzzer: _collectingTaskWithBuzzer,
                          )),
                    ),
                  ],
                ),
              ),
            )
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
          await BackgroundCollectingTaskWithAcc.connectWithAcc(server);
      await _collectingTaskWithAcc!.start();
      isConnectedWithAcc = true;
    } catch (ex) {
      _collectingTaskWithAcc?.cancel();
      isConnectedWithAcc = false;
    }
  }

  Future<void> _startBackgroundTaskWithBuzzer(BluetoothDevice server) async {
    try {
      _collectingTaskWithBuzzer =
          await BackgroundCollectingTaskWithBuzzer.connectWithBuzzer(server);
      await _collectingTaskWithBuzzer!.start();
      isConnectedWithBuzzer = true;
    } catch (ex) {
      _collectingTaskWithBuzzer?.cancel();
      isConnectedWithBuzzer = false;
    }
  }
}
