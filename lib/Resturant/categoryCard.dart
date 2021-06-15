import 'package:eliveryday/Resturant/categoryPage.dart';
import 'package:eliveryday/Resturant/resturantInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final Color color;
  List<SingleResturantInfo> categoryResturants = [];
  CategoryCard({required this.category, required this.color});

  int placesFromCategory() {
    int count = 0;
    for (int i = 0; i < resturanAllInfo.length; i++) {
      for (int j = 0; j < resturanAllInfo[i].foodList.length; j++) {
        for (int k = 0;
            k < resturanAllInfo[i].foodList[j].category.length;
            k++) {
          if (resturanAllInfo[i].foodList[j].category[k] == category) {
            if (!categoryResturants.contains(resturanAllInfo[i])) {
              categoryResturants.add(resturanAllInfo[i]);
              count++;
            }
          }
        }
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.height * 0.21,
        child: Stack(
          children: [
            Positioned(
              top: 15,
              height: MediaQuery.of(context).size.height * 0.18,
              width: MediaQuery.of(context).size.height * 0.21,
              child: Card(
                color: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.height *
                            0.21 *
                            0.5 *
                            category.length /
                            6,
                        child: FittedBox(
                          child: Text(
                            category,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.height * 0.21 * 0.4,
                        child: FittedBox(
                          child: Text(
                            placesFromCategory().toString() + " Places",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: MediaQuery.of(context).size.width * 0.21 * 0.15,
              width: MediaQuery.of(context).size.width * 0.21 * 0.5,
              height: MediaQuery.of(context).size.width * 0.21 * 0.5,
              child: Card(
                  elevation: 15,
                  child: FittedBox(
                    child: Icon(
                      Icons.food_bank_outlined,
                      size: 300,
                      color: color,
                    ),
                  )),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryResturant(
              category: category, categoryResturantList: categoryResturants),
        ),
      ),
    );
  }
}
