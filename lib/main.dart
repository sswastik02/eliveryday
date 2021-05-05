import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; //flutter run --no-sound-null-safety
import 'package:geocoder/geocoder.dart';

//import 'package:google_place/google_place.dart' as places;
// conflicting with Location in location.dart
// the above didnt work for places api(requires a billing account)

import './api.dart';

import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  // late is necessary as it is being assigned later
  Location _location = Location();
  late LocationData l;

  List<Marker> _mark = [];
  var address = "locating.......";
  double lat = 0.0, lon = 0.0;
  // stored outside cuz oncameraidle does not take Googleposition function

  void _onMapCreated(GoogleMapController _cntlr) async {
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
    l = await _location.getLocation();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        // animate to current location
      ),
    );
    lat = l.latitude!;
    lon = l.longitude!;
    // https://medium.com/flutter-community/exploring-google-maps-in-flutter-8a86d3783d24
  }

  Future<void> _cordtoname(Coordinates coordinates) async {
    // future is returned everytime await is met(uncompleted or completed)
    var addr = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addr.first;
    print(coordinates);
    setState(() {
      // setState is needed if you want it to reflect immediately without rebuilding
      address = first.addressLine;
    });
  }

  Future<void> _autocomp(String name) async {
    // var dio = Dio();
    // var url =
    //     "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$name&key=$apiKey";
    // var url1 = "https://google.com";
    // var response = await dio.get(url);
    // print(response.data);
    final query = name;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade300,
        leading: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
          ),
          onChanged: (val) async {
            await _autocomp(val);
          },
        ),
      ),
      body: Stack(children: [
        // Stack stacks in the positive z-axis
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialcameraposition,
            zoom: 5.0,
          ),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: Set.from(_mark),
          onCameraMove: (CameraPosition _position) {
            setState(() {
              _mark.add(Marker(
                markerId: MarkerId('camera'),
                draggable: false,
                position: LatLng(
                  _position.target.latitude,
                  _position.target.longitude,
                ),
              ));
              lat = _position.target.latitude;
              lon = _position.target.longitude;
              address = "locating......."; // if camera is moving
            });
          },
          onCameraIdle: () {
            setState(() async {
              await _cordtoname(Coordinates(lat, lon));
              // await waits for a completed future return
              print(address);
            });
          },
        ),
        Positioned(
          // address
          bottom: 100,
          left: 15,
          right: 15,
          child: Container(
            padding: EdgeInsets.all(15.0),
            color: Colors.brown.shade700.withAlpha(170),
            child: Expanded(
              child: Text(
                address,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          // button
          bottom: 20,
          left: 60,
          right: 60,
          child: ElevatedButton(
            child: Text('Choose Location'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.brown.shade800),
            ),
            onPressed: () {},
          ),
        ),
      ]),
    );
  }
}
