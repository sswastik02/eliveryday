import 'package:eliveryday/FireBase/phoneauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'FireBase/styledbuttons.dart';

class WelcomeScreen extends StatefulWidget {
  FirebaseAuth _auth;
  State state;
  WelcomeScreen(this._auth, this.state);
  State<StatefulWidget> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FittedBox(
                      child: Text(
                    "Welcome",
                    style: TextStyle(fontSize: 400),
                  )),
                ),
                styledButton(context, "Sign in through Phone", () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: PhoneAuth(widget._auth),
                      ),
                    ),
                  );
                  widget.state.setState(() {});
                }, icon: Icons.phone, iconColor: Colors.lightGreen),
              ],
            )),
      ),
    );
  }
}
