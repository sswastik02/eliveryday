import 'package:flutter/material.dart';

// routes are used to navigate between pages
class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5.0),
              child: GestureDetector(
                onTap: () {
                  print('pressed');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapsRoute(),
                    ),
                  );
                },
                child: Text('LOC : '),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
      ),
    );
  }
}
