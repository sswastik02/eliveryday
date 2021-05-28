import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  bool bckbtn;
  @override
  final Size preferredSize;
  TopBar({
    required this.title,
    this.bckbtn = false,
  }) : preferredSize = Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: bckbtn ? Colors.transparent : Theme.of(context).backgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              elevation: 10,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                ),
              ),
              child: GestureDetector(
                onTap: () => bckbtn ? Navigator.pop(context) : null,
                child: Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.all(10),
                  child: Icon(
                    bckbtn ? Icons.arrow_back_ios : Icons.delivery_dining,
                    color: Colors.white,
                    size: bckbtn ? 30 : 40,
                  ),
                ),
              ),
            ),
            Card(
              color: Theme.of(context).primaryColor,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / (bckbtn ? 3 : 1.5),
                height: 50,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: title,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
