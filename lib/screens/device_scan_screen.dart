import 'package:avocato/utils/consts.dart';
import 'package:avocato/widgets/ble_scan_result_tile.dart';
import 'package:avocato/screens/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceScanScreen extends StatefulWidget {
  static bool autoConnect = true;
  @override
  _DeviceScanScreenState createState() => _DeviceScanScreenState();
}

class _DeviceScanScreenState extends State<DeviceScanScreen> {
  @override
  void initState() {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 5));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lastConnectedDeviceId = "";
    _getLastConnectedDeviceId().then((value) => lastConnectedDeviceId = value);
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
        actions: [
          IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: () =>
                  FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen.create(context, d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) {
                  print(
                      "auto connect was ${DeviceScanScreen.autoConnect} or last device name is $lastConnectedDeviceId");
                  if (snapshot.hasData && snapshot.data.length > 0) {

                    reOrderDevices(snapshot);
                    return Column(
                      children: snapshot.data.map((r) {
                        print("checking autoconnect");
                        if (DeviceScanScreen.autoConnect &&
                            r.device.id.toString() == lastConnectedDeviceId) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            print(" autoconnecting to $lastConnectedDeviceId");
                            connectToDevice(context, r);
                          });
                          return Container();
                        } else {
                          print(
                              "Autoconnect not possible because auto connect is ${DeviceScanScreen.autoConnect} and device Id is  ${r.device.id} and last device Id is $lastConnectedDeviceId");
                          return BleScanResultTile(
                            result: r,
                            onTap: () => connectToDevice(context, r),
                          );
                        }
                      }).toList(),
                    );
                  } else {
                    return Center(
                      heightFactor: 15,
                      child: Text(
                        "No matching device found. Switch on a device and refresh the page to try again.",
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Reorders the detected device list such that BME devices appear first
  void reOrderDevices(AsyncSnapshot<List<ScanResult>> snapshot) {
    print("Initial detected data ${snapshot.data}");
    //Take out non BME devices to separate list
    var nonBMEDevices = snapshot.data
        .where((a) => (!a.device.name.toLowerCase().startsWith(APP_DEVICE_NAME_PREFIX)))
        .toList();
    //Retain only BME devices in existing list
    snapshot.data
        .retainWhere((a) => a.device.name.toLowerCase().startsWith(APP_DEVICE_NAME_PREFIX));
    print("Removed data:$nonBMEDevices, only BME data ${snapshot.data}");
    //Append non BME devices list to only BME list
    snapshot.data.addAll(nonBMEDevices);
    print("Final reorganized data ${snapshot.data}");
  }

  Future connectToDevice(BuildContext context, ScanResult r) async {
    DeviceScanScreen.autoConnect = false;
    await r.device.connect().then((value) => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return HomeScreen.create(context, r.device);
        })));
  }

  Future<String> _getLastConnectedDeviceId() async {
    final sharedPreference = await SharedPreferences.getInstance();
    return sharedPreference.getString(PREF_CONNECTED_DEVICE);
  }
}
