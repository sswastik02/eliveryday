import 'dart:async';

import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:eliveryday/FireBase/customUser.dart';
import 'package:eliveryday/FireBase/firebaseCustomServices.dart';

import 'package:eliveryday/Orders/EmptyOrder.dart';
import 'package:eliveryday/Orders/orderCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayOrder extends StatefulWidget {
  State<StatefulWidget> createState() => DisplayOrderState();
}

class DisplayOrderState extends State<DisplayOrder> {
  late bool currentOrderPrimary;
  FireStoreService fireStoreService = FireStoreService();
  @override
  void initState() {
    super.initState();
    currentOrderPrimary = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Stack(
        children: [
          ordersButton(),
          refreshButton(),
          (trackOrder.length == 0 && currentOrderPrimary)
              ? emptyOrder(context, currentOrder: currentOrderPrimary)
              : orderListDisplay(),
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
      right: 10,
      height: MediaQuery.of(context).size.height * 0.07,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                currentOrderPrimary = !currentOrderPrimary;
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

  Widget ordersButton() {
    String text = (currentOrderPrimary) ? "Past Orders" : "Current Orders";
    return Positioned(
      //clear button
      top: 10,
      width: MediaQuery.of(context).size.width * 0.5,
      left: 10,
      height: MediaQuery.of(context).size.height * 0.09,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                currentOrderPrimary = !currentOrderPrimary;
              });
            },
            icon: Icon(
              (currentOrderPrimary)
                  ? Icons.keyboard_arrow_left
                  : Icons.keyboard_arrow_right,
              size: 30,
            ),
            label: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                (currentOrderPrimary) ? "Past Orders" : "Current Orders",
              ),
            )),
      ),
    );
  }

  Widget orderListDisplay() {
    print(trackOrder.map((cartInfo) =>
        "${cartInfo.foodList.map((food) => "${food.foodItemName} ")} "));
    return (currentOrderPrimary)
        ? Positioned(
            // List of resturant card
            top: MediaQuery.of(context).size.height * 0.12,
            height: MediaQuery.of(context).size.height * 0.62,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(3.2),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: trackOrder
                      .map((cartInfo) => OrderCard(
                            cartInfo: cartInfo,
                            state: this,
                            currentOrder: currentOrderPrimary,
                          ))
                      .toList(),
                ),
              ),
            ),
          )
        : FutureBuilder<User>(
            future: fireStoreService.getUserProfile(currentUser.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FutureBuilder<List<CartInfo>>(
                    future: getPastCartList(snapshot.data!.cartIds),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
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
                                children: snapshot.data!.reversed
                                    .map((cartInfo) => OrderCard(
                                          cartInfo: cartInfo,
                                          state: this,
                                          currentOrder: currentOrderPrimary,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Positioned(
                          child: loadingCard(context),
                          left: MediaQuery.of(context).size.width * 0.05,
                          top: MediaQuery.of(context).size.height * 0.12,
                          height: MediaQuery.of(context).size.height * 0.62,
                          width: MediaQuery.of(context).size.width,
                        );
                      }
                    });
              } else {
                return Positioned(
                  child: loadingCard(context),
                  left: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.height * 0.12,
                  height: MediaQuery.of(context).size.height * 0.62,
                  width: MediaQuery.of(context).size.width,
                );
              }
            });
  }

  Future<List<CartInfo>> getPastCartList(List<String> pastIds) async {
    List<CartInfo> pastCartList = [];
    for (int i = 0; i < pastIds.length; i++) {
      CartInfo cartInfo = await fireStoreService.getPastCart(pastIds[i]);

      pastCartList.add(cartInfo);

      print(pastCartList);
    }
    return pastCartList;
  }
}
