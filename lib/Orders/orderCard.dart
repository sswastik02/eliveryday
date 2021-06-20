import 'dart:async';

import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:eliveryday/FireBase/customUser.dart';
import 'package:eliveryday/FireBase/firebaseCustomServices.dart';
import 'package:eliveryday/Maps/MapRoute.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  CartInfo cartInfo;
  bool currentOrder;
  State? state;
  OrderCard({required this.cartInfo, this.currentOrder = true, this.state});
  OrderCardState createState() => OrderCardState();
}

class OrderCardState extends State<OrderCard> {
  double previousDuration = -1;
  double previousDistance = -1;
  Timer? timer;

  void initState() {
    super.initState();
    setState(() {
      const oneSecond = const Duration(seconds: 25);
      timer = (widget.currentOrder)
          ? new Timer.periodic(oneSecond, (Timer t) => setState(() {}))
          : null;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    print(trackOrder.map((e) => e.id));
    // Cannot process more than one order (As they are future builders whichever computes faster will be put in the array cartIds)
    print(currentUser.cartIds);

    return widget.currentOrder ? currentOrderCard() : pastOrderCard();
  }

  Future<void> updateUserPastCart(CartInfo cartInfo) async {
    FireStoreService fireStoreService = FireStoreService();
    User user = await fireStoreService.getUserProfile(currentUser.id);
    List<String> x = user.cartIds;

    if (user.cartIds.length >= 5) {
      print(x);
      x.removeAt(0);
    }
    x.add(cartInfo.id);
    trackOrder.remove(cartInfo);
    await fireStoreService.updateUser(currentUser.id, {
      "cartIds": x,
    });
    currentUser.cartIds = x;
    print(currentUser.cartIds);
  }

  Widget currentOrderCard() {
    ShowOrderOnMap showOrderOnMap = ShowOrderOnMap(cartInfo: widget.cartInfo);
    String dateTimeString = widget.cartInfo.id.replaceFirst(currentUser.id, "");
    DateTime dateTime = DateTime.parse(dateTimeString); // Order Time
    double duration = -1;
    double distance = -1;
    int timePassed = -1;
    return FutureBuilder(
        future: showOrderOnMap.routeInfo.getData(),
        builder: (context, snapshot) {
          duration = showOrderOnMap.routeInfo.duration();
          distance = showOrderOnMap.routeInfo.distance();
          timePassed = DateTime.now().difference(dateTime).inSeconds;
          // print(timePassed);
          // print(duration);
          print(duration - timePassed);
          print(duration);
          print(distance);
          print(currentUser.cartIds);
          if (snapshot.hasData) {
            if (timePassed > duration && duration >= 0) {
              print("Exe");
              try {
                setState(() {
                  updateUserPastCart(widget.cartInfo)
                      .then((value) => setState(() {
                            trackOrder.remove(widget.cartInfo);
                            widget.state?.setState(() {});
                          }));
                });
              } catch (e) {
                print(e.toString());
              }
            }
            duration = (duration > 0) ? duration : previousDuration;
            distance = (distance > 0) ? distance : previousDistance;
            previousDuration = duration;
            previousDistance = distance;

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
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.access_time,
                                        color: Colors.white),
                                    Text(
                                      ((duration - timePassed) ~/ 60 > 1)
                                          ? "  : ${((duration - timePassed) ~/ 60).abs()} min "
                                          : "  : < 1 min  ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.add_road,
                                      color: Colors.white,
                                    ),
                                    Text(
                                        " : ${(distance / 1000).abs().toStringAsPrecision(2)} Km ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.maps_home_work,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        " : ${widget.cartInfo.address} ",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.list_alt,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        " : ${widget.cartInfo.foodList.map((food) => food.foodItemName).toList().reduce((x, y) => x + ", " + y)} ",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ],
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
            return loadingCard(context);
          }
        });
  }

  Widget pastOrderCard() {
    bool clicked = false;
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.9 / 1.6957,
      // 1.6957 is the aspect ratio of the picture
      child: Card(
        elevation: 10,
        color: Colors.teal.shade500,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.maps_home_work,
                  color: Colors.white,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    " : ${widget.cartInfo.address} ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.list_alt,
                  color: Colors.white,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    " : ${widget.cartInfo.foodList.map((food) => food.foodItemName).toList().reduce((x, y) => x + ", " + y)} ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget loadingCard(BuildContext context) {
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
              top: MediaQuery.of(context).size.width * 0.45 / 1.6957 - 50,
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                color: Colors.white,
              )),
        ])),
  );
}
