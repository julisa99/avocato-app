import 'package:avocato/data/bme_data.dart';
import 'package:avocato/utils/consts.dart';
import 'package:flutter/widgets.dart';

class BME68xModel extends ChangeNotifier {
  List<List<BmeData>> _bmeData = [];

  List<List<BmeData>> get bme68xData => _bmeData;

  void addBmeData(BmeData bmeData) {
    print("Add bme data called $bmeData");
    if (bmeData != null) {
      print("Adding bmeData : ${bmeData.gasIndex}");
      if (bmeData.gasIndex == 0 || _bmeData.length == 0) {
        if (_bmeData.length == APP_MAX_CHART_COUNT) {
          print(
              "Oldest line chart removed since the line charts count reached $APP_MAX_CHART_COUNT");
          _bmeData.removeAt(
              0); //Remove oldest line chart data when the number of line charts reach maximum limit.
        }
        List<BmeData> bmeOutputSet = [bmeData];
        //If condition avoids false positive notification by multiprovider
        if (!_bmeData.contains(bmeOutputSet)) {
          _bmeData.add(bmeOutputSet);
        }
      } else if (!_bmeData.elementAt(_bmeData.length - 1).contains(bmeData)) {
        //If condition avoids false positive notification by multiprovider
        _bmeData.elementAt(_bmeData.length - 1).add(bmeData);
      }
      notifyListeners();
    }
  }

  void clearData() {
    print("Clear bme data called");
    _bmeData.clear();
    notifyListeners();
  }
}
