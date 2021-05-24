import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; //flutter run --no-sound-null-safety
import 'package:geocoder/geocoder.dart';

import 'mapSearch.dart';

//import 'package:google_place/google_place.dart' as places;
// conflicting with Location in location.dart
// the above didnt work for places api(requires a billing account)

class MyMapsPage extends StatefulWidget {
  String _address = "locating.......";
  _MyMapsPageState createState() => _MyMapsPageState();
  String returnAddress() {
    return _address;
  }
}

class _MyMapsPageState extends State<MyMapsPage> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  // late is necessary as it is being assigned later
  Location _location = Location();
  late LocationData locationData;
  List<Marker> _mark = [];
  double lat = 0.0, lon = 0.0;
  // stored outside cuz oncameraidle does not take Googleposition function

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _location.serviceEnabled(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            print("object");
            if (snapshot.data == false) {
              return Scaffold(
                body: Center(
                  child: Container(
                    height: 100,
                    width: 200,
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Turn on Location and reload",
                            style: TextStyle(fontSize: 400),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text("Reload"),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.brown.shade300,
                  actions: [
                    Container(
                      height: 20,
                      width: 100,
                      child: searchButton(),
                    ),
                  ],
                ),
                body: Stack(children: [
                  // Stack stacks in the positive z-axis
                  googleMapWidget(),
                  showAddressWidget(),
                  chooseMarkedLocation(),
                ]),
              );
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget searchButton() {
    return ElevatedButton(
      child: Text('Search'),
      onPressed: () async {
        SearchPage searchPage = SearchPage();
        // need to await as coordinates are fetched from here
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => searchPage));
        print("outside");

        var cord = searchPage.readPlaceCord();
        if (cord != []) {
          _controller.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(cord[0], cord[1]), zoom: 15),
            ),
          );
          setState(() {
            lat = cord[0];
            lon = cord[1];
            _mark.add(Marker(
              markerId: MarkerId('camera'),
              draggable: false,
              position: LatLng(
                lat,
                lon,
              ),
            ));
          });
        }
      },
    );
  }

  Widget googleMapWidget() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _initialcameraposition,
        zoom: 5.0,
      ),
      mapType: MapType.normal,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      markers: Set.from(_mark),
      onCameraMove: (CameraPosition _position) {
        setState(() {
          lat = _position.target.latitude;
          lon = _position.target.longitude;
          _mark.add(Marker(
            markerId: MarkerId('camera'),
            draggable: false,
            position: LatLng(
              lat,
              lon,
            ),
          ));

          widget._address = "locating......."; // if camera is moving
        });
      },
      onCameraIdle: () async {
        await cordtoname(Coordinates(lat, lon));
        setState(() {
          // await waits for a completed future return
          print(widget._address);
        });
      },
    );
  }

  Widget showAddressWidget() {
    return Positioned(
      // address
      bottom: 100,
      left: 15,
      right: 15,
      child: Container(
        padding: EdgeInsets.all(15.0),
        color: Colors.brown.shade700.withAlpha(170),
        child: Container(
          child: Text(
            widget._address,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseMarkedLocation() {
    return Positioned(
      // button
      bottom: 20,
      left: 60,
      right: 60,
      child: ElevatedButton(
        child: Text('Choose Location'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.brown.shade800),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void onMapCreated(GoogleMapController _cntlr) async {
    // async means initiated and letting other operation(await) complete before completing itself
    _controller = _cntlr;
    // _location.onLocationChanged.listen((l) {
    //   _controller.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
    // The ! is necessary (error: 'double?' expected got 'double' ) (! checks for not null) (? asks if its not null)
    //     ),
    //   );
    // }
    // );
    // the above code keeps on bringing camera to centre i wanted to do it only once

    locationData = await _location.getLocation();
    lat = locationData.latitude!;
    lon = locationData.longitude!;

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lon), zoom: 15),
        // animate to current location
      ),
    );

    // https://medium.com/flutter-community/exploring-google-maps-in-flutter-8a86d3783d24
  }

  Future<void> cordtoname(Coordinates coordinates) async {
    // future is returned everytime await is met(uncompleted or completed)
    var addr = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addr.first;
    print(coordinates);
    setState(() {
      // setState is needed if you want it to reflect immediately without rebuilding
      widget._address = first.addressLine;
    });
  }
}
