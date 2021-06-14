import 'package:eliveryday/Cart/checkout.dart';
import 'package:eliveryday/FireBase/firebaseCustomServices.dart';
import 'package:eliveryday/FireBase/phoneauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Resturant/resturantDisplayInfo.dart';
import '../Cart/cartInfo.dart';

class Cart extends StatefulWidget {
  final FirebaseAuth _auth;
  State? state;
  Cart(this._auth, {this.state});
  CartState createState() => CartState();
}

class CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Stack(
        children: [
          cartTitle(context),
          refreshButton(context),
          cartdisplay(context),
          (cartAllInfo.length == 0) ? emptyCart() : checkoutButton(context),
        ],
      ),
    );
  }

  Widget emptyCart() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: MediaQuery.of(context).size.width * 0.025,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        children: [
          Icon(
            Icons.shopping_cart_sharp,
            size: 100,
            color: Colors.grey.withOpacity(0.35),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              " Your Cart is Empty ",
              style: TextStyle(
                fontSize: 40,
                color: Colors.grey.withOpacity(0.35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget checkoutButton(BuildContext context) {
    return Positioned(
      bottom: 8,
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.07,
      left: MediaQuery.of(context).size.width * 0.5 -
          MediaQuery.of(context).size.width * (0.4 / 2),
      // bringing to centre horizontal
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ElevatedButton.icon(
          onPressed: () async {
            var res = await checkUserSignedIn(widget._auth);

            if (res == null) {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Material(child: Scaffold(body: PhoneAuth(widget._auth))),
                ),
              );
              if (mounted) {
                setState(() {
                  print(res);
                  res = result[0];
                  print(res);
                });
              }

              print("object");
              print(res);
            }
            if (res != null) {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return Scaffold(
                  body: CheckoutPage(widget._auth),
                );
              }));
              // awaiting for if the address changes and then setting state of home route which contains appbar
              widget.state?.setState(() {});
            }
          },
          icon: Icon(Icons.exit_to_app),
          label: Text("Checkout"),
        ),
      ),
    );
  }

  Widget refreshButton(BuildContext context) {
    return Positioned(
      //refresh button
      top: 15,
      width: MediaQuery.of(context).size.width * 0.35,
      right: 10,
      height: MediaQuery.of(context).size.height * 0.05,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                cartAllInfo = cartAllInfo;
                // just a refresh
              });
            },
            icon: Icon(Icons.refresh),
            label: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Refresh",
              ),
            )),
      ),
    );
  }

  Widget cartTitle(BuildContext context) {
    return Positioned(
      // Title Cart
      top: 10,
      left: 10,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: MediaQuery.of(context).size.width * 0.24,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            " Cart ",
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget cartdisplay(BuildContext context) {
    return Positioned(
      // Contents of Cart
      left: 10,
      top: MediaQuery.of(context).size.height * 0.09,
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.93,
      child: Container(
        margin: EdgeInsets.only(top: 5),
        child: foodList(cartAllInfo),
      ),
    );
  }
}
