import 'package:avocato/utils/consts.dart';

const String MAIN_SERVICE_ID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
const String WRITE_CHARACTERISTIC_ID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
const String NOTIFICATION_CHARACTERISTIC_ID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
const String All_OUTPUT_ID = "22 23 24 25";
const int Default_data_rate = 2;
const int Default_sensor_Id = SENSOR_ID_1;



//JSon tag names
const TAG_BME68X = "bme68x";
const TAG_BSEC = "bsec";

const TAG_GAS_INDEX = 'gas_index';
const TAG_GAS_RESISTANCE = 'gas_resistance';

//Error codes
enum ErrorCodes {
  CMD_VALID,
  CMD_INVALID,
  CONTROLLER_QUEUE_FULL,
  LABEL_INVALID,
  BSEC_SELECTED_SENSOR_INVALID,
  BSEC_CONFIG_MISSING,
  BSEC_INIT_ERROR,
  BSEC_SET_CONFIG_ERROR,
  BSEC_UPDATE_SUBSCRIPTION_ERROR,
  BSEC_RUN_ERROR,
}
