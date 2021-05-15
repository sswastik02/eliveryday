import 'package:eliveryday/maps/maps.dart';
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
      appBar: AppBar(
        leading: Row(
          children: [
            SizedBox(
              width: 3,
            ),
            Icon(
              Icons.menu,
              size: 30,
            ),
            SizedBox(
              width: 5,
            ),
            // Sized Box can be used for spaces
            Text(
              "Eliveryday",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        leadingWidth: 190,
        actions: [addressLocator(context)],
      ),
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
