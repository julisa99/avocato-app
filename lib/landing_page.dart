import 'dart:io';

import 'package:avocato/screens/bluetooth_off_screen.dart';
import 'package:avocato/screens/device_scan_screen.dart';
import 'package:avocato/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LandingPage extends StatelessWidget {
  DateTime _backPressTimeRemaining;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: AVOCADO_DARK_GREEN),
      home: Scaffold(
        body: WillPopScope(
            child: Builder(
              builder: (BuildContext context) {
                return StreamBuilder<BluetoothState>(
                    stream: FlutterBlue.instance.state,
                    initialData: BluetoothState.unknown,
                    builder: (c, snapshot) {
                      final state = snapshot.data;
                      if (state == BluetoothState.on) {
                        print("Device Bluetooth turnned on");
                        return DeviceScanScreen();
                      }
                      print("Device Bluetooth turnned off");
                      return BluetoothOffScreen(state: state);
                    });
              },
            ),
            onWillPop: () async => await onWillExitApp(context)),
      ),
    );
  }

  Future<bool> onWillExitApp(BuildContext context) async {
    DateTime now = DateTime.now();
    if (_backPressTimeRemaining == null ||
        now.difference(_backPressTimeRemaining) > Duration(seconds: 2)) {
      _backPressTimeRemaining = now;
      print("Showing app exit message");
      Fluttertoast.showToast(msg: "Press Back again to exit the app");
      return Future.value(false);
    }
    exit(0);
    return Future.value(true);
  }
}
