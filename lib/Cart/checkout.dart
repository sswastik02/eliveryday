import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:eliveryday/FireBase/firebaseCustomServices.dart';
import 'package:eliveryday/FireBase/styledbuttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Widget has been made to adjust to any device width

Widget checkoutPage(BuildContext context, FirebaseAuth auth) {
  FireStoreService fireStoreService = FireStoreService();
  TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 20);
  var total = cartAllInfo
      .map((food) => (food.quantity * food.pricePerMeasure))
      .toList()
      .reduce((value, element) => value + element);
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.3)),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.07,
            left: MediaQuery.of(context).size.width * 0.025,
            width: MediaQuery.of(context).size.width * 0.95,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text("Order Preview"),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.025,
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  children: cartAllInfo
                      .map(
                        (food) => Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(food.foodItemName.length > 12
                                      ? '${food.foodItemName.substring(0, 9)}...'
                                      : food.foodItemName),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "(${food.pricePerMeasure})  X  " +
                                        "${food.quantity}",
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.02,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "=",
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.18,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "${food.pricePerMeasure * food.quantity}",
                                    style: textStyle,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.72,
            width: MediaQuery.of(context).size.width * 0.95,
            left: MediaQuery.of(context).size.width * 0.025,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FittedBox(
                        fit: BoxFit.fitWidth, child: Text("Total  :")),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text("${total}"),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.82,
            child: styledButton(context, "Order Now", () async {
              var user = await auth.currentUser();
              if (cartAddress != '') {
                var now = DateTime.now();
                await fireStoreService.createCart(
                  CartInfo(
                    foodList: cartAllInfo,
                    id: user.uid + now.toString(),
                    address: cartAddress,
                  ),
                );
                print("Order Placed");
                Navigator.pop(context);
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        title: Text('Select a Location first'),
                      );
                    });
              }
            }),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.9,
            child: styledButton(context, "Go back", () {
              Navigator.pop(context);
            }, icon: Icons.keyboard_arrow_left),
          ),
        ],
      ),
    ),
  );
}
