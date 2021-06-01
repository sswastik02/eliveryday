import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eliveryday/FireBase/customUser.dart';
import 'package:eliveryday/FireBase/firebaseCustomServices.dart';
import 'package:eliveryday/FireBase/phoneauth.dart';
import 'package:eliveryday/FireBase/styledbuttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  FirebaseAuth auth;
  late FirebaseUser user;
  Profile({required this.auth});
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  bool loading = true;
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkUserSignedIn(widget.auth),
        builder: (context, snapshot) {
          return Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            child: Stack(
              children: [
                profileTitle(),
                refreshButton(),
                (snapshot.hasData) ? profileDisplay() : emptyProfile(),
              ],
            ),
          );
        });
  }

  Widget profileTitle() {
    return Positioned(
      // Title Cart
      top: 10,
      left: 10,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: MediaQuery.of(context).size.width * 0.3,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            " Profile ",
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget refreshButton() {
    return Positioned(
      //refresh button
      top: 15,
      width: MediaQuery.of(context).size.width * 0.35,
      right: 10,
      height: MediaQuery.of(context).size.height * 0.05,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ElevatedButton.icon(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
            label: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Refresh",
              ),
            )),
      ),
    );
  }

  Widget emptyProfile() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: MediaQuery.of(context).size.width * 0.025,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        children: [
          Icon(
            Icons.no_accounts,
            size: 100,
            color: Colors.grey.withOpacity(0.35),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              " No Profile exists ",
              style: TextStyle(
                fontSize: 40,
                color: Colors.grey.withOpacity(0.35),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          styledButton(context, "Sign in through Phone", () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: PhoneAuth(widget.auth),
                ),
              ),
            );
            setState(() {});
          }, icon: Icons.phone, iconColor: Colors.lightGreen),
        ],
      ),
    );
  }

  Future assignCurrentUser() async {
    FirebaseUser user = await widget.auth.currentUser();
    currentUser = await FireStoreService().getUserProfile(user);
    setState(() {
      loading = false;
    });
  }

  Widget profileDisplay() {
    assignCurrentUser();

    TextStyle style = TextStyle(fontSize: 20);
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: MediaQuery.of(context).size.width * 0.025,
      width: MediaQuery.of(context).size.width * 0.95,
      child: loading
          ? Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${currentUser.fullName} ",
                      style: style,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Age: ${currentUser.age} ",
                      style: style,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Phone Number: ${currentUser.phoneNumber} ",
                      style: style,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    signoutButton(context, widget.auth, state: this),
                    // this function has been modified to do a setstate in another file by passing the state
                  ],
                ),
              ),
            ),
    );
  }
}
