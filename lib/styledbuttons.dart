import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget styledButton(BuildContext context, String txt, VoidCallback? func,
    {MaterialColor iconColor: Colors.blue,
    MaterialColor txtColor: Colors.blueGrey,
    Color backGroundColor: Colors.white}) {
  return Container(
    margin: EdgeInsets.all(10),
    width: MediaQuery.of(context).size.width * 0.9,
    height: 40,
    child: ElevatedButton(
      child: Text(
        txt,
        style: TextStyle(
          color: txtColor,
          fontSize: 20,
        ),
      ),
      onPressed: func,
      style: ElevatedButton.styleFrom(
        primary: backGroundColor,
      ),
    ),
  );
}

Widget signoutButton(BuildContext context, FirebaseAuth _auth) {
  return Builder(builder: (BuildContext context) {
    return styledButton(
      context,
      "Sign out from App      ",
      () async {
        final FirebaseUser user = await _auth.currentUser();
        if (user == null) {
          Scaffold.of(context).showSnackBar(const SnackBar(
            content: Text('No one has signed in.'),
          ));
          return;
        }
        await _auth.signOut();
        final String uid = user.uid;
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(uid + ' has successfully signed out.'),
        ));
      },
    );
  });
}
