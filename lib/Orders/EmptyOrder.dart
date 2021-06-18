import 'package:flutter/material.dart';

Widget emptyOrder(BuildContext context, {bool currentOrder = true}) {
  return Positioned(
    top: MediaQuery.of(context).size.height * 0.3,
    left: MediaQuery.of(context).size.width * 0.05,
    width: MediaQuery.of(context).size.width * 0.9,
    child: Column(
      children: [
        Icon(
          Icons.list_alt,
          size: 100,
          color: Colors.grey.withOpacity(0.35),
        ),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            (currentOrder) ? " No Orders are placed " : " No Previous Orders ",
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey.withOpacity(0.35),
            ),
          ),
        ),
      ],
    ),
  );
}
