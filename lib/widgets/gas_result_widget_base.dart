import 'package:avocato/data/bsec_data.dart';
import 'package:avocato/models/label_model.dart';
import 'package:avocato/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GasResultWidgetBase extends StatelessWidget {
  final BsecData gasEstimate;
  final TextStyle labelStyle;
  final TextStyle probabilityStyle;
  final Color backgroundColor;
  final double minRadius;
  final Widget noValueIndicator;

  GasResultWidgetBase({
    @required this.gasEstimate,
    @required this.labelStyle,
    @required this.probabilityStyle,
    this.backgroundColor = Colors.lightGreen,
    @required this.minRadius,
    @required this.noValueIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final labelModel = Provider.of<LabelModel>(context);
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AVOCADO_DARK_GREEN,
          child: (gasEstimate != null)
              ? Text(
                  labelModel.getLabelName(gasEstimate.detectedGasEstimate.classId),
                  style: labelStyle,
                )
              : noValueIndicator,
          minRadius: minRadius,
        ),
        Text(
          (gasEstimate != null)
              ? "${gasEstimate.detectedGasEstimate.probability.round()}%"
              : "",
          style: probabilityStyle,
        ),
      ],
    );
  }
}
