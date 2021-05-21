import 'package:eliveryday/Resturant/FoodCard.dart';
import 'package:flutter/material.dart';
import 'resturantDisplayInfo.dart';

class ResturantView extends StatefulWidget {
  String resturantTitle;
  String image;
  List<Food> foodItems;
  final String imagesPath = "lib/Resturant/resturantImages/";
  ResturantView(this.foodItems,
      {this.resturantTitle = "Resturant", this.image = "defaultResturant.jpg"});
  ResturantViewState createState() => ResturantViewState();
}

class ResturantViewState extends State<ResturantView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.resturantTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.1),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              child: photoAndTitle(
                  widget.image, widget.resturantTitle, widget.imagesPath),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              top: 150,
              child: itemBar(),
            ),
            Positioned(
              top: 200,
              left: MediaQuery.of(context).size.width * 0.05,
              // If width is 0.9 remaining is 0.1 hence moving by 0.05 will Center it
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.6,
              child: foodList(widget.foodItems),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.brown),
          top: BorderSide(color: Colors.brown),
        ),
      ),
      child: Text(
        "Items",
        style: TextStyle(color: Colors.brown, fontSize: 25),
        textAlign: TextAlign.center,
      ),
    );
  }
}
