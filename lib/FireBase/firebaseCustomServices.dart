import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future createUserProfile(User user) async {
    try {
      await _collectionReference.document(user.id).setData(user.toJSON());
    } catch (e) {
      print(e);
    }
  }

  Future createCart(CartInfo cart) async {
    try {
      await cartCollection.document(cart.id).setData(cart.toJSON());
    } catch (e) {
      print(e);
    }
  }

  Future<User> getUserProfile(FirebaseUser user) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _collectionReference.document(user.uid).get();
      return User.fromJSON(documentSnapshot.data);
    } catch (e) {
      print(e);
      return User(id: "Error");
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
