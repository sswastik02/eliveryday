import 'package:flutter/material.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';

class SearchPage extends StatelessWidget {
  final kApiKey =
      'pk.eyJ1Ijoic3N3YXN0aWswMiIsImEiOiJja29vY3N6MWEwOGFoMm9zenZydjNudGw1In0.GR5C6FDhMupsYLmNIlO37Q';
  List<double>? _placeCoordinates;

  List<double> readPlaceCord() {
    return _placeCoordinates!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back_ios),
        onPressed: () {
          _placeCoordinates = [];
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        bottom: false,
        child: MapBoxPlaceSearchWidget(
          popOnSelect: true,
          apiKey: kApiKey,
          searchHint: 'Search around',
          onSelected: (place) {
            _placeCoordinates = [place.center[1], place.center[0]];
          },
          context: context,
        ),
      ),
    );
  }
}
