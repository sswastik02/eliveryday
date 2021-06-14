import 'dart:io';

import 'package:flutter/material.dart';

import 'FireBase/styledbuttons.dart';

Future<int> checkInternetConnection() async {
  int maxRetries = 5;
  for (int i = 0; i < maxRetries; i++) {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return 0;
      }
    } on SocketException catch (_) {}
  }
  return 1;
}

Widget noInternetConnection(BuildContext context, State state) {
  return Container(
    color: Theme.of(context).backgroundColor,
    child: Center(
      child: Container(
        height: 200,
        child: Column(
          children: [
            Text(
              "You are Offline",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            styledButton(context, "Reload", () {
              state.setState(() {});
            })
          ],
        ),
      ),
    ),
  );
}
