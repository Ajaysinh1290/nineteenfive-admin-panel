import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/poster.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/device_info.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';

import 'add_poster.dart';

class PostersScreen extends StatefulWidget {
  const PostersScreen({Key? key}) : super(key: key);

  @override
  _PostersScreenState createState() => _PostersScreenState();
}

class _PostersScreenState extends State<PostersScreen> {
  ScrollController scrollController = ScrollController();
  ScrollController topPostersScrollController = ScrollController();
  ScrollController bottomPostersScrollController = ScrollController();
  bool isTopPostersLoaded = false;
  bool isBottomPostersLoaded = false;

  addNewPoster(BuildContext context, String position) {
    showDialog(
        context: context,
        builder: (context) {
          return AddPoster(
            position: position,
          );
        });
  }

  editPoster(BuildContext context, Poster poster) {
    showDialog(
        context: context,
        builder: (context) {
          return AddPoster.updatePoster(poster);
        });
  }

  refreshScreen() async {
    Future.delayed(Duration(milliseconds: 100))
        .then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal:
                        MediaQuery.of(context).size.width < 680 ? 20 : 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Posters",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        addNewPoster(context, "Top");
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => AddPoster(
                        //               position: "Top",
                        //             )));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(
                                Constants.buttonBorderRadius)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 20,
                              color: Theme.of(context).accentColor,
                            ),
                            if (!DeviceInfo.isMobile(context))
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Add Poster',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onHorizontalDragUpdate: (value) {
                  if (topPostersScrollController.hasClients &&
                      (topPostersScrollController.position.maxScrollExtent -
                                  topPostersScrollController.offset >
                              0 ||
                          (value.primaryDelta ?? 0) > 0)) {
                    topPostersScrollController.jumpTo(
                        topPostersScrollController.offset -
                            (value.primaryDelta ?? 0));
                  }
                },
                onHorizontalDragEnd: (_) => setState(() {}),
                child: Container(
                  width: double.infinity,
                  height: Constants.TOP_POSTER_HEIGHT,
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        child: topPostersScrollController.hasClients &&
                                topPostersScrollController.offset > 5
                            ? IconButton(
                                onPressed: () {
                                  if (topPostersScrollController.hasClients) {
                                    topPostersScrollController
                                        .animateTo(
                                            topPostersScrollController.offset -
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7),
                                            duration:
                                                Duration(milliseconds: 1000),
                                            curve: Curves.easeOutBack)
                                        .then((value) => setState(() {}));
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Theme.of(context).accentColor,
                                ))
                            : SizedBox(
                                width: 40,
                              ),
                      ),
                      Expanded(
                          child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posters')
                            .where('position', isEqualTo: "Top")
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          List<Poster> posters = [];
                          if (snapshot.hasData) {
                            List data = snapshot.data.docs;
                            data.forEach((element) {
                              posters.add(Poster.fromJson(element.data()));
                            });
                            if (!isTopPostersLoaded) {
                              isTopPostersLoaded = true;
                              refreshScreen();
                            }
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            controller: topPostersScrollController,
                            itemCount: snapshot.hasData ? posters.length : 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  editPoster(context, posters[index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(20.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: snapshot.hasData
                                        ? ImageNetwork(
                                            imageUrl: posters[index].imageUrl,
                                            fit: BoxFit.cover,
                                            width: Constants.POSTER_WIDTH,
                                          )
                                        : Container(
                                            width: Constants.POSTER_WIDTH,
                                            height: double.infinity,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        child: topPostersScrollController.hasClients &&
                                topPostersScrollController
                                            .position.maxScrollExtent -
                                        topPostersScrollController.offset -
                                        10 >
                                    0
                            ? IconButton(
                                onPressed: () {
                                  if (topPostersScrollController.hasClients) {
                                    topPostersScrollController
                                        .animateTo(
                                            topPostersScrollController.offset +
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7),
                                            duration:
                                                Duration(milliseconds: 1000),
                                            curve: Curves.easeInOut)
                                        .then((value) => setState(() {}));
                                  }
                                },
                                icon: Icon(Icons.arrow_forward_ios,
                                    color: Theme.of(context).accentColor))
                            : SizedBox(
                                width: 40,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal:
                        MediaQuery.of(context).size.width < 680 ? 20 : 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bottom Posters",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      onTap: () {
                        addNewPoster(context, "Bottom");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(
                                Constants.buttonBorderRadius)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 20,
                              color: Theme.of(context).accentColor,
                            ),
                            if (!DeviceInfo.isMobile(context))
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Add Poster',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onHorizontalDragUpdate: (value) {
                  if (bottomPostersScrollController.hasClients &&
                      (bottomPostersScrollController.position.maxScrollExtent -
                                  bottomPostersScrollController.offset >
                              0 ||
                          (value.primaryDelta ?? 0) > 0)) {
                    bottomPostersScrollController.jumpTo(
                        bottomPostersScrollController.offset -
                            (value.primaryDelta ?? 0));
                  }
                },
                onHorizontalDragEnd: (_) => setState(() {}),
                child: Container(
                  width: double.infinity,
                  height: Constants.BOTTOM_POSTER_HEIGHT,
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        child: bottomPostersScrollController.hasClients &&
                                bottomPostersScrollController.offset > 5
                            ? IconButton(
                                onPressed: () {
                                  if (bottomPostersScrollController
                                      .hasClients) {
                                    bottomPostersScrollController
                                        .animateTo(
                                            bottomPostersScrollController
                                                    .offset -
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7),
                                            duration:
                                                Duration(milliseconds: 1000),
                                            curve: Curves.easeInOut)
                                        .then((value) => setState(() {}));
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Theme.of(context).accentColor,
                                ))
                            : SizedBox(
                                width: 40,
                              ),
                      ),
                      Expanded(
                          child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posters')
                            .where('position', isEqualTo: "Bottom")
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          List<Poster> posters = [];
                          if (snapshot.hasData) {
                            List data = snapshot.data.docs;
                            data.forEach((element) {
                              posters.add(Poster.fromJson(element.data()));
                            });
                            if (!isBottomPostersLoaded) {
                              isBottomPostersLoaded = true;
                              print('calling function');
                              refreshScreen();
                            }
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            controller: bottomPostersScrollController,
                            itemCount: snapshot.hasData ? posters.length : 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  editPoster(context, posters[index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(20.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: snapshot.hasData
                                        ? ImageNetwork(
                                            imageUrl: posters[index].imageUrl,
                                            fit: BoxFit.cover,
                                            width: Constants.POSTER_WIDTH,
                                          )
                                        : Container(
                                            width: Constants.POSTER_WIDTH,
                                            height: double.infinity,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        child: bottomPostersScrollController.hasClients &&
                                bottomPostersScrollController
                                            .position.maxScrollExtent -
                                        bottomPostersScrollController.offset -
                                        10 >
                                    0
                            ? IconButton(
                                onPressed: () {
                                  if (bottomPostersScrollController
                                      .hasClients) {
                                    bottomPostersScrollController
                                        .animateTo(
                                            bottomPostersScrollController
                                                    .offset +
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7),
                                            duration:
                                                Duration(milliseconds: 1000),
                                            curve: Curves.easeInOut)
                                        .then((value) => setState(() {}));
                                  }
                                },
                                icon: Icon(Icons.arrow_forward_ios,
                                    color: Theme.of(context).accentColor))
                            : SizedBox(
                                width: 40,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
