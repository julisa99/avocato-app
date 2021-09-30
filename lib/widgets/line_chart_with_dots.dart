import 'package:avocato/models/bme688_bloc.dart';
import 'package:avocato/models/bme_model.dart';
import 'package:avocato/utils/consts.dart';

/// Line chart example
//import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PointsLineChart extends StatefulWidget {
  @override
  _PointsLineChartState createState() => _PointsLineChartState();
}

class _PointsLineChartState extends State<PointsLineChart> {
  BME68xModel _bme8xModel;

  @override
  Widget build(BuildContext context) {
    Provider.of<Bme688Bloc>(context)
        .addListener(onSensorIdChanged, [PROPERTY_CURRENT_SENSOR]);
    _bme8xModel = Provider.of<BME68xModel>(context);
    //final chartSeriesList = convertBmeDataToChartData(_bme8xModel.bme68xData);
    // return new charts.LineChart(
    //   chartSeriesList,
    //   animate: false,
    //   defaultRenderer: new charts.LineRendererConfig(includePoints: true),
    //   behaviors: [
    //     new charts.ChartTitle(APP_CHART_Y_AXIS_TITLE,
    //         titleStyleSpec: TextStyleSpec(
    //             fontSize:
    //                 Theme.of(context).textTheme.subtitle1.fontSize.toInt()),
    //         behaviorPosition: charts.BehaviorPosition.start,
    //         titleOutsideJustification:
    //             charts.OutsideJustification.middleDrawArea),
    //     new charts.ChartTitle(APP_CHART_X_AXIS_TITLE,
    //         titleStyleSpec: TextStyleSpec(
    //             fontSize:
    //                 Theme.of(context).textTheme.subtitle1.fontSize.toInt()),
    //         behaviorPosition: charts.BehaviorPosition.bottom,
    //         titleOutsideJustification:
    //             charts.OutsideJustification.middleDrawArea),
    //   ],
    // );
    return new Container();
  }

  // List<charts.Series> convertBmeDataToChartData(List<List<BmeData>> bmeData) {
  //   List<charts.Series<BmeData, int>> chartData = [];

  //   if (bmeData.length > 1) {
	//  //Plot old graph data
  //     for (int i = 0; i < bmeData.length - 1; i++) {
  //       chartData.add(
  //         new charts.Series<BmeData, int>(
  //           id: 'bmeChart_' + i.toString(),
  //           colorFn: (_, __) => Color.fromHex(code: AVOCADO_DARK_GREEN_W50_HEX),
  //           domainFn: (BmeData bmeData, _) => bmeData.gasIndex,
  //           measureFn: (BmeData bmeData, _) => bmeData.normalisedGasResistance,
  //           data: bmeData[i],
  //         ),
  //       );
  //     }
  //   }
  //   if (bmeData.length > 0) {
	// //Plot current graph data
  //     chartData.add(
  //       new charts.Series<BmeData, int>(
  //         id: 'bmeChart_' + (bmeData.length - 1).toString(),
  //         colorFn: (_, __) => Color.fromHex(code: AVOCADO_DARK_GREEN_HEX),
  //         domainFn: (BmeData bmeData, _) => bmeData.gasIndex,
  //         measureFn: (BmeData bmeData, _) => bmeData.normalisedGasResistance,
  //         data: bmeData[bmeData.length - 1],
  //       ),
  //     );
  //   }

  //   return chartData;
  // }

  void onSensorIdChanged() {
    print("Change of sensor notified from chart");
    _bme8xModel.clearData();
  }
}
