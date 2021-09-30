import 'package:avocato/utils/bme688_profile.dart';

class BsecData {
  //{"bsec":[{"id":22,"signal":0,"accuracy":1},{"id":23,"signal":1,"accuracy":1},{"id":24,"signal":0,"accuracy":1},{"id":25,"signal":0,"accuracy":1}]}

  GasEstimate _detectedGasEstimate;

  BsecData.fromJson(Map<String, dynamic> json) {
    List<GasEstimate> tempData = [];
    for (int i = 0; i < json[TAG_BSEC].length; i++) {
      GasEstimate estimate = GasEstimate.fromJson(json[TAG_BSEC][i]);
      print("parsed : ${json[TAG_BSEC][i]}");
      tempData.add(estimate);
    }

    var _maxGasEstimate = tempData.first;
    tempData.forEach((element) => {
      print("comparing {$element.probability} against {$_maxGasEstimate.probability}"),
          if (element.probability > _maxGasEstimate.probability)
            _maxGasEstimate = element
        });
    _detectedGasEstimate = convert(_maxGasEstimate);
  }
  GasEstimate get detectedGasEstimate => _detectedGasEstimate;

  GasEstimate convert(GasEstimate rawData) {
    return GasEstimate((rawData.classId - 21), rawData.probability * 100,
        rawData.accuracy * 100);
  }
}

class GasEstimate {
  final int classId;
  final double probability;
  final double accuracy;

  GasEstimate(this.classId, this.probability, this.accuracy);

  GasEstimate.fromJson(Map<String, dynamic> json)
      : classId = json['id'],
        probability = json['signal'].toDouble(),
        accuracy = json['accuracy'].toDouble();

  Map<String, dynamic> toJson() => {
        'id': classId,
        'signal': probability,
        'accuracy': accuracy,
      };
}
