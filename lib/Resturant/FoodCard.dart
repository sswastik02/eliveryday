import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Food {
  final String foodItemName;
  final bool measureByPieces;
  final double pricePerMeasure;
  final String image;
  final String description;
  final bool veg;
  final LatLng resturantCord;
  int quantity;
  Food({
    this.foodItemName = "Unknown",
    this.veg = true,
    this.measureByPieces = true,
    this.image = "defaultFood.jpeg",
    this.pricePerMeasure = 10.0,
    this.description = "Coming soon ..........",
    this.quantity = 0,
    required this.resturantCord,
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
      margin: EdgeInsets.only(top: 5, bottom: 5),
      height: 320,
      width: MediaQuery.of(context).size.width * 0.92,
      child: Card(
        elevation: 5,
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Stack(
          children: [
            // Food Image
            Positioned(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.asset(
                  widget.imagesPath + widget.foodData.image,
                  fit: BoxFit.fill,
                  // Aspect Ratio is maintained
                ),
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
              bottom: 13,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.white),
                ),
                child: widget.foodData.measureByPieces
                    ? Text(
                        '\u{20B9} ${widget.foodData.pricePerMeasure} / Plate',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        '\u{20B9} ${widget.foodData.pricePerMeasure} / Bowl',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Positioned(
              // BUTTON
              bottom: 5,
              right: 5,
              child: (widget.foodData.quantity == 0)
                  ? _buttonNoCount()
                  : _buttonCount(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonNoCount() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        side: BorderSide(color: Colors.white),
      ),
      onPressed: (widget.foodData.foodItemName == "Unknown" ||
              (cartAllInfo.length != 0
                  ? cartAllInfo[0].resturantCord !=
                      widget.foodData.resturantCord
                  : false))
          // this line is to prevent buying from multiple restaurants
          // equiv: if food name is Unknown or (cart is not empty and
          //first element does not match cord of current food card)
          // As the cart starts from zero elements this will work
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
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buttonCount() {
    return Container(
      width: 125,
      height: 50,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
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
              child: Container(
                child: Icon(
                  Icons.remove,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              "${widget.foodData.quantity}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
            MaterialButton(
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
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
              child: Container(
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
