import 'dart:convert';

import 'package:eliveryday/Resturant/FoodCard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CartInfo {
  final String id;
  final List<Food> foodList;
  final String address;
  final LatLng delivCord;

  CartInfo(
      {required this.id,
      required this.foodList,
      required this.address,
      required this.delivCord});
  // All of them might not be initialised right now so they are in curly braces

  CartInfo.customFromJSON(Map<String, dynamic> data)
      : id = data['id'],
        address = data['address'],
        delivCord = LatLng(
          List.from(data['delivCord'])[0],
          List.from(data['delivCord'])[1],
        ),
        foodList = List.from(data['foodList'])
            .map(
              (foodInfo) => Food(
                foodItemName: foodInfo.substring(0, foodInfo.indexOf("?")),
                category: ["TEST"],
                resturantCord: LatLng(0, 1),
                quantity: int.parse(foodInfo.substring(
                    foodInfo.indexOf("?") + 1, foodInfo.indexOf("|"))),
                pricePerMeasure: double.parse(foodInfo.substring(
                    foodInfo.indexOf("|") + 1, foodInfo.indexOf("@"))),
              ),
            )
            .toList();

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'foodList': foodList
          .map((food) =>
              food.foodItemName +
              "?" +
              food.quantity.toString() +
              "|" +
              food.pricePerMeasure.toString() +
              "@")
          .toList(),
      'address': address,
      'delivCord': [delivCord.latitude, delivCord.longitude],
    };
  }
}
