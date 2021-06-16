import 'dart:math';

import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Home/base.dart';
import 'package:eliveryday/Home/home.dart';
import 'package:eliveryday/MapRoute.dart';
import 'package:eliveryday/Resturant/FoodCard.dart';
import 'package:eliveryday/customBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'resturantDisplayInfo.dart';

class ResturantView extends StatefulWidget {
  String resturantTitle;
  String image;
  String address;
  List<Food> foodItems;
  double rating;
  LatLng resturantCord;
  String category;
  late RouteInfo routeInfo;
  double time;

  final String imagesPath = "lib/Resturant/resturantImages/";
  ResturantView(
    this.foodItems,
    this.address,
    this.resturantCord,
    this.rating, {
    this.resturantTitle = "Resturant",
    this.image = "defaultResturant.jpg",
    this.time = -1,
    this.category = "All",
  });
  ResturantViewState createState() => ResturantViewState();
}

class ResturantViewState extends State<ResturantView> {
  late int categoryIndex;
  late List<int> range;
  late Map<String, List<Food>> categories;
  late List<Food> categoryFoodItems;

  @override
  void initState() {
    categoryIndex = 0;
    categoryFoodItems = widget.foodItems;
    range = getRange(
        widget.foodItems.map((food) => food.pricePerMeasure).toList(), 5);
    categories = {"All": widget.foodItems};
    categories.addAll(resturantCategories());
    categoryIndex = categories.keys.toList().indexOf(widget.category);
    categoryFoodItems = categories[widget.category] ?? widget.foodItems;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Positioned(
              //   top: MediaQuery.of(context).size.height * 0.1,
              //   height: MediaQuery.of(context).size.height * 0.2,
              //   width: MediaQuery.of(context).size.width,
              //   child: Card(
              //     elevation: 1,
              //     color: Theme.of(context).backgroundColor,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(10))),
              //     child: FittedBox(
              //       fit: BoxFit.fitWidth,
              //       child: photoAndTitle(widget.image, widget.resturantTitle,
              //           widget.address, widget.imagesPath, widget.rating),
              //     ),
              //   ),
              // ),

              Positioned(
                top: 0,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  widget.imagesPath +
                      widget.foodItems[widget.foodItems.length - 1].image,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              ),
              // Positioned(
              //   width: MediaQuery.of(context).size.width,
              //   top: MediaQuery.of(context).size.height * 0.33,
              //   child: itemBar(),
              // ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                left: 0,
                // If width is 0.9 remaining is 0.1 hence moving by 0.05 will Center it
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                child: Card(
                  color: Theme.of(context).backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  elevation: 10,
                  child: Stack(
                    children: [
                      Positioned(
                        top: MediaQuery.of(context).size.height * (0.28 - 0.25),
                        left: 10,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 100,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget.resturantTitle,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * (0.35 - 0.25),
                        width: MediaQuery.of(context).size.width * 0.98,
                        // THe scroll will only work is element has crossed the width it can overflow before that
                        height: 40,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              resturantDetailsNoButton(
                                icondata: Icons.star,
                                iconColor: Colors.yellow.shade600,
                                data: widget.rating.toString(),
                              ),
                              durationRange(),
                              resturantDetailsNoButton(
                                  icondata: Icons.shopping_cart,
                                  iconColor: Colors.grey.shade500,
                                  data: (range[0] != range[1])
                                      ? "\u{20B9} ${range[0]} - \u{20B9} ${range[1]} "
                                      : "\u{20B9} ${range[0]}")
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * (0.42 - 0.25),
                        width: MediaQuery.of(context).size.width * 0.98,
                        // THe scroll will only work is element has crossed the width it can overflow before that
                        height: 40,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  // resturantDetailsNoButton(
                                  //   icondata: Icons.star,
                                  //   iconColor: Colors.yellow.shade600,
                                  //   data: widget.rating.toString(),
                                  // ),

                                  // durationRange(),
                                  // resturantDetailsNoButton(
                                  //     icondata: Icons.shopping_cart,
                                  //     iconColor: Colors.grey.shade500,
                                  //     data: (range[0] != range[1])
                                  //         ? "\u{20B9} ${range[0]} - \u{20B9} ${range[1]} "
                                  //         : "\u{20B9} ${range[0]}")
                                  categories.keys
                                      .map((category) => categoryButton(
                                            category,
                                            categories.keys
                                                .toList()
                                                .indexOf(category),
                                          ))
                                      .toList()),
                        ),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.height *
                              (0.57 - 0.25),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: foodList(categoryFoodItems)),
                      Positioned(
                        top: MediaQuery.of(context).size.height * (0.5 - 0.25),
                        left: 10,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Menu",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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

  Widget resturantDetailsNoButton(
      {required IconData icondata,
      required Color iconColor,
      required String data}) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Chip(
        backgroundColor: Colors.grey[200],
        avatar: Icon(
          icondata,
          color: iconColor,
        ),
        label: Text(
          data,
          style: TextStyle(fontSize: 15),
        ),
        elevation: 5,
      ),
    );
  }

  Widget categoryButton(String category, int index) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: ChoiceChip(
        label: Text(
          category,
          style: TextStyle(fontSize: 15),
        ),
        labelStyle: TextStyle(color: Colors.white, fontSize: 20),
        selected: categoryIndex == index,
        selectedColor: Colors.teal[400],
        onSelected: (bool selected) {
          setState(() {
            categoryIndex = selected ? index : 0;
            categoryFoodItems = categories[category]!;
          });
        },
        backgroundColor: Colors.grey.shade500,
        elevation: 5,
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

  List<int> getRange(List<double> data, int interval) {
    List<int> x = [0, 0];
    double minPrice = data.reduce(min);
    double maxPrice = data.reduce(max);
    x[0] = minPrice % interval != 0
        ? (minPrice ~/ interval) * interval
        : minPrice.toInt();
    x[1] = maxPrice % interval != 0
        ? (maxPrice ~/ interval + 1) * interval
        : maxPrice.toInt();
    print(x);
    return x;
  }

  Map<String, List<Food>> resturantCategories() {
    Map<String, List<Food>> categories = {};
    for (int i = 0; i < widget.foodItems.length; i++) {
      for (int j = 0; j < widget.foodItems[i].category.length; j++) {
        categories.update(widget.foodItems[i].category[j],
            (value) => (value + [widget.foodItems[i]]),
            ifAbsent: () => [widget.foodItems[i]]);
      }
    }
    print(categories);
    return categories;
  }

  Widget durationRange() {
    widget.routeInfo =
        RouteInfo(initalPos: cartCord, finalPos: widget.resturantCord);
    widget.routeInfo.generateUri();
    return (widget.time == -1)
        ? (cartCord != LatLng(0, 0))
            ? FutureBuilder(
                future: widget.routeInfo.getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      widget.time = widget.routeInfo.duration();

                      double distance = widget.routeInfo.distance();

                      print([widget.time, distance]);
                      try {
                        if (widget.time != -1.0 && distance <= 3745000) {
                          // THe above number is the longest road distance
                          List<int> timeRange = getRange([widget.time / 60], 5);
                          return resturantDetailsNoButton(
                            icondata: Icons.access_time,
                            iconColor: Colors.grey.shade500,
                            data: "${timeRange[0]} - ${timeRange[1]} min",
                          );
                        }
                        widget.time = -1;
                        return resturantDetailsNoButton(
                          icondata: Icons.access_time,
                          iconColor: Colors.grey.shade500,
                          data: "Not Deliverable",
                        );
                      } catch (e) {
                        widget.time = -1;
                        return resturantDetailsNoButton(
                          icondata: Icons.access_time,
                          iconColor: Colors.grey.shade500,
                          data: "Not Deliverable",
                        );
                      }
                    }
                  }
                  return Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: CircularProgressIndicator());
                },
              )
            : resturantDetailsNoButton(
                icondata: Icons.access_time,
                iconColor: Colors.grey.shade500,
                data: "Choose Location",
              )
        : resturantDetailsNoButton(
            icondata: Icons.access_time,
            iconColor: Colors.grey.shade500,
            data: "${getRange([widget.time / 60], 5)[0]} - ${getRange([
                  widget.time / 60
                ], 5)[1]} min",
          );
  }
}
