import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BleScanResultTile extends StatelessWidget {
  const BleScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildLeading(BuildContext context) {
    //TODO:Differentiate between BLE and Non BLE
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.bluetooth,
          color: Colors.black,
        ),
        Text(
          "${result.rssi} dB",
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: _buildTitle(context),
        onTap: (result.advertisementData.connectable) ? onTap : null,
        leading: _buildLeading(context),
        trailing: (result.advertisementData.connectable)
            ? Icon(Icons.arrow_forward_ios)
            : null,
      ),
      Divider(
        thickness: 1,
        height: 5,
      ),
    ]);
  }
}
