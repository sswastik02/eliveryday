import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:eliveryday/Maps/MapRoute.dart';
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
          refreshButton(),
          Positioned(
            // Contents of Cart

            top: MediaQuery.of(context).size.height * 0.09,
            height: MediaQuery.of(context).size.height * 0.66,
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Card(
                elevation: 10,
                color: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(3.2),
                  child: Text(""),
                ),
              ),
            ),
          ),
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
      //clear button
      top: 10,
      width: MediaQuery.of(context).size.width * 0.35,
      right: MediaQuery.of(context).size.width * (0.5 - 0.35 / 2),
      height: MediaQuery.of(context).size.height * 0.07,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ElevatedButton.icon(
            onPressed: () {
              setState(() {});
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
      top: MediaQuery.of(context).size.height * 0.12,
      height: MediaQuery.of(context).size.height * 0.62,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(3.2),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children:
                trackOrder.map((cartInfo) => orderCard(cartInfo)).toList(),
          ),
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
              height: MediaQuery.of(context).size.width * 0.9 / 1.6957,
              // 1.6957 is the aspect ratio of the picture
              child: snapshot.data == true
                  ? GestureDetector(
                      onTap: () async {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return showOrderOnMap;
                        }));
                      },
                      child: Card(
                        elevation: 10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        semanticContainer: true,
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width *
                                  0.9 /
                                  1.6957,
                              child: Image.asset(
                                'lib/Resturant/resturantImages/OrderMapsImageCard.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Column(
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
                                  " Contains: ${cartInfo.foodList.map((food) => food.foodItemName).toList().reduce((x, y) => x + ", " + y)} ",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
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
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9 / 1.6957,
              child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  semanticContainer: true,
                  child: Stack(children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.9 / 1.6957,
                      child: Image.asset(
                        'lib/Resturant/resturantImages/OrderMapsImageCard.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                        left: MediaQuery.of(context).size.width * 0.9 / 2 - 50,
                        top: MediaQuery.of(context).size.width * 0.45 / 1.6957 -
                            50,
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                  ])),
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
