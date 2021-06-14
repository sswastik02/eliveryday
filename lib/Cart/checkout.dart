import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:eliveryday/FireBase/firebaseCustomServices.dart';
import 'package:eliveryday/FireBase/styledbuttons.dart';
import 'package:eliveryday/Home/base.dart';
import 'package:eliveryday/Maps/maps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Widget has been made to adjust to any device width

class CheckoutPage extends StatefulWidget {
  FireStoreService fireStoreService = FireStoreService();
  late FirebaseAuth auth;
  CheckoutPage(this.auth);
  TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 20);
  double total = cartAllInfo
      .map((food) => (food.quantity * food.pricePerMeasure))
      .toList()
      .reduce((value, element) => value + element);
  State<StatefulWidget> createState() => CheckOutPageState();
}

class CheckOutPageState extends State<CheckoutPage> {
  bool loading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: Stack(
          children: [
            Positioned(
              // Title
              top: MediaQuery.of(context).size.height * 0.07,
              left: MediaQuery.of(context).size.width * 0.025,
              width: MediaQuery.of(context).size.width * 0.95,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text("Order Preview"),
              ),
            ),
            Positioned(
              // Order List
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(food.foodItemName.length > 12
                                        ? '${food.foodItemName.substring(0, 9)}...'
                                        : food.foodItemName),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "(${food.pricePerMeasure})  X  " +
                                          "${food.quantity}",
                                      style: widget.textStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "=",
                                      style: widget.textStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "${food.pricePerMeasure * food.quantity}",
                                      style: widget.textStyle,
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
              // Total
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
                        child: Text("${widget.total}"),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              //Checkout button
              top: MediaQuery.of(context).size.height * 0.82,
              left: MediaQuery.of(context).size.width * (1 - 0.95) / 2,
              width: MediaQuery.of(context).size.width * 0.95,
              child: loading
                  ? Center(
                      child: SizedBox(
                          height: 30, child: CircularProgressIndicator()),
                      widthFactor: 1,
                    )
                  : styledButton(context, "Order Now", () async {
                      setState(() {
                        loading = true;
                      });
                      var user = await widget.auth.currentUser();
                      if (cartAddress != '') {
                        var now = DateTime.now();
                        CartInfo cartinfo = CartInfo(
                          foodList: cartAllInfo.toList(),
                          // instead of passing the orignal list it will pass a new list everytime
                          // apparently it was a call by reference so changes made
                          // were reflected in all the objects
                          id: user.uid + now.toString(),
                          address: cartAddress,
                          delivCord: cartCord,
                        );
                        await widget.fireStoreService.createCart(
                          cartinfo,
                        );
                        setState(() {
                          loading = false;
                        });
                        trackOrder.add(cartinfo);
                        print(trackOrder.map((cartInfo) =>
                            "${cartInfo.foodList.map((food) => "${food.foodItemName} ")} "));

                        print("Order Placed");
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          loading = false;
                        });
                        await showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                title: Text('Select a Location first'),
                              );
                            });
                        // wait to show dialog then redirect to maps page
                        MyMapsPage myMapsPage = MyMapsPage();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => myMapsPage,
                          ),
                        );
                        cartAddress = myMapsPage.returnAddress();
                        cartCord = myMapsPage.returnCord();
                        // Updating cart address here
                      }
                    }),
            ),
            Positioned(
              // Go back Button
              top: MediaQuery.of(context).size.height * 0.9,
              left: MediaQuery.of(context).size.width * (1 - 0.95) / 2,
              width: MediaQuery.of(context).size.width * 0.95,
              child: styledButton(context, "Go back", () {
                Navigator.pop(context);
              }, icon: Icons.keyboard_arrow_left),
            ),
          ],
        ),
      ),
    );
  }
}
