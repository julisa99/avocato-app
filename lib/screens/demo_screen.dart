import 'package:avocato/widgets/line_chart_with_dots.dart';
import 'package:avocato/widgets/recent_gas_results.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          RecentGasResults(),
        ],
      ),
    );
  }
}
