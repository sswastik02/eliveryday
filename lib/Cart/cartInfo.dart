import 'package:eliveryday/Cart/cartModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Resturant/FoodCard.dart';

List<Food> cartAllInfo = []; // this is changed in the resturaunt section

String cartAddress = '';
LatLng cartCord = LatLng(0, 0);

List<CartInfo> trackOrder = [];
