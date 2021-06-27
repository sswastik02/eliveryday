import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eliveryday/Cart/cart.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:eliveryday/Resturant/FoodCard.dart';
import 'package:eliveryday/Resturant/resturantInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'customUser.dart';

class AuthenticationService {
  Future registerProfile(User user) async {
    FireStoreService _fireStoreService = FireStoreService();

    await _fireStoreService.createUserProfile(User(
      id: user.id,
      fullName: user.fullName,
      age: user.age,
      phoneNumber: user.phoneNumber,
    ));
  }
}

class FireStoreService {
  final CollectionReference _collectionReference =
      Firestore.instance.collection("users");
  final CollectionReference cartCollection =
      Firestore.instance.collection("carts");
  final CollectionReference resturantCollection =
      Firestore.instance.collection("restuarantInfo");
  FirebaseStorage firebaseStorage = FirebaseStorage();

  Future createUserProfile(User user) async {
    try {
      await _collectionReference.document(user.id).setData(user.toJSON());
    } catch (e) {
      print(e);
    }
  }

  Future uploadResturantInfo(SingleResturantInfo info) async {
    try {
      await resturantCollection.document(info.name).setData(info.toJSON());
    } catch (e) {
      print(e.toString());
    }
  }

  Future createCart(CartInfo cart) async {
    try {
      await cartCollection.document(cart.id).setData(cart.toJSON());
    } catch (e) {
      print(e);
    }
  }

  Future<String> getRestuarantImage(String image) async {
    String url = await firebaseStorage
        .ref()
        .child('restuarantImages/$image')
        .getDownloadURL();
    return url;
  }

  Future<String> getFoodImage(String image) async {
    String url =
        await firebaseStorage.ref().child('foodImages/$image').getDownloadURL();
    return url;
  }

  Future<User> getUserProfile(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _collectionReference.document(userId).get();

      return User.fromJSON(documentSnapshot.data);
    } catch (e) {
      print(e);
      print("error");
      return User(id: "Error");
    }
  }

  Future<List<SingleResturantInfo>> getResturants() async {
    try {
      QuerySnapshot querySnapshot = await resturantCollection.getDocuments();
      return querySnapshot.documents
          .map((resturantSnapshot) => getResturant(resturantSnapshot))
          .toList();
    } catch (e) {
      return [];
    }
  }

  SingleResturantInfo getResturant(DocumentSnapshot resturantSnapshot) {
    try {
      return SingleResturantInfo.fromJSON(resturantSnapshot.data);
    } catch (e) {
      print(e.toString());
      return SingleResturantInfo(
          foodList: [],
          name: "",
          image: "",
          resturantCord: LatLng(0, 0),
          address: "",
          rating: -1);
    }
  }

  Future<CartInfo> getPastCart(String cartId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await cartCollection.document(cartId).get();

      return CartInfo.customFromJSON(documentSnapshot.data);
    } catch (e) {
      print(e.toString());
      print("error in cart");
      return CartInfo(
        id: "id",
        foodList: [
          Food(
              foodItemName: "foodItemName",
              category: ["category"],
              resturantCord: LatLng(0, 0))
        ],
        address: "address",
        delivCord: LatLng(0, 2),
      );
    }
  }

  Future<void> updateUser(String userID, Map<String, dynamic> update) async {
    try {
      await _collectionReference.document(userID).updateData(update);
    } catch (e) {
      print(e.toString());
    }
  }

  Future checkUserExists(FirebaseUser user) async {
    bool result = false;
    DocumentSnapshot documentSnapshot =
        await _collectionReference.document(user.uid).get();

    if (documentSnapshot.exists) {
      result = true;
      print('EXISTS');
    } else {
      print("Does Not EXIST");
    }
    return result;
  }
}

Future<FirebaseUser> checkUserSignedIn(FirebaseAuth auth) async {
  FirebaseUser user = await auth.currentUser();
  return user;
}
