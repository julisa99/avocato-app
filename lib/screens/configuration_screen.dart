import 'package:avocato/models/bme688_bloc.dart';
import 'package:avocato/models/label_model.dart';
import 'package:avocato/data/sensor_data.dart';
import 'package:avocato/utils/consts.dart';
import 'package:avocato/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConfigurationScreen extends StatefulWidget {
  final Bme688Bloc bloc;
  final LabelModel labelModel;

  ConfigurationScreen({Key key, this.bloc, this.labelModel}) : super(key: key);

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  LabelModel labelController;
  final label1Controller = TextEditingController();
  final label2Controller = TextEditingController();
  final label3Controller = TextEditingController();
  final label4Controller = TextEditingController();

  List<DropdownMenuItem<SensorLabel>> sensorDropDownItems;
  SensorLabel _selectedSensor;
  @override
  void initState() {
    sensorDropDownItems = _buildDropDownMenuItems();

    _selectedSensor = Constants.Sensors[widget.bloc.currentSensor.labelIndex];
    super.initState();
  }

  @override
  void dispose() {
    label1Controller.dispose();
    label2Controller.dispose();
    label3Controller.dispose();
    label4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    labelController = widget.labelModel;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Configuration"),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: _buildContents(context),
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Column(
      children: [
        _buildSensorControls(context),
        SizedBox(
          height: 50,
        ),
        _buildLabelControls(context),
        SizedBox(
          height: 80,
        ),
        SizedBox(
          width: 150,
          height: 50,
          child: RaisedButton(
            color: AVOCADO_DARK_GREEN,
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.normal
              ),
            ),
            onPressed: _onsSave,
          ),
        )
      ],
    );
  }

  Widget _buildSensorControls(BuildContext context) {
    return Row(
      children: [
        Text(
          "Sensor:",
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          width: 20,
        ),
        DropdownButton(
          items: sensorDropDownItems,
          value: _selectedSensor,
          onChanged: _onSensorSelectionChanged,
        ),
      ],
    );
  }

  Widget _buildLabelControls(BuildContext context) {
    _loadLabelNames();
    return Column(
      children: [
        Row(
          children: [
            LabelTextField(labelText: "Label 1", controller: label1Controller),
            LabelTextField(labelText: "Label 2", controller: label2Controller),
          ],
        ),
        Row(
          children: [
            LabelTextField(labelText: "Label 3", controller: label3Controller),
            LabelTextField(labelText: "Label 4", controller: label4Controller),
          ],
        ),
      ],
    );
  }

  void _loadLabelNames() {
    label1Controller.text =labelController.labels[0].name;
    label2Controller.text =labelController.labels[1].name;
    label3Controller.text =labelController.labels[2].name;
    label4Controller.text =labelController.labels[3].name;
  }

  List<DropdownMenuItem<SensorLabel>> _buildDropDownMenuItems() {
    final items = List<DropdownMenuItem<SensorLabel>>();
    for (SensorLabel sensor in Constants.Sensors) {
      items.add(DropdownMenuItem(
        value: sensor,
        child: Text(
          sensor.labelName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ));
    }
    return items;
  }

  void _onSensorSelectionChanged(SensorLabel value) {
    setState(() {
      print("updated to new sensor id : ${value.labelName}");
      _selectedSensor = value;
    });
  }

  void _onsSave() {


    //Save labels
    if(label1Controller.text.isNotEmpty) {
      labelController.updateLabelName(LABEL_ID_1, label1Controller.text);
    }
    if(label2Controller.text.isNotEmpty) {
    labelController.updateLabelName(LABEL_ID_2, label2Controller.text);
    }
    if(label3Controller.text.isNotEmpty) {
    labelController.updateLabelName(LABEL_ID_3, label3Controller.text);
    }
    if(label4Controller.text.isNotEmpty) {
      labelController.updateLabelName(LABEL_ID_4, label4Controller.text);
    }

    //Save new sensor
    widget.bloc.updateSensor(_selectedSensor).then((value) => Navigator.of(context).pop());
  }
}
