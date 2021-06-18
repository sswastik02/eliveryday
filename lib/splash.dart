import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "lib/Resturant/resturantImages/splashBackGround.png",
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: 25,
            width: 50,
            height: 50,
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: CircularProgressIndicator(),
          )
        ],
      ),
    ));
  }
}
