import 'package:avocato/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabelTextField extends StatelessWidget {
  final labelText;
  final TextEditingController controller;

  LabelTextField({this.labelText, this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Theme(
          data: ThemeData(
            primaryColor: AVOCADO_DARK_GREEN,
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
              labelText: labelText,
            ),
          ),
        ),
      ),
    );
  }
}
