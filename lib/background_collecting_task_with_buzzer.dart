import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:squat_assistance/notification.dart';

class DataSampleWithBuzzer {
  bool isEmergency;
  DateTime timestamp;

  DataSampleWithBuzzer({
    required this.isEmergency,
    required this.timestamp,
  });
}

class BackgroundCollectingTaskWithBuzzer extends Model {
  static BackgroundCollectingTaskWithBuzzer of(
    BuildContext context, {
    bool rebuildOnChange = false,
  }) =>
      ScopedModel.of<BackgroundCollectingTaskWithBuzzer>(
        context,
        rebuildOnChange: rebuildOnChange,
      );

  late final BluetoothConnection _connection;
  List<int> _buffer = List<int>.empty(growable: true);

  // @TODO , Such sample collection in real code should be delegated
  // (via `Stream<DataSample>` preferably) and then saved for later
  // displaying on chart (or even stright prepare for displaying).
  // @TODO ? should be shrinked at some point, endless colleting data would cause memory shortage.
  List<DataSampleWithBuzzer> samplesWithBuzzer =
      List<DataSampleWithBuzzer>.empty(growable: true);

  bool inProgress = false;

  BackgroundCollectingTaskWithBuzzer._fromConnectionWithBuzzer(
      this._connection) {
    _connection.input!.listen((data) {
      _buffer += data;

      while (true) {
        // If there is a sample, and it is full sent
        int index = _buffer.indexOf('e'.codeUnitAt(0));
        if (index >= 0 && _buffer.length - index >= 2) {
          bool flag = false;
          if (_buffer[index + 1] - '0'.codeUnitAt(0) == 1) {
            flag = true;
          }
          final DataSampleWithBuzzer sample = DataSampleWithBuzzer(
            isEmergency: flag,
            timestamp: DateTime.now(),
          );
          _buffer.removeRange(0, index + 2);

          print(sample.isEmergency);
          print(sample.timestamp);

          if (sample.isEmergency) {
            FlutterLocalNotification.showNotification();
          }

          samplesWithBuzzer.add(sample);
          notifyListeners(); // Note: It shouldn't be invoked very often - in this example data comes at every second, but if there would be more data, it should update (including repaint of graphs) in some fixed interval instead of after every sample.
          //print("${sample.timestamp.toString()} -> ${sample.temperature1} / ${sample.temperature2}");
        }
        // Otherwise break
        else {
          break;
        }
      }
    }).onDone(() {
      inProgress = false;
      notifyListeners();
    });
  }

  static Future<BackgroundCollectingTaskWithBuzzer> connectWithBuzzer(
      BluetoothDevice server) async {
    final BluetoothConnection connection =
        await BluetoothConnection.toAddress(server.address);
    return BackgroundCollectingTaskWithBuzzer._fromConnectionWithBuzzer(
        connection);
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    inProgress = true;
    _buffer.clear();
    samplesWithBuzzer.clear();
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.finish();
  }

  Future<void> pause() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.output.allSent;
  }

  Future<void> reasume() async {
    inProgress = true;
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }
}
