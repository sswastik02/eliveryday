import 'package:flutter/material.dart';

class Food {
  final String foodItemName;
  final bool measureByPieces;
  final double pricePerMeasure;
  final String image;
  final String description;
  final bool veg;
  Food({
    this.foodItemName = "Unknown",
    this.veg = true,
    this.measureByPieces = true,
    this.image = "defaultFood.jpeg",
    this.pricePerMeasure = 10.0,
    this.description = "Coming soon ..........",
  });
}

class FoodCardTemplate extends StatelessWidget {
  // This Widget Creates a Card with the following parameters
  Food foodData;
  final String imagesPath = "lib/Resturant/resturantImages/";

  FoodCardTemplate(this.foodData);

  Widget vegOrNonVeg({veg = true}) {
    var color;
    if (veg == true) {
      color = Colors.green;
    } else {
      color = Colors.red;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.crop_square_sharp,
          color: color,
          size: 36,
        ),
        Icon(Icons.circle, color: color, size: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.brown,
        ),
      ),
      margin: EdgeInsets.only(bottom: 10),
      height: 300,
      child: Stack(
        children: [
          // Food Image
          Image.asset(
            imagesPath + foodData.image,
            height: 250,
            // Aspect Ratio is maintained
          ),
          Positioned(
            left: 20,
            top: 30,
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                foodData.foodItemName,
                style: TextStyle(
                    backgroundColor: Colors.amber,
                    color: Colors.red.shade900,
                    fontSize: 20,
                    fontFamily: "Times New Roman",
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 20,
            width: MediaQuery.of(context).size.width * 0.7,
            height: 80,
            // height is set so that it shows there is text below
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                foodData.description,
                style: TextStyle(
                  backgroundColor: Colors.black,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Times New Roman",
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 10,
            child: vegOrNonVeg(veg: foodData.veg),
          ),
          Positioned(
            top: 260,
            left: 10,
            child: foodData.measureByPieces
                ? Text(
                    '\u{20B9} ${foodData.pricePerMeasure} / Piece',
                    style:
                        TextStyle(fontFamily: "Times New Roman", fontSize: 15),
                  )
                : Text('\u{20B9} ${foodData.pricePerMeasure} / Bowl'),
          ),
        ],
      ),
    );
  }
}
