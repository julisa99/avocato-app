import 'package:avocato/utils/bme688_profile.dart';
import 'package:avocato/utils/normalization_helper.dart';

class BmeData {
  //{"bme68x":{"pressure":90709.35,"humidity":33.5597,"temperature":45.59388,"gas_resistance":260891.7,"gas_index":9}}
  final double normalisedGasResistance;
  final int gasIndex;

  BmeData(this.normalisedGasResistance, this.gasIndex);

  BmeData.fromJson(Map<String, dynamic> json)
      : normalisedGasResistance =  NormalizationHelper.getNormalizedGas(json[TAG_BME68X][TAG_GAS_RESISTANCE].toDouble()),
        gasIndex = json[TAG_BME68X][TAG_GAS_INDEX];

  Map<String, dynamic> toJson() =>
      {
        TAG_GAS_RESISTANCE: normalisedGasResistance,
        TAG_GAS_INDEX: gasIndex,
      };
}
