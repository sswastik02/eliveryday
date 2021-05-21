import 'package:flutter/material.dart';

import '../Resturant/resturantDisplayInfo.dart';
import '../Cart/cartInfo.dart';

class Cart extends StatefulWidget {
  CartState createState() => CartState();
}

class CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 5),
        ),
        child: Stack(
          children: [
            cartTitle(context),
            cartdisplay(context),
            refreshButton(),
            (cartAllInfo.length == 0) ? emptyCart() : checkoutButton(),
          ],
        ),
      ),
    );
  }

  Widget emptyCart() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      width: 350,
      left: MediaQuery.of(context).size.width * 0.5 - 175,
      child: Column(
        children: [
          Icon(
            Icons.shopping_cart_sharp,
            size: 100,
            color: Colors.grey.withOpacity(0.2),
          ),
          Text(
            "Your Cart is Empty",
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget checkoutButton() {
    return Positioned(
      bottom: 10,
      width: 150,
      height: 50,
      left: MediaQuery.of(context).size.width * 0.5 - 75,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.exit_to_app),
        label: Text("Checkout"),
      ),
    );
  }

  Widget refreshButton() {
    return Positioned(
      top: 7,
      width: 125,
      right: 10,
      height: 40,
      child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              cartAllInfo = cartAllInfo;
              // just a refresh
            });
          },
          icon: Icon(Icons.refresh),
          label: Text(
            "Refresh",
          )),
    );
  }

  Widget cartTitle(BuildContext context) {
    return Positioned(
      // Title Cart
      top: 10,
      left: 10,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
        ),
        child: Text(
          " Cart ",
          style: TextStyle(
              color: Colors.deepOrange,
              fontFamily: "Times New Roman",
              fontSize: 30),
        ),
      ),
    );
  }

  Widget cartdisplay(BuildContext context) {
    return Positioned(
      left: 10,
      top: 70,
      height: MediaQuery.of(context).size.height * 0.62,
      width: MediaQuery.of(context).size.width * 0.93,
      child: foodList(cartAllInfo),
    );
  }
}
