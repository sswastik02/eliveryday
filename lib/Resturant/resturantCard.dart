import 'package:eliveryday/Resturant/resturantDisplayInfo.dart';

import 'package:flutter/material.dart';

import 'FoodCard.dart';
import 'singleResturantView.dart';

class ResturantCard extends StatelessWidget {
  final String resturantTitle;
  final String image;
  final List<Food> foodItems;
  ResturantCard(this.foodItems,
      {this.resturantTitle = "Resturant", this.image = "defaultResturant.jpg"});
  final String imagesPath = "lib/Resturant/resturantImages/";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.2,
        margin: EdgeInsets.only(bottom: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          elevation: 10,
          color: Theme.of(context).primaryColor,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: photoAndTitle(image, resturantTitle, imagesPath),
          ),
        ),
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
