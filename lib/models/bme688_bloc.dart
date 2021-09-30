import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avocato/data/bme_data.dart';
import 'package:avocato/data/bsec_data.dart';
import 'package:avocato/data/sensor_data.dart';
import 'package:avocato/utils/bme688_profile.dart';
import 'package:avocato/utils/consts.dart';
import 'package:avocato/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bme688Bloc extends PropertyChangeNotifier<String> {
  Bme688Bloc({@required this.device});

  BluetoothCharacteristic _writeCharacteristic;
  BluetoothCharacteristic _readCharacteristic;
  bool _isNotificationEnabled = false;
  bool _isMtuRequested = false;
  int packetAccumulator = 0;
  String jsonAccumulator = "";
  bool _isDiscoverServiceCalled = false;
  bool _isListeningNotifications = false;
  bool _isListeningServices = false;
  bool _isListeningMtu = false;
  bool _isUpdatingSensor = false;

  List<BsecData> _bsecData = new List<BsecData>();
  int selectedLabelId = 0;
  BmeData _parsedBmeData;

  BmeData get parsedBmeData => _parsedBmeData;

  SensorLabel __currentSensor = Constants.Sensors[Default_sensor_Id];

  List<BsecData> get bsecEstimates => _bsecData;

  SensorLabel get currentSensor => __currentSensor;
  set _currentSensor(SensorLabel value) {
    print("Change of sensor called");
    __currentSensor = value;
    notifyListeners(PROPERTY_CURRENT_SENSOR);
  }

  final BluetoothDevice device;
  StreamController<String> _errorController = StreamController<String>();
  StreamSubscription<List<int>> _notificationsListener;
  StreamSubscription<int> _mtuListner;
  StreamSubscription<List<BluetoothService>> _serviceListener;

  Stream<String> get error => _errorController.stream;

  void dispose() {
    _errorController.close();
  }

  Future<void> _cleanupConnection() async {
    print("Disposing connection");
    _errorController?.close();
    jsonAccumulator = "";
    await _notificationsListener?.cancel();
    await _mtuListner?.cancel();
    await _serviceListener?.cancel();
    _readCharacteristic = null;
    _notificationsListener = null;
    _writeCharacteristic = null;
    _serviceListener = null;
    _mtuListner = null;
    _isNotificationEnabled = false;
    _isMtuRequested = false;
    _isDiscoverServiceCalled = false;
  }

  Future<void> startConnection() async {
    final sharePreference = await SharedPreferences.getInstance();
    await sharePreference.setString(
        PREF_CONNECTED_DEVICE, device.id.toString());
    

    if (_mtuListner == null && !_isListeningMtu) {
      _isListeningMtu = true;
      sleep(Duration(milliseconds: 500));//Delay is required for MTU negotiation for iOS release version.
      _mtuListner = device.mtu.listen((event) async {
        print("MTU value is $event");
        if (event >= DEFAULT_MTU && !_isDiscoverServiceCalled) {
          sleep(Duration(seconds: 1));
          print("Getting services");
          _isDiscoverServiceCalled = true;
          await device.discoverServices();
        } else if (event < DEFAULT_MTU && !_isMtuRequested) {
          try {
            if(!Platform.isIOS) {
              device.requestMtu(DEFAULT_MTU);
              _isMtuRequested = true;
            }
          } on Exception catch (e) {
            print("Could not update MTU. $e");
          }
        }
      });
    }
    if (!_isListeningServices) {
      _isListeningServices = true;
      device.services.listen((value) async {
        await _processDiscoveredServices(value);
      });
    }
  }

  Future<void> _processDiscoveredServices(
      List<BluetoothService> services) async {
    print("Receiving services discovered");
    services.forEach((service) {
      print("Processing service $service");

      if (service != null &&
          service.uuid.toString().toUpperCase() == MAIN_SERVICE_ID) {
        service.characteristics.forEach((characteristic) async {
          if (characteristic.uuid.toString().toUpperCase() ==
              NOTIFICATION_CHARACTERISTIC_ID) {
            _readCharacteristic = characteristic;
            print("read characteristic discovered");
            if (_notificationsListener == null && !_isListeningNotifications) {
              _isListeningNotifications = true;
              _notificationsListener = characteristic.value.listen((event) {
                print("Recieved data ${String.fromCharCodes(event)}");
                _onCharacteristicReceived?.call(event);
              });
            }

            if (!_readCharacteristic.isNotifying && !_isNotificationEnabled) {
              print("subscribing to notifications characteristic");
              _isNotificationEnabled = true;

              await _readCharacteristic.setNotifyValue(true).then(
                  (value) async =>
                      await _setUnixTimeStamp()); //Subscribes to notifications
            }
          } else if (characteristic.uuid.toString().toUpperCase() ==
              WRITE_CHARACTERISTIC_ID) {
            _writeCharacteristic = characteristic;
          }
        });
      }
    });
  }

  Future _setUnixTimeStamp() async {
    if (_writeCharacteristic != null) {
      sleep(Duration(milliseconds: 100));
      print("Starting write command");
      await _setRtcTime();
    } else {
      print("Oops write characteristic is null");
    }
  }

  Future<void> updateSensor(SensorLabel sensor) async {
    print(
        "device is ${device == null}, sensorId is ${__currentSensor.labelIndex}, writecharacteristic is ${_writeCharacteristic == null}");
    if (Validator.isValidSensorId(sensor.labelIndex) &&
        sensor != __currentSensor) {
      _currentSensor = sensor;
      _isUpdatingSensor = true;
      await _stopSensor();
    }
  }

  Future<void> _startSensor() async {
    final startCommand =
        "start ${__currentSensor.labelIndex} $Default_data_rate $All_OUTPUT_ID"
            .codeUnits; //subtract sensor id by 1 as the command takes sensor IDs starting from 0
    print("Sending Start command $startCommand");
    await Future.delayed(Duration(milliseconds: 100));
    await _writeCharacteristic
        .write(startCommand, withoutResponse: false)
        .then((value) => {
              //TODO:Verify that write was successful
              print("Write command result is success")
              // print("Write command result is: ${Uint8List.fromList(await _readCharacteristic.read())}")
            });
  }

  Future<void> _setRtcTime() async {
    final unixTimeStamp = (DateTime.now().toUtc().millisecondsSinceEpoch / 1000)
        .round(); //Convert milliseconds to seconds
    print("Writing time stamp $unixTimeStamp");
    final setRtcTimeCommand = "setrtctime $unixTimeStamp".codeUnits;
    Future.delayed(Duration(milliseconds: 500));
    await _writeCharacteristic.write(setRtcTimeCommand, withoutResponse: false);
  }

  Future<void> disconnectDevice() async {
    print("trying disconnect");
   await device.state.first.then((value) async => {
          if (value != BluetoothDeviceState.disconnected)
            {
              print("Calling disconnect"),
              await _stopSensor(),
            }
          else
            {
              print("Calling cleanup"),
              await _cleanupConnection(),
            }
        });
  }

  Future _stopSensor() async {
    final stopCommand = "stop".codeUnits;
    print("Sending Stop command $stopCommand");
    try{
    await _writeCharacteristic.write(stopCommand);}
    on Exception catch (e) {
      print("Error writing characteristic. Disconnecting anyway.: $e");
      await _cleanupConnection();
      await device?.disconnect();
    }
  }

  Future<void> setLabel(int labelId) async {
    print("Requesting set label of $labelId");
    final setLabelCommand = "setlabel $labelId".codeUnits;
    await _writeCharacteristic.write(setLabelCommand);
  }

  Future<void> getLabel() async {
    await _writeCharacteristic.write("getlabel".codeUnits);
  }

  Future<void> _onCharacteristicReceived(List<int> data) async {
    print("Provessing data");
    if (data.isNotEmpty) {
      var jsonData = String.fromCharCodes(data);
      Map<String, dynamic> decodedData = null;

      try {
        if (jsonAccumulator == jsonData) {
          print("Parsing equal accumulator $decodedData");
          return null;
        }
        print("Parsing $jsonData");
        decodedData = json.decode(jsonAccumulator + jsonData);
        jsonAccumulator = "";
      } on FormatException catch (e) {
        print(e);
        try {
          if (jsonAccumulator == jsonData) {
            print("Parsing equal accumulator $jsonData");
            return null;
          }
          print("Parsing accumulator $jsonData");
          decodedData =
              json.decode(jsonAccumulator = jsonAccumulator + jsonData);
          jsonAccumulator = "";
        } on FormatException catch (e) {
          print("Parsed accumulator: $e");
          // TODO:Display error in packets
          return null;
        }
      }
      // decodedData = json.decode(jsonData);

      switch (decodedData.keys.first) {
        case TAG_BME68X: //Handle bme data
          // print("received bme log $data");
          _parsedBmeData = BmeData.fromJson(decodedData);
          notifyListeners();
          break;
        case TAG_BSEC: //Handle bsec data
          print("received bsec log");
          final gasResult = BsecData.fromJson(decodedData);
          _addDetectedGasResult(gasResult);
          break;
        case "setlabel":
          print("set label success");
          getLabel();
          break;
        case "getlabel":
          selectedLabelId = decodedData.values.elementAt(1);
          notifyListeners();
          print(
              "Updating received get label ${decodedData.values.elementAt(1)}");
          break;
        case "setrtctime":
          if (decodedData.values.first.toString() == "0") {
            print("rtc time set.");
            _startSensor();
          } else {
            print(
                "Error setting rtc time. response: ${String.fromCharCodes(data)}");
          }
          break;
        case "getrtctime":
          break;
        case "start":
          final response = decodedData.values.first;
          if (response.toString() != "0") {
            print("Start error");
            _errorController.add(
                "Could not start sensor. response code: ${ErrorCodes.values[response].toString().split('.')[1]}");
          }
          break;
        case "stop":
          if (_isUpdatingSensor) {
            print("Stop command successful. Restarting sensor");
            _isUpdatingSensor = false;
            _clearDetectedGasResults();
            await _startSensor();
          } else {
            print("Stop was successful. Disconnecting..");
            await _cleanupConnection();
            await device?.disconnect();
          }
          break;
      }
    }
  }

  void _addDetectedGasResult(BsecData gasResult) {
    if (_bsecData != null &&
        _bsecData.length >= Max_Gas_Estimates_To_Remember) {
      _bsecData.removeAt(0);
    }
    _bsecData.add(gasResult);
    notifyListeners();
  }

  void _clearDetectedGasResults() {
    _bsecData.clear();
    notifyListeners();
  }
}
