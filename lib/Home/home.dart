import 'package:flutter/material.dart';

import '../Resturant/resturantCard.dart';
import '../Resturant/resturantInfo.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Stack(
        children: [
          resturantTitle(),
          resturantListDisplay(context),
        ],
      ),
    );
  }

  Widget resturantTitle() {
    return Positioned(
      // Title Resturants
      top: 10,
      left: 10,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: MediaQuery.of(context).size.width * 0.5,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            " Restaurants ",
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget resturantListDisplay(BuildContext context) {
    return Positioned(
      // List of resturant card
      top: MediaQuery.of(context).size.height * 0.1,
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: resturanAllInfo.map((resturant) {
            return ResturantCard(
              resturant[0],
              resturantTitle: resturant[1] == "" ? "Restaurant" : resturant[1],
              image: resturant[2] == "" ? "defaultResturant.jpg" : resturant[2],
            );
          }).toList(),
        ),
      ),
    );
  }
}
