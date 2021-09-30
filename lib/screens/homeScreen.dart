import 'dart:async';
import 'package:avocato/models/bme688_bloc.dart';
import 'package:avocato/models/bme_model.dart';
import 'package:avocato/models/label_model.dart';
import 'package:avocato/landing_page.dart';
import 'package:avocato/screens/configuration_screen.dart';
import 'package:avocato/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'demo_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, @required this.device, this.bloc}) : super(key: key);
  final BluetoothDevice device;
  final Bme688Bloc bloc;

  static Widget create(BuildContext context, BluetoothDevice device) {
    print("print of create is called");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Bme688Bloc>.value(
          value: Bme688Bloc(device: device),
          child: Consumer<Bme688Bloc>(
            builder: (context, bloc, _) => HomeScreen(
              device: device,
              bloc: bloc,
            ),
          ),
        ),
        ChangeNotifierProxyProvider<Bme688Bloc, LabelModel>(
          create: (context) => LabelModel(device.id.toString()),
          update: (_, bme688Bloc, labelController) =>
              labelController..updateReceivedLabel(bme688Bloc.selectedLabelId),
          child: Consumer<Bme688Bloc>(
            builder: (context, bloc, _) => ConfigurationScreen(),
          ),
        ),
        ChangeNotifierProxyProvider<Bme688Bloc, BME68xModel>(
          create: (context) => BME68xModel(),
          update: (_, bme688Bloc, bme68xModel) =>
              bme68xModel..addBmeData(bme688Bloc.parsedBmeData),
        ),
      ],
      child: Consumer<Bme688Bloc>(
        builder: (context, bloc, _) => HomeScreen(
          device: device,
          bloc: bloc,
        ),
      ),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Widget _mainScreen = DemoScreen();

  @override
  void initState() {
    //Subscribe to any errors generated by bloc and display them as toast
    widget.bloc.error.listen((eventMessage) {
      Fluttertoast.showToast(
          msg: eventMessage,
          backgroundColor: Colors.grey[200],
          textColor: Colors.red,
          timeInSecForIosWeb: 5,
          toastLength: Toast.LENGTH_LONG);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => _onWillDisconnect(context),
      child: StreamBuilder<BluetoothDeviceState>(
        stream: widget.device.state,
        initialData: BluetoothDeviceState.connecting,
        builder: (c, snapshot) {
          if (snapshot.data == BluetoothDeviceState.connected) {
            widget.bloc.startConnection();
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  APP_HEADER_DISPLAY_NAME,
                ),
                actions: <Widget>[
                  IconButton(
                      icon: ImageIcon(AssetImage(ICON_BLUETOOTH_LE)),
                      onPressed: () {
                        _onWillDisconnect(context);
                      })
                ],
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
              body: _mainScreen,
            );
          } else if (snapshot.data == BluetoothDeviceState.disconnected) {
            onDisconnectClick(context);
            Fluttertoast.showToast(
              msg: "Device disconnected",
            );
          }
          print("device state is ${snapshot.data}");
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                APP_HEADER_DISPLAY_NAME,
              ),
              backgroundColor: AVOCADO_DARK_GREEN,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  void onDisconnectClick(BuildContext context) {
    widget.bloc.disconnectDevice().then(
          (value) => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return LandingPage();
              },
            ),
          ),
        );
  }

  Future<bool> _onWillDisconnect(BuildContext context) async {
    print("Disconnect called from home");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Disconnect"),
          content: Text("Disconnect the device?"),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Disconnect'),
              onPressed: () {
                onDisconnectClick(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    //Do not pop. call disconnect instead for smoother exit
    return false;
  }
}
