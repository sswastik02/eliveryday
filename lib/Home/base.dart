import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eliveryday/Cart/cart.dart';
import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Internet.dart';
import 'package:eliveryday/Maps/maps.dart';
import 'package:eliveryday/Home/home.dart';
import 'package:eliveryday/FireBase/phoneauth.dart';
import 'package:eliveryday/FireBase/styledbuttons.dart';
import 'package:eliveryday/customAppBar.dart';
import 'package:eliveryday/Orders/orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// routes are used to navigate between pages
class HomeRoute extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  String address = "Select Location";
  String previousAddress = "";
  MyMapsPage myMapsPage = MyMapsPage();

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      Home(),
      Cart(widget._auth),
      DisplayOrder(),
      Container(
        color: Theme.of(context).backgroundColor,
        child: Center(child: signoutButton(context, widget._auth)),
      )
    ];
    return Scaffold(
      appBar: TopBar(
        context: context,
        title: addressLocator(context),
      ),
      bottomNavigationBar: customBottomBar(),
      body: FutureBuilder<Object>(
          future: checkInternetConnection(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == 0) {
                return _children[_currentIndex];
              } else {
                return Container(
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: Container(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "You are Offline",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          styledButton(context, "Reload", () {
                            setState(() {});
                          })
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );

    //    else {
    //     return Scaffold(
    //       body: Center(child: CircularProgressIndicator()),
    //     );
    //   }
    // });
    // Scaffold(
    //             body: Center(
    //               child: Container(
    //                 height: 200,
    //                 child: Column(
    //                   children: [
    //                     Text(
    //                       "You are Offline",
    //                       style: TextStyle(color: Colors.red, fontSize: 20),
    //                     ),
    //                     SizedBox(
    //                       height: 20,
    //                     ),
    //                     styledButton(context, "Reload", () {
    //                       setState(() {});
    //                     })
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           );
    // return Scaffold(
    //   appBar: customAppBar(),
    //   bottomNavigationBar: customBottomBar(),
    //   body: _children[_currentIndex],
    // );
  }

  CurvedNavigationBar customBottomBar() {
    return CurvedNavigationBar(
      items: [
        Icon(
          Icons.home,
          color: (_currentIndex == 0) ? Colors.white : Colors.black,
        ),
        Icon(
          Icons.shopping_cart,
          color: (_currentIndex == 1) ? Colors.white : Colors.black,
        ),
        Icon(
          Icons.list,
          color: (_currentIndex == 2) ? Colors.white : Colors.black,
        ),
        Icon(
          Icons.ac_unit,
          color: (_currentIndex == 3) ? Colors.white : Colors.black,
        ),
      ],
      backgroundColor: Theme.of(context).backgroundColor,
      color: Theme.of(context).primaryColor,
      onTap: onTabTapped,
      height: (MediaQuery.of(context).size.height * 0.1 > 70)
          ? 70
          : MediaQuery.of(context).size.height * 0.1,
      animationCurve: Curves.easeInOut,
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
          LatLng cord = myMapsPage.returnCord();
          if (addr != "locating.......") {
            address = addr;
            previousAddress = addr;
            cartAddress = addr;
            cartCord = cord;
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
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Text(
          address,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
