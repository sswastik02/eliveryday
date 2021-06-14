import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Center(
        child: FittedBox(
          child: Icon(
            Icons.local_dining_sharp,
            size: 400,
          ),
        ),
      ),
    ));
  }
}
