import 'package:avocato/data/sensor_data.dart';
import 'package:flutter/material.dart';

const DEFAULT_MTU = 158;
const Max_Gas_Estimates_To_Remember = 5;

//Sensor Ids
const int SENSOR_ID_1 = 0;
const int SENSOR_ID_2 = 1;
const int SENSOR_ID_3 = 2;
const int SENSOR_ID_4 = 3;
const int SENSOR_ID_5 = 4;
const int SENSOR_ID_6 = 5;
const int SENSOR_ID_7 = 6;
const int SENSOR_ID_8 = 7;

const int TOTAL_SENSOR_COUNT = 8;

class Constants {
  static const List<SensorLabel> Sensors = [
    SensorLabel(
      labelIndex: SENSOR_ID_1,
      labelName: "Sensor 1",
    ),
    SensorLabel(
      labelIndex: SENSOR_ID_2,
      labelName: "Sensor 2",
    ),
    SensorLabel(
      labelIndex: SENSOR_ID_3,
      labelName: "Sensor 3",
    ),
    SensorLabel(
      labelIndex: SENSOR_ID_4,
      labelName: "Sensor 4",
    ),
    SensorLabel(
      labelIndex: SENSOR_ID_5,
      labelName: "Sensor 5",
    ),
    SensorLabel(
      labelIndex: SENSOR_ID_6,
      labelName: "Sensor 6",
    ),
    SensorLabel(
      labelIndex: SENSOR_ID_7,
      labelName: "Sensor 7",
    ),
    SensorLabel(
      labelIndex: SENSOR_ID_8,
      labelName: "Sensor 8",
    ),
  ];
}



//Labels
const int LABEL_ID_1 = 1;
const int LABEL_ID_2 = 2;
const int LABEL_ID_3 = 3;
const int LABEL_ID_4 = 4;

const String DEFAULT_LABEL_NAME_1 = "Label1";
const String DEFAULT_LABEL_NAME_2 = "Label2";
const String DEFAULT_LABEL_NAME_3 = "Label3";
const String DEFAULT_LABEL_NAME_4 = "Label4";

//Shared preference keys
const String PREF_CONNECTED_DEVICE = "connectedDevice";
const String PREF_LABEL = "label";
const String PREF_LABEL_1 = "label1";
const String PREF_LABEL_2 = "label2";
const String PREF_LABEL_3 = "label3";
const String PREF_LABEL_4 = "label4";

//Generic app constants
const APP_HEADER_DISPLAY_NAME = "avocato";
const APP_CHART_Y_AXIS_TITLE = "Normalized gas";
const APP_CHART_X_AXIS_TITLE = "Gas index";
const APP_MAX_CHART_COUNT = 50;
const APP_DEVICE_NAME_PREFIX = "avocato";

//App icons
const ICON_BLUETOOTH_LE = "assets/images/bluetooth-le.ico";
const ICON_DEMO = "assets/images/demo.ico";
const ICON_TESTING = "assets/images/testing.ico";
const ICON_ENVIRONMENT = "assets/images/environment.ico";
const ICON_LABEL_GROUND_TRUTH = "assets/images/label-edit.ico";
const ICON_SETTINGS = "assets/images/settings.ico";


//NotifiablePropertyNames
const PROPERTY_CURRENT_SENSOR = "currentSensor";

//App UI colors
const AVOCADO_DARK_GREEN_HEX = '#445500ff';
const AVOCADO_DARK_GREEN_W50_HEX = '#abc837ff';
const AVOCADO_DARK_GREEN =Color(0xff445500);
