import 'package:avocato/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          APP_HEADER_DISPLAY_NAME,
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 80),
          child: Image.asset(
            'assets/images/headerline.png',
            height: 40,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        backgroundColor: AVOCADO_DARK_GREEN,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Color(0xffbfc0c2),
            ),
            Text(
              'Phone Bluetooth is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  .copyWith(color: Color(0xffbfc0c2)),
            ),
          ],
        ),
      ),
    );
  }
}