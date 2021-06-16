import 'package:eliveryday/Resturant/resturantCard.dart';
import 'package:eliveryday/Resturant/resturantInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryResturant extends StatelessWidget {
  List<SingleResturantInfo> categoryResturantList;
  String category;
  CategoryResturant(
      {required this.categoryResturantList, required this.category});
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Theme.of(context).backgroundColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: 10,
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
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.height * 0.75,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: categoryResturantList.map((resturant) {
                      return ResturantCard(
                        resturant.foodList,
                        resturant.address,
                        resturant.rating,
                        resturant.resturantCord,
                        resturantTitle: resturant.name,
                        image: resturant.image,
                        category: category,
                      );
                    }).toList(),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.05 *
                      category.length,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 300,
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
