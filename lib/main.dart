import 'dart:async';
import 'package:eliveryday/Cart/cartInfo.dart';
import 'package:eliveryday/Cart/cartModel.dart';
import 'package:flutter_config/flutter_config.dart';

import './FireBase/firebaseCustomServices.dart';
import 'package:eliveryday/FireBase/customUser.dart';
import 'package:eliveryday/Internet.dart';
import 'package:eliveryday/splash.dart';
import 'package:eliveryday/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Home/base.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await dotenv.load(fileName: ".env");
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
  User? profile;

  // This widget is the root of your application.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FireStoreService fireStoreService = FireStoreService();
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool loading = true;

  Future<bool> initialCheck() async {
    widget.user = await widget._auth.currentUser();

    if (widget.user == null) return false;

    widget.profile =
        await widget.fireStoreService.getUserProfile(widget.user!.uid);

    if (widget.profile!.fullName == '') return false;

    currentUser = widget.profile!;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return FutureBuilder(
        future: checkInternetConnection(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == 0) {
            return FutureBuilder(
                future: initialCheck().timeout(
                  Duration(seconds: 30),
                  onTimeout: () {
                    return false;
                  },
                ),
                builder: (context, snapshot) {
                  print("object1");
                  print(snapshot.hasData);

                  if (snapshot.hasData) {
                    print(snapshot.data);
                    return (snapshot.data == true)
                        ? HomeRoute(widget._auth)
                        : WelcomeScreen(widget._auth, this);
                  } else {
                    return SplashScreen();
                  }
                });
          } else if (snapshot.hasData && snapshot.data == 1) {
            return noInternetConnection(context, this);
          } else
            return SplashScreen();
        });
  }
}
