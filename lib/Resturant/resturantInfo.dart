import 'package:eliveryday/Resturant/FoodCard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleResturantInfo {
  final List<Food> foodList;
  final String name;
  final String image;
  final LatLng resturantCord;
  final String address;
  final double rating;

  SingleResturantInfo(
      {required this.foodList,
      required this.name,
      required this.image,
      required this.resturantCord,
      required this.address,
      required this.rating});

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "image": image,
      "resturantCord": [resturantCord.latitude, resturantCord.longitude],
      "address": address,
      "rating": rating,
      "foodlist": List<dynamic>.from(foodList.map((food) => food.toJSON())),
    };
  }

  SingleResturantInfo.fromJSON(Map<String, dynamic> data)
      : name = data['name'],
        image = data['image'],
        resturantCord =
            LatLng(data['resturantCord'][0], data['resturantCord'][1]),
        address = data['address'],
        rating = data['rating'],
        foodList = List<Food>.from(data["foodlist"]
            .map((x) => Food.fromJSON(Map<String, dynamic>.from(x))));
}

List<SingleResturantInfo> resturanAllInfo = [
  SingleResturantInfo(
    foodList: [
      Food(
        foodItemName: "Chicken Biryani",
        description: "Traditional Chicken Biryani 6 pieces + Raita",
        veg: false,
        measureByPieces: false,
        pricePerMeasure: 100,
        image: "biryani.jpg",
        category: ["Indian"],
        resturantCord: LatLng(12.875928629180564, 77.5959502532494),
      ),
      Food(
        foodItemName: "Indian Naan",
        description: "Puffed bread with butter about size of one hand",
        pricePerMeasure: 50,
        image: "naan.jpg",
        category: ["Indian", "Bread"],
        resturantCord: LatLng(12.875928629180564, 77.5959502532494),
      ),
    ],
    name: "The Taj Group of Hotels",
    image: "Taj.png",
    resturantCord: LatLng(12.875928629180564, 77.5959502532494),
    address: "Hulimavu, BLR",
    rating: 4.8,
  ),
  SingleResturantInfo(
      foodList: [
        Food(
          foodItemName: "Cherry Crest Lobster",
          veg: false,
          pricePerMeasure: 1000,
          description:
              "A complete piece of Lobster of about 500g with Lemons in the side",
          image: "Lobster.jpg",
          category: ["Seafood"],
          resturantCord: LatLng(12.92114718024415, 77.59188347599004),
        )
      ],
      name: "PortSide Grill- Taste of the Sea",
      image: "Port.jpg",
      resturantCord: LatLng(12.92114718024415, 77.59188347599004),
      address: "Gottigere, BLR",
      rating: 4.5),
  SingleResturantInfo(
      foodList: [
        Food(
          foodItemName: "Butterfry Crumbed Prawns",
          veg: false,
          pricePerMeasure: 239,
          description: "6 pieces of Prawn fried in butter with chilli sauce",
          image: "prawnsBarbeque.png",
          category: ["Seafood"],
          resturantCord: LatLng(12.906688493148838, 77.59683048392178),
        ),
        Food(
          foodItemName: "Mutton Shami Kebab",
          veg: false,
          pricePerMeasure: 259,
          description: "6 pieces of Disk sized Kebabs hot and spicy",
          image: "muttonKabab.png",
          category: ["Indian", "Kebab"],
          resturantCord: LatLng(12.906688493148838, 77.59683048392178),
        ),
      ],
      name: "Barbeque Nation",
      image: "barbeque.png",
      resturantCord: LatLng(12.906688493148838, 77.59683048392178),
      address: "Arekere, BLR",
      rating: 4.2),
  SingleResturantInfo(
      foodList: [
        Food(
          foodItemName: "Kimchi Salad",
          pricePerMeasure: 110,
          description:
              "Korean dish which is made by fermenting cabbage, along with some spices.",
          image: "kimchiSalad.png",
          category: ["Veggies", "Healthy"],
          resturantCord: LatLng(12.861348605317888, 77.58991352995606),
        ),
        Food(
          foodItemName: "Panneer Pakoda",
          pricePerMeasure: 160,
          description:
              "6 peices of fried panneer nuggets along with chilli sauce",
          image: "panneerPak.png",
          category: ["Veggies", "Indian"],
          resturantCord: LatLng(12.861348605317888, 77.58991352995606),
        ),
        Food(
          foodItemName: "Chicken Do Pyaza",
          veg: false,
          pricePerMeasure: 240,
          description:
              "10 pieces of chicken in a thick gravy with hint of onion",
          image: "doPyaza.png",
          category: ["Indian"],
          resturantCord: LatLng(12.861348605317888, 77.58991352995606),
        ),
      ],
      name: "Blue Waters",
      image: "blueWaters.png",
      resturantCord: LatLng(12.861348605317888, 77.58991352995606),
      address: "Jayanagar, BLR",
      rating: 4.8),
  SingleResturantInfo(
      foodList: [
        Food(
          foodItemName: "Cream of Chicken",
          veg: false,
          pricePerMeasure: 140,
          measureByPieces: false,
          description:
              "Small pieces of chicken submerged in hot cream like soup",
          image: "creamChicken.png",
          category: ["Indian", "Soup"],
          resturantCord: LatLng(12.89343136669974, 77.59856743862025),
        ),
        Food(
          foodItemName: "Chicken Kebab",
          veg: false,
          pricePerMeasure: 340,
          description:
              "12 pieces of chicken kebab served straight out of the grill",
          image: "chickenKebab.png",
          category: ["Indian", "Kebab"],
          resturantCord: LatLng(12.89343136669974, 77.59856743862025),
        ),
      ],
      name: "Fattoush",
      image: "fattoush.png",
      resturantCord: LatLng(12.89343136669974, 77.59856743862025),
      address: "JP Nagar, BLR",
      rating: 4.9),
];

List<SingleResturantInfo> resturantDownloadedInfo = [];

Map<String, IconData> foodCategories = {
  "Indian": FontAwesomeIcons.rupeeSign,
  "Kebab": FontAwesomeIcons.drumstickBite,
  "Soup": FontAwesomeIcons.hotTub,
  "Veggies": FontAwesomeIcons.carrot,
  "Healthy": FontAwesomeIcons.walking,
  "Seafood": FontAwesomeIcons.fish,
  "Bread": FontAwesomeIcons.breadSlice,
};
