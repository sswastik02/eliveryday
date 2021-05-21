import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future createUserProfile(User user) async {
    try {
      await _collectionReference.document(user.id).setData(user.toJSON());
    } catch (e) {
      print(e);
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

Future checkUserSignedIn(FirebaseAuth auth) async {
  final FirebaseUser user = await auth.currentUser();

  return user;
}
