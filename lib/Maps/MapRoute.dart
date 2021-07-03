import 'dart:convert' as convert;
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:eliveryday/Maps/mapboxAPI.dart';
import 'package:eliveryday/Maps/maps.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteInfo {
  LatLng initalPos, finalPos;
  Uri? uri;
  var response;
  RouteInfo({required this.initalPos, required this.finalPos}) {
    generateUri();
  }

  Future<bool> getData() async {
    response = await http.get(uri!);
    response = fromJSON(response);
    return response == null ? false : true;
  }

  double duration() {
    if (response != null) {
      var duration = response['routes'][0]['legs'][0]['duration'];
      return duration.toDouble();
    }
    return -1;
  }

  double distance() {
    if (response != null) {
      var distance = response['routes'][0]['legs'][0]['distance'];
      return distance.toDouble();
    }
    return -1;
  }

  dynamic fromJSON(dynamic response) {
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    return null;
  }

  Polyline polyCords() {
    if (response != null) {
      var line = response['routes'][0]['geometry']['coordinates'];
      // List<LatLng> polyLine = line
      //     .map((coordinates) => LatLng(coordinates[1], coordinates[0]))
      //     .toList();
      List<LatLng> polyLine1 = [];
      for (int i = 0; i < line.length; i++) {
        polyLine1.add(LatLng(line[i][1], line[i][0]));
      }
      Polyline polyline = Polyline(
          polylineId: PolylineId("Draw"),
          points: polyLine1,
          color: Colors.teal.shade700,
          width: 7);
      return polyline;
    }
    return Polyline(polylineId: PolylineId("Error"), color: Colors.white);
  }

  void generateUri() async {
    Uri url = Uri.https(
        'api.mapbox.com',
        '/directions/v5/mapbox/driving-traffic/${initalPos.longitude},${initalPos.latitude};${finalPos.longitude},${finalPos.latitude}',
        {'geometries': 'geojson', 'access_token': kApiKey, 'overview': 'full'});
    // overview full gets you the most precise geometry
    uri = url;
    print(uri);
  }
}

// void main(List<String> arguments) async {
//   // var url = Uri.https(
//   //     'api.mapbox.com',
//   //     '/directions/v5/mapbox/driving-traffic/77.59341437369585,12.865781636477093;77.59598212093319,12.876288810230955',
//   //     {'geometries': 'geojson', 'access_token': kApiKey});

//   // // Await the http get response, then decode the json-formatted response.
//   // var response = await http.get(url);
//   // if (response.statusCode == 200) {
//   //   var jsonResponse =
//   //       convert.jsonDecode(response.body) as Map<String, dynamic>;
//   //   var line = jsonResponse['routes'][0]['geometry']['coordinates'];
//   //   double distance = jsonResponse['routes'][0]['legs'][0]['distance'];
//   //   double duration = jsonResponse['routes'][0]['legs'][0]['duration'];

//   //   print('${line} $distance $duration');
//   // } else {
//   //   print('Request failed with status: ${response.statusCode}.');
//   // }
//   RouteInfo routeInfo = RouteInfo(
//     initalPos: LatLng(12.866352522309944, 77.59345011556077),
//     finalPos: LatLng(12.876351564482198, 77.59600357860586),
//   );
// }

class ShowOrderOnMap extends StatefulWidget {
  late CartInfo cartInfo;
  late RouteInfo routeInfo;
  ShowOrderOnMap({required this.cartInfo}) {
    routeInfo = RouteInfo(
      initalPos: cartInfo.foodList[0].resturantCord,
      // Since orders can only be fulfilled from one resturant taking one element of foodlist will give resturant cord
      finalPos: cartInfo.delivCord,
    );
  }
  State<StatefulWidget> createState() => ShowOrderOnMapState();
}

class ShowOrderOnMapState extends State<ShowOrderOnMap> {
  bool arrowUp = true;
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MyMapsPage(
              orderTrack: true,
              mapPolyline: widget.routeInfo.polyCords(),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: MaterialButton(
                height: 50,
                minWidth: 50,
                elevation: 10,
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                color: Colors.teal.shade500,
              ),
            ),
            AnimatedPositioned(
              bottom: arrowUp
                  ? -1 * MediaQuery.of(context).size.height * 0.5 * 0.85
                  : 5,
              duration: Duration(milliseconds: 500),
              left: MediaQuery.of(context).size.width * (1 - 0.7) / 2,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: Colors.teal.shade500.withOpacity(0.8),
                  child: orderInfo(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget orderInfo() {
    // The stack has been divided into 8 pieces from up to down and each piece might be divided left to right
    return Stack(
      children: [
        Positioned(
          // Title
          top: 5,
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.5 * (1 / 8),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  arrowUp = !arrowUp;
                  print("Changed");
                });
              },
              child: Row(
                children: [
                  Text(
                    "Order Details",
                    style: TextStyle(color: Colors.white, fontSize: 400),
                    // Putting a large value with boxfit will make sure if text is small or big it will fit in the box
                  ),
                  arrowUp
                      ? Icon(
                          Icons.keyboard_arrow_up,
                          size: 400,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.keyboard_arrow_down,
                          size: 400,
                          color: Colors.white,
                        ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          // Time Icon
          top: MediaQuery.of(context).size.height * 0.5 * (2 / 8),
          width: MediaQuery.of(context).size.width * (0.7 - 0.55),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Icon(
              Icons.timelapse,
              size: 400,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          // Details (Distance and Duration)
          top: MediaQuery.of(context).size.height * 0.5 * (1.5 / 8),
          left: MediaQuery.of(context).size.width * (0.7 - 0.55),
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.5 * (2 / 8),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " Total Time : ${(widget.routeInfo.duration() ~/ 60)} min ",
                  style: TextStyle(color: Colors.white, fontSize: 400),
                ),
                Text(
                  " Distance : ${(widget.routeInfo.distance() / 1000).toStringAsPrecision(2)} Km ",
                  style: TextStyle(color: Colors.white, fontSize: 400),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          //line
          top: MediaQuery.of(context).size.height * 0.5 * (4 / 8),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          // List of order
          top: MediaQuery.of(context).size.height * 0.5 * (4 / 8),
          left: MediaQuery.of(context).size.width * (0.7 - 0.57),
          width: MediaQuery.of(context).size.width * 0.57,
          height: MediaQuery.of(context).size.height * 0.5 * (4 / 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: widget.cartInfo.foodList
                  .map(
                    (food) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.57 *
                              (5 / 9),
                          height: 50,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: food.foodItemName.length <= 12
                                  ? Text(
                                      " ${food.foodItemName} ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 400),
                                    )
                                  : Text(
                                      " ${food.foodItemName.substring(0, 10)}... ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 400),
                                    )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.57 *
                              (1 / 9),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "x${food.quantity} ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 400),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.57 *
                              (2 / 9),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "${food.quantity * food.pricePerMeasure} ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Positioned(
          // List Icon
          top: MediaQuery.of(context).size.height * 0.5 * (5 / 8),
          width: MediaQuery.of(context).size.width * (0.7 - 0.55),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Icon(
              Icons.list_alt,
              size: 400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
