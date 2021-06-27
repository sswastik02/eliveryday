import 'package:eliveryday/Resturant/resturantCard.dart';
import 'package:eliveryday/Resturant/resturantInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<String> searchHistory = [];

class Search extends StatefulWidget {
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  List<SingleResturantInfo> searchResult = resturanAllInfo.toList();

  TextEditingController controller = TextEditingController();
  void initState() {
    super.initState();
    controller.addListener(() {
      search(controller.text);
    });
  }

  void search(String text) {
    SingleResturantInfo info;
    List<SingleResturantInfo> x = [];
    for (int i = 0; i < resturanAllInfo.length; i++) {
      info = resturanAllInfo[i];
      if (info.name.toLowerCase().contains(text.toLowerCase()) ||
          info.address.toLowerCase().contains(text.toLowerCase())) {
        x.add(info);
      }
    }
    print(x);
    setState(() {
      searchResult = x;
      if (searchResult.length == 1) if (!searchHistory.contains(
          searchResult[0].name)) searchHistory.add(searchResult[0].name);
      print(searchHistory);
    });
  }

  bool display = false;

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: [
          Positioned(
              top: 20,
              left: MediaQuery.of(context).size.width * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    onTap: () {
                      setState(() {
                        display = true;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Search Restuarants",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  display
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              display = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: SingleChildScrollView(
                              child: Column(
                                children: searchResult
                                    .map((resturant) => ResturantCard(
                                          resturant.foodList,
                                          resturant.address,
                                          resturant.rating,
                                          resturant.resturantCord,
                                          resturantTitle: resturant.name,
                                          image: resturant.image,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.history,
                                              color: Colors.blueGrey,
                                            ),
                                            Text(
                                              " Recent ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  ] +
                                  (searchHistory.length > 0
                                      ? searchHistory
                                          .map((search) => Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child: Text(search)),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            searchHistory
                                                                .remove(search);
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ))
                                          .toList()
                                      : [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              FaIcon(
                                                FontAwesomeIcons.searchPlus,
                                                color: Colors.blueGrey,
                                              ),
                                              Text("No search History")
                                            ],
                                          )
                                        ]),
                            ),
                          ),
                        ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        display = false;
                      });
                    },
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                    ),
                  ))
                ],
              ))
        ],
      ),
    );
  }

  void dispose() {
    controller.removeListener(() {});
    controller.dispose();

    super.dispose();
  }
}
