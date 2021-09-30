import 'package:avocato/landing_page.dart';
import 'package:avocato/utils/consts.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'Bosch sans ms',
          primaryColor: Colors.white,
          buttonTheme: ButtonThemeData(
            minWidth: 200,
            height: 50,
          ),
          snackBarTheme: SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.white,
              contentTextStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.red,
              )),
          accentColor: AVOCADO_DARK_GREEN),
      home: Scaffold(
        body:  LandingPage(),
      ),
    );
  }


}
