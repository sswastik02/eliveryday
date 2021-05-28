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
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 10,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: photoAndTitle(
                        widget.image, widget.resturantTitle, widget.imagesPath),
                  ),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height * 0.33,
                child: itemBar(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.41,
                left: MediaQuery.of(context).size.width * 0.05,
                // If width is 0.9 remaining is 0.1 hence moving by 0.05 will Center it
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.55,
                child: foodList(widget.foodItems),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: MaterialButton(
                  height: 50,
                  minWidth: 50,
                  shape: CircleBorder(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
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
