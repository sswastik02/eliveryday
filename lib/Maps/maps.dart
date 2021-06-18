import 'package:eliveryday/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; //flutter run --no-sound-null-safety
import 'package:geocoder/geocoder.dart';

import 'mapSearch.dart';

//import 'package:google_place/google_place.dart' as places;
// conflicting with Location in location.dart
// the above didnt work for places api(requires a billing account)

class MyMapsPage extends StatefulWidget {
  double lat = 0.0, lon = 0.0;
  String _address = "locating.......";
  bool orderTrack;
  Polyline? mapPolyline;
  MyMapsPage({this.orderTrack = false, this.mapPolyline});
  _MyMapsPageState createState() => _MyMapsPageState();
  String returnAddress() {
    return _address;
  }

  LatLng returnCord() {
    return LatLng(lat, lon);
  }
}

class _MyMapsPageState extends State<MyMapsPage> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController? _controller;
  // late is necessary as it is being assigned later
  Location _location = Location();
  late LocationData locationData;
  List<Marker> _mark = [];

  // stored outside cuz oncameraidle does not take Googleposition function
  @override
  void initState() {
    if (widget.orderTrack) {
      _mark.add(Marker(
          markerId: MarkerId("Delivery"),
          position:
              widget.mapPolyline!.points[widget.mapPolyline!.points.length - 1],
          infoWindow: InfoWindow(title: "Delivery address")));
      _mark.add(Marker(
          markerId: MarkerId("Pickup"),
          position: widget.mapPolyline!.points[0],
          infoWindow: InfoWindow(title: "Pickup address")));
    } else {
      _mark = [];
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose(); // For disposing ? elements
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Geolocator.getCurrentPosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toString());
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
                extendBodyBehindAppBar: true,
                appBar: widget.orderTrack
                    ? null
                    : TopBar(
                        context: context,
                        title: searchButton(),
                        bckbtn: true,
                      ),
                body: Stack(children: [
                  // Stack stacks in the positive z-axis
                  googleMapWidget(),
                  gotoLocationButton(),
                  Container(
                      child: widget.orderTrack ? null : showAddressWidget()),
                  Container(
                      child: widget.orderTrack ? null : chooseMarkedLocation()),
                  // put in a container to use the ternary operator
                ]),
              );
            }
          } else {
            return Scaffold(
              body: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
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
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Go back"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget gotoLocationButton() {
    return Positioned(
      right: 10,
      top: MediaQuery.of(context).size.height * 0.15,
      child: Container(
        color: Theme.of(context).cardColor,
        width: 40,
        height: 40,
        child: IconButton(
          icon: Icon(Icons.gps_fixed),
          onPressed: () {
            _controller!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: _initialcameraposition, zoom: 15)));
          },
        ),
      ),
    );
  }

  Widget searchButton() {
    return TextButton.icon(
      style: ElevatedButton.styleFrom(primary: Colors.teal.shade500),
      icon: Icon(
        Icons.search,
        color: Colors.white,
      ),
      label: Text(
        'Search',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        SearchPage searchPage = SearchPage();
        // need to await as coordinates are fetched from here
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => searchPage));
        print("outside");

        var cord = searchPage.readPlaceCord();
        if (cord != []) {
          _controller!.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(cord[0], cord[1]), zoom: 15),
            ),
          );
          setState(() {
            widget.lat = cord[0];
            widget.lon = cord[1];
            _mark.add(Marker(
              markerId: MarkerId('camera'),
              draggable: false,
              position: LatLng(
                widget.lat,
                widget.lon,
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
      myLocationButtonEnabled: false,
      markers: Set.from(_mark),
      polylines: {
        widget.orderTrack
            ? widget.mapPolyline!
            : Polyline(polylineId: PolylineId("Nothing"))
        // ?? => left side if not null else right side
      },
      onCameraMove: widget.orderTrack
          ? null
          : (CameraPosition _position) {
              setState(() {
                widget.lat = _position.target.latitude;
                widget.lon = _position.target.longitude;
                _mark.add(
                  Marker(
                    markerId: MarkerId('camera'),
                    draggable: false,
                    position: LatLng(
                      widget.lat,
                      widget.lon,
                    ),
                  ),
                );

                widget._address = "locating......."; // if camera is moving
              });
            },
      onCameraIdle: widget.orderTrack
          ? null
          : () async {
              await cordtoname(Coordinates(widget.lat, widget.lon));
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
        color: Colors.teal.shade500.withAlpha(190),
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
          backgroundColor: MaterialStateProperty.all(Colors.teal.shade500),
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
    // the above code keeps on bringing camera to centre(because of the listener) i wanted to do it only once

    if (widget.orderTrack == false) {
      locationData = await _location.getLocation();
      widget.lat = locationData.latitude!;
      widget.lon = locationData.longitude!;
    } else {
      var points = widget.mapPolyline!.points;
      widget.lat = points[points.length - 1].latitude;
      widget.lon = points[points.length - 1].longitude;
      // last point is the delivery address
    }

    _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(widget.lat, widget.lon), zoom: 15),
        // animate to current location
      ),
    );

    _initialcameraposition = LatLng(widget.lat, widget.lon);

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
