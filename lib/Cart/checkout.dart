import 'package:dotted_line/dotted_line.dart';
import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:eliveryday/FireBase/firebaseCustomServices.dart';
import 'package:eliveryday/Maps/maps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckOutPage extends StatefulWidget {
  FireStoreService fireStoreService = FireStoreService();
  late FirebaseAuth auth;
  CheckOutPage(this.auth);
  TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 20);
  double total = cartAllInfo
      .map((food) => (food.quantity * food.pricePerMeasure))
      .toList()
      .reduce((value, element) => value + element);
  CheckOutPageState createState() => CheckOutPageState();
}

class CheckOutPageState extends State<CheckOutPage> {
  bool loading = false;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            Positioned(
                // Background
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  color: Colors.teal.shade300,
                )),
            Positioned(
              // Total
              top: MediaQuery.of(context).size.height * 0.17 - 10,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text(
                    "Total: \u{20B9} ${widget.total}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // Back Button
              top: 10,
              left: 10,
              child: backButton(),
            ),
            Positioned(
              // Order Now Button
              top: 15,
              right: 10,
              child: orderNowButton(),
            ),
            Positioned(
              // List from cart
              top: MediaQuery.of(context).size.height * 0.3,
              left: 0,
              // If width is 0.9 remaining is 0.1 hence moving by 0.05 will Center it
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: Card(
                margin: EdgeInsets.all(0),
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
                      top: 10,
                      height: MediaQuery.of(context).size.height * (0.65),
                      left: MediaQuery.of(context).size.width * 0.02,
                      child: SingleChildScrollView(
                          child: Column(
                        children: cartAllInfo
                            .map((food) => checkOutCard(context,
                                name: food.foodItemName,
                                price: food.pricePerMeasure,
                                quantity: food.quantity))
                            .toList(),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderNowButton() {
    return !loading
        ? MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            onPressed: () async {
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
            },
            child: Text(
              "Order Now",
              style: TextStyle(color: Colors.teal.shade400, fontSize: 18),
            ),
            color: Theme.of(context).backgroundColor,
          )
        : SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              color: Colors.white,
            ));
  }

  Widget backButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.teal.shade300,
      elevation: 0,
      height: 50,
      minWidth: 50,
      child: Icon(
        Icons.arrow_back,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget checkOutCard(BuildContext context,
      {required String name, required double price, required int quantity}) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(
              color: Colors.blueGrey.shade200,
              width: 2,
            )),
        child: Stack(children: [
          Positioned(
            top: 20,
            left: 10,
            width: MediaQuery.of(context).size.width * 0.95 * 0.85,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                name,
                style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 20),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.95 * 0.04,
            bottom: 15,
            width: MediaQuery.of(context).size.width * 0.95 * 0.92,
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.blueGrey.shade500)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text("Price",
                          style: TextStyle(
                              color: Colors.blueGrey.shade500, fontSize: 17)),
                      SizedBox(
                        height: 7,
                      ),
                      Text("\u{20B9} $price",
                          style: TextStyle(
                              color: Colors.blueGrey.shade500, fontSize: 17)),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text("Quantity",
                          style: TextStyle(
                              color: Colors.blueGrey.shade500, fontSize: 17)),
                      SizedBox(
                        height: 7,
                      ),
                      Text(quantity.toString(),
                          style: TextStyle(
                              color: Colors.blueGrey.shade500, fontSize: 17)),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  DottedLine(
                    lineLength: 10 + 17 + 17,
                    direction: Axis.vertical,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      Text("Total",
                          style: TextStyle(
                              color: Colors.blueGrey.shade500, fontSize: 17)),
                      SizedBox(
                        height: 7,
                      ),
                      Text("\u{20B9} ${quantity * price}",
                          style: TextStyle(
                              color: Colors.blueGrey.shade500, fontSize: 17)),
                    ],
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
