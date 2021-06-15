import 'package:eliveryday/splash.dart';
import 'package:eliveryday/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'Home/base.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(
    child: MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal[100],
          fontFamily: 'PlayFair',
          backgroundColor: Colors.grey.shade100),
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  FirebaseUser? user;

  // This widget is the root of your application.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool loading = true;
  Future initialCheck() async {
    setState(() async {
      widget.user = await widget._auth.currentUser();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget._auth.currentUser(),
        builder: (context, snapshot) {
          return (snapshot.hasData)
              ? HomeRoute(widget._auth)
              : WelcomeScreen(widget._auth, this);
        });
  }
}
