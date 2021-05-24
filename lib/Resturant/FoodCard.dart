import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:flutter/material.dart';

class Food {
  final String foodItemName;
  final bool measureByPieces;
  final double pricePerMeasure;
  final String image;
  final String description;
  final bool veg;
  int quantity;
  Food({
    this.foodItemName = "Unknown",
    this.veg = true,
    this.measureByPieces = true,
    this.image = "defaultFood.jpeg",
    this.pricePerMeasure = 10.0,
    this.description = "Coming soon ..........",
    this.quantity = 0,
  });
}

class FoodCardTemplate extends StatefulWidget {
  // This Widget Creates a Card with the following parameters
  Food foodData;
  final String imagesPath = "lib/Resturant/resturantImages/";

  FoodCardTemplate(this.foodData);
  @override
  FoodCardTemplateState createState() => FoodCardTemplateState();
}

class FoodCardTemplateState extends State<FoodCardTemplate> {
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
      margin: EdgeInsets.only(top: 5, bottom: 5),
      height: 300,
      width: MediaQuery.of(context).size.width * 0.92,
      child: Stack(
        children: [
          // Food Image
          Positioned(
            top: 5,
            left: MediaQuery.of(context).size.width * (0.92 - 0.9) / 2,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Image.asset(
              widget.imagesPath + widget.foodData.image,
              fit: BoxFit.fitWidth,
              // Aspect Ratio is maintained
            ),
          ),
          Positioned(
            //NAME
            left: 20,
            top: 30,
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.foodData.foodItemName,
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
            // DESCRIPTION
            top: 70,
            left: 20,
            width: MediaQuery.of(context).size.width * 0.7,
            height: 80,
            // height is set so that it shows there is text below
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                widget.foodData.description,
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
            //VEGNONVEG
            top: 5,
            right: 10,
            child: vegOrNonVeg(veg: widget.foodData.veg),
          ),
          Positioned(
            //PRICE
            bottom: 15,
            left: 10,
            child: widget.foodData.measureByPieces
                ? Text(
                    '\u{20B9} ${widget.foodData.pricePerMeasure} / Piece',
                    style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    '\u{20B9} ${widget.foodData.pricePerMeasure} / Bowl',
                    style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          Positioned(
            // BUTTON
            bottom: 1,
            right: 5,
            child: (widget.foodData.quantity == 0)
                ? _buttonNoCount()
                : _buttonCount(),
          )
        ],
      ),
    );
  }

  Widget _buttonNoCount() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      onPressed: (widget.foodData.foodItemName == "Unknown")
          ? null
          : () {
              setState(() {
                print(cartAllInfo.remove(widget.foodData));
                // remove if exists
                widget.foodData.quantity++;
                // adding to cart
                cartAllInfo.add(widget.foodData);

                print(cartAllInfo.length);
              });
            },
      color: Theme.of(context).primaryColor,
      disabledColor: Colors.grey,
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Add Item",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonCount() {
    return Container(
      child: Row(
        children: [
          MaterialButton(
            shape: CircleBorder(),
            minWidth: 15,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                print(cartAllInfo.remove(widget.foodData));
                // remove if exists
                widget.foodData.quantity--;
                // adding to cart
                if (widget.foodData.quantity > 0) {
                  cartAllInfo.add(widget.foodData);
                }

                print(cartAllInfo.length);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.remove,
                size: 20,
              ),
            ),
          ),
          Text(
            "${widget.foodData.quantity}",
            style: TextStyle(fontSize: 20),
          ),
          MaterialButton(
            shape: CircleBorder(),
            color: Theme.of(context).primaryColor,
            minWidth: 15,
            onPressed: () {
              setState(() {
                print(cartAllInfo.remove(widget.foodData));
                // remove if exists
                widget.foodData.quantity++;
                // adding to cart
                cartAllInfo.add(widget.foodData);

                print(cartAllInfo.length);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
