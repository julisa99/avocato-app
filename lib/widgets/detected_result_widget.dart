import 'package:avocato/data/bsec_data.dart';
import 'package:avocato/widgets/gas_result_widget_base.dart';
import 'package:flutter/material.dart';

class DetectedResultWidget extends GasResultWidgetBase {
  DetectedResultWidget({BuildContext context, BsecData gasEstimate})
      : super(
          gasEstimate: gasEstimate,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
          probabilityStyle: Theme.of(context).textTheme.caption,
          minRadius: 50,
      noValueIndicator: SizedBox(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        height: 20,
        width: 20,
      ),
        );
}
