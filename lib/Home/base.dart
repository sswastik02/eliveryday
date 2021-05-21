import 'dart:ffi';

import 'package:eliveryday/Cart/cart.dart';
import 'package:eliveryday/Maps/maps.dart';
import 'package:eliveryday/Home/home.dart';
import 'package:eliveryday/phoneauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eliveryday/firebaseCustomServices.dart';

// routes are used to navigate between pages
class HomeRoute extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  String address = "Select Location";
  String previousAddress = "";
  MyMapsPage myMapsPage = MyMapsPage();
  bool? signedIn;

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [Home(), Cart(), PhoneAuth(widget._auth)];

    return Scaffold(
      appBar: customAppBar(),
      bottomNavigationBar: customBottomBar(),
      body: _children[_currentIndex],
    );
  }

  AppBar customAppBar() {
    return AppBar(
      leading: Row(
        children: [
          SizedBox(
            width: 3,
          ),
          Icon(
            Icons.delivery_dining,
            size: 40,
          ),
          SizedBox(
            width: 3,
          ),
          // Sized Box can be used for spaces
          Text(
            "Eliveryday",
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
          )
        ],
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.7,
      // It doesnt cross max leading width no matter what length you specify
      actions: [addressLocator(context)],
    );
  }

  BottomNavigationBar customBottomBar() {
    return BottomNavigationBar(
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home),
            label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: "Cart",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.ac_unit),
          label: "Test",
        )
      ],
    );
  }

  Widget addressLocator(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('pressed');

        // Need to await to get address
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => myMapsPage,
          ),
        );
        setState(() {
          String addr = myMapsPage.returnAddress();
          if (addr != "locating.......") {
            address = addr;
            previousAddress = addr;
          } else {
            if (previousAddress == "") {
              address = "Select Location";
              // If no previous address was assigned then set adderess as "Select Location"
              // Otherwise let it reamain previous address
            }
          }
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white,
            ),
            top: BorderSide(color: Colors.white),
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Text(
          address,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
