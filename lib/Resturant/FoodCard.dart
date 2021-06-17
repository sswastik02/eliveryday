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
  final List<String> category;
  int quantity;
  Food({
    required this.foodItemName,
    this.veg = true,
    this.measureByPieces = true,
    this.image = "defaultFood.jpeg",
    this.pricePerMeasure = 10.0,
    this.description = "Coming soon ..........",
    this.quantity = 0,
    required this.category,
    required this.resturantCord,
  });
}

class FoodCardTemplate extends StatefulWidget {
  // This Widget Creates a Card with the following parameters
  Food foodData;
  final String imagesPath = "lib/Resturant/resturantImages/";
  State? state;
  FoodCardTemplate(this.foodData, {this.state});
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
      height: MediaQuery.of(context).size.height * 0.23,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0,
        color: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Stack(
          children: [
            // Food Image
            Positioned(
              top: MediaQuery.of(context).size.height * 0.02,
              left: 0,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.height * 0.18,
                    child: Image.asset(
                      widget.imagesPath + widget.foodData.image,
                      fit: BoxFit.fill,
                      // Aspect Ratio is not maintained
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              //NAME
              left: MediaQuery.of(context).size.width * 0.35,
              top: MediaQuery.of(context).size.height * 0.025,
              width: MediaQuery.of(context).size.width * 0.7,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.foodData.foodItemName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              // DESCRIPTION
              left: MediaQuery.of(context).size.width * 0.35,
              top: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.6,
              height: 41,
              // height is set so that it shows there is text below
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  widget.foodData.description,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            Positioned(
              //PRICE
              bottom: 13,
              left: MediaQuery.of(context).size.width * 0.35,
              width: MediaQuery.of(context).size.width * 0.28,
              child: Container(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: widget.foodData.measureByPieces
                      ? Text(
                          '\u{20B9} ${widget.foodData.pricePerMeasure} / Plate',
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        )
                      : Text(
                          '\u{20B9} ${widget.foodData.pricePerMeasure} / Bowl',
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              // BUTTON
              bottom: 5,
              width: MediaQuery.of(context).size.width * 0.3,
              right: 5,
              child: (widget.foodData.quantity == 0)
                  ? _buttonNoCount()
                  : _buttonCount(),
            ),
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
        side: BorderSide(color: Colors.black),
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
      color: Colors.white,
      disabledColor: Colors.grey,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3 * 1 / 5,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.black,
                size: 400,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3 * 0.455,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Add Item",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonCount() {
    return Container(
      height: 50,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: SizedBox(
                width: 25,
                height: 25,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  color: Colors.white,
                  child: Container(
                    child: Icon(
                      Icons.add,
                      size: 11,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  print(cartAllInfo.remove(widget.foodData));
                  // remove if exists
                  widget.foodData.quantity++;
                  // adding to cart
                  cartAllInfo.add(widget.foodData);

                  print(cartAllInfo.length);
                });
              },
            ),
            SizedBox(
              width: 7,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "${widget.foodData.quantity}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      height: 1),
                ),
              ),
            ),
            GestureDetector(
              child: SizedBox(
                width: 25,
                height: 25,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  color: Colors.white,
                  child: Container(
                    child: Icon(
                      Icons.remove,
                      size: 11,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  print(cartAllInfo.remove(widget.foodData));
                  // remove if exists
                  widget.foodData.quantity--;
                  // adding to cart
                  if (widget.foodData.quantity > 0) {
                    cartAllInfo.add(widget.foodData);
                  } else {
                    widget.state?.setState(() {});
                  }

                  print(cartAllInfo.length);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
