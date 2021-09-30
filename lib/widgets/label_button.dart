import 'package:avocato/utils/consts.dart';
import 'package:flutter/material.dart';

class LabelButton extends StatelessWidget {
  final String labelName;
  final VoidCallback onPressed;
  final bool isSet;

  LabelButton({this.labelName, this.onPressed, this.isSet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(5),
      color: isSet ? AVOCADO_DARK_GREEN :  Color(0xffd2e295),
      height: 100,
      width: 100,
      child: FlatButton(
        child: Text(labelName,
        style: TextStyle(
          color: Colors.white,
          fontSize: Theme.of(context).textTheme.headline4.fontSize
        ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
