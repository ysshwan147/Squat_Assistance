import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';

class DataSampleWithAcc {
  int squatCount;

  DataSampleWithAcc({
    required this.squatCount,
  });
}

class DataSampleWithBuzzer {
  bool isEmergency;
  DateTime timestamp;

  DataSampleWithBuzzer({
    required this.isEmergency,
    required this.timestamp,
  });
}

class BackgroundCollectingTask extends Model {
  static BackgroundCollectingTask of(
    BuildContext context, {
    bool rebuildOnChange = false,
  }) =>
      ScopedModel.of<BackgroundCollectingTask>(
        context,
        rebuildOnChange: rebuildOnChange,
      );

  late final BluetoothConnection _connection;
  List<int> _buffer = List<int>.empty(growable: true);

  // @TODO , Such sample collection in real code should be delegated
  // (via `Stream<DataSample>` preferably) and then saved for later
  // displaying on chart (or even stright prepare for displaying).
  // @TODO ? should be shrinked at some point, endless colleting data would cause memory shortage.
  List<DataSampleWithAcc> samplesWithAcc =
      List<DataSampleWithAcc>.empty(growable: true);
  List<DataSampleWithBuzzer> samplesWithBuzzer =
      List<DataSampleWithBuzzer>.empty(growable: true);

  bool inProgress = false;

  BackgroundCollectingTask._fromConnectionWithAcc(this._connection) {
    _connection.input!.listen((data) {
      _buffer += data;

      while (true) {
        // If there is a sample, and it is full sent
        int index = _buffer.indexOf('a'.codeUnitAt(0));
        int numLength = _buffer[index + 1] - '0'.codeUnitAt(0) + 1;

        if (index >= 0 && _buffer.length - index >= numLength + 2) {
          int count = 0;
          for (int i = 0; i < numLength; i++) {
            count += (_buffer[index + 2 + i] - '0'.codeUnitAt(0)) *
                (pow(10, (numLength - i - 1)) as int);
          }

          final DataSampleWithAcc sample = DataSampleWithAcc(
            squatCount: count,
          );
          _buffer.removeRange(0, index + numLength + 2);

          print(sample.squatCount);

          samplesWithAcc.add(sample);
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

  BackgroundCollectingTask._fromConnectionWithBuzzer(this._connection) {
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

  static Future<BackgroundCollectingTask> connectWithAcc(
      BluetoothDevice server) async {
    final BluetoothConnection connection =
        await BluetoothConnection.toAddress(server.address);
    return BackgroundCollectingTask._fromConnectionWithAcc(connection);
  }

  static Future<BackgroundCollectingTask> connectWithBuzzer(
      BluetoothDevice server) async {
    final BluetoothConnection connection =
        await BluetoothConnection.toAddress(server.address);
    return BackgroundCollectingTask._fromConnectionWithBuzzer(connection);
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    inProgress = true;
    _buffer.clear();
    samplesWithAcc.clear();
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
