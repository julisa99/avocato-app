import 'package:avocato/models/bme688_bloc.dart';
import 'package:avocato/models/bme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

int lastState = 0;

bool checkForNotification(int state) {
  if (lastState == 0 && state == 1)
  Fluttertoast.showToast(
          msg: "Your avocado is ready!",
          backgroundColor: Colors.grey[200],
          textColor: Colors.green,
          timeInSecForIosWeb: 5,
          toastLength: Toast.LENGTH_LONG);
  lastState = state;
return state == 0;
}

class RecentGasResults extends StatelessWidget {
  final Widget _awake = Image.asset(
              'assets/images/avocado_awake.gif',
              height: 500,
            );
  final Widget _asleep = Image.asset(
            'assets/images/avocado_sleep.gif',
            height: 500,
          );

  
  @override
  Widget build(BuildContext context) {
    final bme68xDataModel = Provider.of<BME68xModel>(context);
    print("building lables");
    //print("Circular indicator bme68xDataModel.bme68xData.length : ${bme68xDataModel.bme68xData.length > 0},bme68xDataModel.bme68xData.last.length % 10 : ${bme68xDataModel.bme68xData.last.length % 10}");

    return Container(
      padding: EdgeInsets.all(20),
      child: Consumer<Bme688Bloc>(
        builder: (context, _estimates, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Gas Scanner',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _estimates != null &&
                            _estimates.bsecEstimates.isNotEmpty &&
                            _estimates.bsecEstimates.length > 0
                        ? (checkForNotification(_estimates
                            .bsecEstimates[_estimates.bsecEstimates.length - 1].detectedGasEstimate.classId) ? _asleep : _awake)
                        : _asleep
                ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
