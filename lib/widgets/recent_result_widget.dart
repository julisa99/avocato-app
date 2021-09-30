import 'package:avocato/data/bsec_data.dart';
import 'package:avocato/widgets/gas_result_widget_base.dart';
import 'package:avocato/utils/consts.dart';
import 'package:flutter/material.dart';

class RecentResultWidget extends GasResultWidgetBase {
  RecentResultWidget({BuildContext context, BsecData gasEstimate})
      : super(
          gasEstimate: gasEstimate,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
          backgroundColor: AVOCADO_DARK_GREEN,
          probabilityStyle: Theme.of(context).textTheme.caption,
          minRadius: 30,
          noValueIndicator: Text(
            "..."
          ),
        );
}
