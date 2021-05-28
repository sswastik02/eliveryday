import 'package:flutter/material.dart';

import 'FoodCard.dart';

Widget photoAndTitle(String photo, String title, String imagesPath) {
  return Row(
    children: [
      SizedBox(
        width: 10,
      ),
      ClipRRect(
        // Image
        child: Image.asset(
          imagesPath + photo,
          width: 100,
          height: 100,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      SizedBox(
        width: 10,
      ),
      Container(
        // Scrollable Resturant Name
        width: 230,
        height: 100,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget foodList(List<Food> foods) {
  return SingleChildScrollView(
    padding: EdgeInsets.only(bottom: 20),
    child: Column(
        children: foods.map((foodData) => FoodCardTemplate(foodData)).toList()),
  );
}
