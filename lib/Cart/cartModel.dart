import 'dart:convert';

import 'package:eliveryday/Resturant/FoodCard.dart';

class CartInfo {
  final String id;
  final List<Food> foodList;
  final String address;

  CartInfo({
    this.id = '',
    required this.foodList,
    this.address = '',
  });
  // All of them might not be initialised right now so they are in curly braces

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'foodList': jsonEncode(foodList
          .map((food) => [food.foodItemName, food.quantity.toString()])
          .toList()),
      'address': address,
    };
  }
}
