import 'package:eliveryday/Resturant/categoryCard.dart';
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
          categoryListDisplay(),
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

  Widget categoryListDisplay() {
    Map<int, Color> categoryColor = {
      0: Colors.purple.shade100,
      1: Colors.pink.shade100,
      2: Colors.green.shade100,
      3: Colors.blue.shade100,
      4: Colors.yellow.shade100,
    };
    int i = 0;
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.01,
      left: 10,
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.95,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: foodCategories.map((category) {
          i = (i + 1) % 5;
          return CategoryCard(
            category: category,
            color: categoryColor[i]!,
          );
        }).toList()),
      ),
    );
  }

  Widget resturantListDisplay(BuildContext context) {
    return Positioned(
      // List of resturant card
      top: MediaQuery.of(context).size.height * 0.3,
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: resturanAllInfo.map((resturant) {
            return ResturantCard(
              resturant.foodList,
              resturant.address,
              resturant.rating,
              resturantTitle: resturant.name,
              image: resturant.image,
            );
          }).toList(),
        ),
      ),
    );
  }
}
