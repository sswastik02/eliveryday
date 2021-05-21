import 'package:eliveryday/Resturant/resturantDisplayInfo.dart';

import 'package:flutter/material.dart';

import 'FoodCard.dart';
import 'singleResturantView.dart';

class ResturantCard extends StatelessWidget {
  String resturantTitle;
  String image;
  List<Food> foodItems;
  ResturantCard(this.foodItems,
      {this.resturantTitle = "Resturant", this.image = "defaultResturant.jpg"});
  final String imagesPath = "lib/Resturant/resturantImages/";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: photoAndTitle(image, resturantTitle, imagesPath),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              ResturantView resturantView = ResturantView(
                foodItems,
                resturantTitle: resturantTitle,
                image: image,
              );
              return resturantView;
            },
          ),
        );
      },
    );
  }
}
