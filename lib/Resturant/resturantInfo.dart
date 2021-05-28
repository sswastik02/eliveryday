import 'package:eliveryday/Resturant/FoodCard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List resturanAllInfo = [
  [
    [
      Food(
        foodItemName: "Chicken Biryani",
        description: "Traditional Chicken Biryani 6 pieces + Raita",
        veg: false,
        measureByPieces: false,
        pricePerMeasure: 100,
        image: "biryani.jpg",
        resturantCord: LatLng(12.875928629180564, 77.5959502532494),
      ),
      Food(
        foodItemName: "Indian Naan",
        description: "Puffed bread with butter about size of one hand",
        pricePerMeasure: 50,
        image: "naan.jpg",
        resturantCord: LatLng(12.875928629180564, 77.5959502532494),
      ),
    ],
    "The Taj Group of Hotels",
    "Taj.png",
  ],
  [
    [
      Food(
        foodItemName: "Cherry Crest Lobster",
        veg: false,
        pricePerMeasure: 1000,
        description:
            "A complete piece of Lobster of about 500g with Lemons in the side",
        image: "Lobster.jpg",
        resturantCord: LatLng(12.92114718024415, 77.59188347599004),
      )
    ],
    "PortSide Grill- Taste of the Sea",
    "Port.jpg"
  ],
  [
    [
      Food(
        foodItemName: "Butterfry Crumbed Prawns",
        veg: false,
        pricePerMeasure: 239,
        description: "6 pieces of Prawn fried in butter with chilli sauce",
        image: "prawnsBarbeque.png",
        resturantCord: LatLng(12.906688493148838, 77.59683048392178),
      ),
      Food(
        foodItemName: "Mutton Shami Kebab",
        veg: false,
        pricePerMeasure: 259,
        description: "6 pieces of Disk sized Kebabs hot and spicy",
        image: "muttonKabab.png",
        resturantCord: LatLng(12.906688493148838, 77.59683048392178),
      ),
    ],
    "Barbeque Nation",
    "barbeque.png"
  ],
  [
    [
      Food(
        foodItemName: "Kimchi Salad",
        pricePerMeasure: 110,
        description:
            "Korean dish which is made by fermenting cabbage, along with some spices.",
        image: "kimchiSalad.png",
        resturantCord: LatLng(12.861348605317888, 77.58991352995606),
      ),
      Food(
        foodItemName: "Panneer Pakoda",
        pricePerMeasure: 160,
        description:
            "6 peices of fried panneer nuggets along with chilli sauce",
        image: "panneerPak.png",
        resturantCord: LatLng(12.861348605317888, 77.58991352995606),
      ),
      Food(
        foodItemName: "Chicken Do Pyaza",
        veg: false,
        pricePerMeasure: 240,
        description: "10 pieces of chicken in a thick gravy with hint of onion",
        image: "doPyaza.png",
        resturantCord: LatLng(12.861348605317888, 77.58991352995606),
      ),
    ],
    "Blue Waters",
    "blueWaters.png"
  ],
  [
    [
      Food(
        foodItemName: "Cream of Chicken",
        veg: false,
        pricePerMeasure: 140,
        measureByPieces: false,
        description: "Small pieces of chicken submerged in hot cream like soup",
        image: "creamChicken.png",
        resturantCord: LatLng(12.89343136669974, 77.59856743862025),
      ),
      Food(
        foodItemName: "Chicken Kebab",
        veg: false,
        pricePerMeasure: 340,
        description:
            "12 pieces of chicken kebab served straight out of the grill",
        image: "chickenKebab.png",
        resturantCord: LatLng(12.89343136669974, 77.59856743862025),
      ),
    ],
    "Fattoush",
    "fattoush.png"
  ],
];
