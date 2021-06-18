import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  BuildContext context;
  bool bckbtn;
  @override
  final Size preferredSize;
  TopBar({
    required this.title,
    this.bckbtn = false,
    required this.context,
  }) : preferredSize =
            Size.fromHeight(MediaQuery.of(context).size.height * 0.2);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: bckbtn ? Colors.transparent : Theme.of(context).backgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => bckbtn ? Navigator.pop(context) : null,
              child: Card(
                elevation: 10,
                color: Colors.teal.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Container(
                  height: 40,
                  width: 40,
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
              color: Colors.teal.shade500,
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
