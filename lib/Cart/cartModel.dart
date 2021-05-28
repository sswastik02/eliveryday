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

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'foodList': jsonEncode(foodList
          .map((food) => [food.foodItemName, food.quantity.toString()])
          .toList()),
      'address': address,
      'delivery coordinates': delivCord.toString(),
    };
  }
}
