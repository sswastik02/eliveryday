import 'package:eliveryday/Resturant/FoodCard.dart';
import 'package:eliveryday/Resturant/resturantCard.dart';
import 'package:eliveryday/Resturant/resturantInfo.dart';
import 'package:eliveryday/Resturant/resturantView.dart';
import 'package:eliveryday/Maps/maps.dart';
import 'package:flutter/material.dart';

// routes are used to navigate between pages
class HomeRoute extends StatefulWidget {
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  String address = "Select Location";
  String previousAddress = "";
  MyMapsPage myMapsPage = MyMapsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Column(
        children: resturanAllInfo.map((resturant) {
          return resturantCard(
            resturant[0],
            resturantTitle: resturant[1],
            image: resturant[2],
          );
        }).toList(),
      ),
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
            width: 5,
          ),
          // Sized Box can be used for spaces
          Text(
            "Eliveryday",
            style: TextStyle(fontSize: 17),
          )
        ],
      ),
      leadingWidth: 190,
      actions: [addressLocator(context)],
    );
  }

  Widget addressLocator(BuildContext context) {
    return Container(
      width: 170,
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
      child: GestureDetector(
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
