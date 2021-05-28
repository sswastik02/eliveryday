import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:eliveryday/Orders/MapRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayOrder extends StatefulWidget {
  State<StatefulWidget> createState() => DisplayOrderState();
}

class DisplayOrderState extends State<DisplayOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Stack(
        children: [
          orderTitle(),
          refreshButton(),
          (trackOrder.length == 0) ? emptyOrder() : orderListDisplay(),
        ],
      ),
    );
  }

  Widget orderTitle() {
    return Positioned(
      // Title Resturants
      top: 10,
      left: 10,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: MediaQuery.of(context).size.width * 0.33,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            " Orders ",
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget refreshButton() {
    return Positioned(
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

  Widget orderListDisplay() {
    print(trackOrder.map((cartInfo) =>
        "${cartInfo.foodList.map((food) => "${food.foodItemName} ")} "));
    return Positioned(
      // List of resturant card
      top: 70,
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: trackOrder.map((cartInfo) => orderCard(cartInfo)).toList(),
        ),
      ),
    );
  }

  Widget orderCard(CartInfo cartInfo) {
    ShowOrderOnMap showOrderOnMap = ShowOrderOnMap(cartInfo: cartInfo);
    return FutureBuilder(
        future: showOrderOnMap.routeInfo.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.2,
              child: snapshot.data == true
                  ? GestureDetector(
                      onTap: () async {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return showOrderOnMap;
                        }));
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              " Time Left : ${(showOrderOnMap.routeInfo.duration() ~/ 60)} min ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                                " Distance: ${(showOrderOnMap.routeInfo.distance() / 1000).toStringAsPrecision(2)} Km ",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              " Delivering to: ${cartInfo.address} ",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              " Contains: ${cartInfo.foodList.map((food) => food.foodItemName).toString()} ",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  : Card(
                      color: Theme.of(context).primaryColor,
                      child: Center(child: Text("Error retrieving data!")),
                    ),
            );
          } else {
            return Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget emptyOrder() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: MediaQuery.of(context).size.width * 0.025,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        children: [
          Icon(
            Icons.list_alt,
            size: 100,
            color: Colors.grey.withOpacity(0.35),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              " No Orders are placed ",
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
}
