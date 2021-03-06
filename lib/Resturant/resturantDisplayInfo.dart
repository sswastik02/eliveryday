import 'package:eliveryday/FireBase/firebaseCustomServices.dart';
import 'package:flutter/material.dart';

import 'FoodCard.dart';

Widget photoAndTitle(BuildContext context, String photo, String title,
    String address, String imagesPath, double rating) {
  FireStoreService fireStoreService = FireStoreService();
  return Row(
    children: [
      SizedBox(
        width: 10,
      ),
      ClipRRect(
        // Image
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8 * 0.3,
          height: MediaQuery.of(context).size.width * 0.8 * 0.3,
          // child: Image.asset(
          //   imagesPath + photo,
          //   fit: BoxFit.fill,
          // ),
          child: FutureBuilder<String>(
            future: fireStoreService.getRestuarantImage(photo),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.network(
                  snapshot.data!,
                  fit: BoxFit.fill,
                );
              }
              return Image.asset(imagesPath + 'defaultResturant.jpg');
            },
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      SizedBox(
        width: 10,
      ),
      Container(
        // Scrollable Resturant Name Location and Rating
        width: MediaQuery.of(context).size.width * 0.8 * 0.7,
        height: 100,
        //alignment: Alignment.center, Error causing in space
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow.shade600,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    rating.toString(),
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    address,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget foodList(List<Food> foods, {bool scroll = true, State? state}) {
  Widget list = Column(
      children: foods
          .map((foodData) => FoodCardTemplate(
                foodData,
                state: state,
              ))
          .toList());
  return scroll
      ? SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: list,
        )
      : list;
}
