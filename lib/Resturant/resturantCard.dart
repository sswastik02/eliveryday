import 'package:eliveryday/Resturant/resturantDisplayInfo.dart';

import 'package:flutter/material.dart';

import 'FoodCard.dart';
import 'singleResturantView.dart';

class ResturantCard extends StatelessWidget {
  final String resturantTitle;
  final String image;
  final List<Food> foodItems;
  final String address;
  final double rating;
  ResturantCard(this.foodItems, this.address, this.rating,
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
          color: Theme.of(context).backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          elevation: 0,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: photoAndTitle(
                image, resturantTitle, address, imagesPath, rating),
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
                address,
                rating,
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
