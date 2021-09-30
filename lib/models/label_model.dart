import 'package:avocato/utils/consts.dart';
import 'package:avocato/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/label_data.dart';

class LabelModel with ChangeNotifier {
  List<LabelData> _labels = new List(4); //Makes a fixed length array
  List<LabelData> get labels => _labels;
  SharedPreferences sharedPreference;

  LabelModel(String connectedDeviceId) {
    _labels = [
      LabelData(DEFAULT_LABEL_NAME_1, LABEL_ID_1, false),
      LabelData(DEFAULT_LABEL_NAME_2, LABEL_ID_2, false),
      LabelData(DEFAULT_LABEL_NAME_3, LABEL_ID_3, false),
      LabelData(DEFAULT_LABEL_NAME_4, LABEL_ID_4, false),
    ];
    _initializeLabels(connectedDeviceId);
  }

  Future<void> _initializeLabels(String connectedDeviceId) async {
    sharedPreference = await SharedPreferences.getInstance();

    if (sharedPreference.getString(PREF_CONNECTED_DEVICE) ==
        connectedDeviceId) {
      print("last connected device detected. loading values");
      _labels[0].name = sharedPreference.getString(PREF_LABEL + LABEL_ID_1.toString()) ??
          DEFAULT_LABEL_NAME_1;
      _labels[1].name = sharedPreference.getString(PREF_LABEL + LABEL_ID_2.toString()) ??
          DEFAULT_LABEL_NAME_2;
      _labels[2].name = sharedPreference.getString(PREF_LABEL + LABEL_ID_3.toString()) ??
          DEFAULT_LABEL_NAME_3;
      _labels[3].name = sharedPreference.getString(PREF_LABEL + LABEL_ID_4.toString()) ??
          DEFAULT_LABEL_NAME_4;
    }


  }

  void updateReceivedLabel(int id) {
    for (int i = 0; i < _labels.length; i++) {
      _labels[i].isSet = _labels[i].id == id;
    }
    print("update get label called. Notifying listeners for id:($id)");
    notifyListeners();
  }

  void updateLabelName(int id, String newName) {
    print("Update label called for Label $id with name $newName");
    if (Validator.isValidLabelId(id)) {
      var labelToUpdate = _labels.firstWhere((element) => element.id == id);
      _saveLabelNameToMemory(id, newName);
      labelToUpdate.name = newName;
      notifyListeners();
    }
  }

  Future<void> _saveLabelNameToMemory(int id, String newName) async {
    await sharedPreference.setString(PREF_LABEL + id.toString(), newName);
  }

  String getLabelName(int id) {
    if (Validator.isValidLabelId(id)) {
      print("Label name retrieved");
      return _labels.firstWhere((element) => element.id == id).name;
    } else {
      print("Invalid id requested for label name $id");
    }
    return "---";
  }
}
