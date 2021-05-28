import 'package:flutter/material.dart';

import 'Home/base.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green[900],
          fontFamily: 'PlayFair',
          backgroundColor: Color.fromRGBO(243, 176, 115, 0.8),
        ),
        home: HomeRoute());
  }
}
