import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/category.dart';
import 'package:nineteenfive_admin_panel/screens/home/main_page.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';

import '../../utils/data/static_data.dart';

class LoadData extends StatefulWidget {
  @override
  _LoadDataState createState() => _LoadDataState();
}

class _LoadDataState extends State<LoadData> {
  double angle = 0;
  late Timer timer;
  bool pushed = false;

  pushNextScreen() async {
    if (!pushed) {
      pushed = true;
      timer.cancel();
      await Future.delayed(Duration(milliseconds: 0));
      print('Pushing');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    }
  }

  Widget showLoading(AsyncSnapshot snapshot) {
    late Widget child;
    if (snapshot.hasError) {
      child = Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error,
                  color: ColorPalette.grey,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Something went wrong..!',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              snapshot.error.toString(),
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      );
    } else {
      double length = 130;
      double padding = 3;
      child = Stack(
        children: [
          Container(
            width: length,
            height: length,
            padding: EdgeInsets.all(30),
            child: Image.asset(
              'assets/logo/round_shaped_logo_with_white_background.png',
              width: 80,
              height: 80,
              alignment: Alignment.center,
            ),
          ),
          RotationTransition(
              turns: AlwaysStoppedAnimation(angle / 360),
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: length,
                height: length,
                child: Container(
                  padding: EdgeInsets.all(padding),
                  child: Image.asset(
                    'assets/icons/half_colored_circle_thick.png',
                    width: length,
                    height: length,
                  ),
                ),
              )),
        ],
      );
    }
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(child: child),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (this.mounted) {
        setState(() {
          angle += 1;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            StaticData.categories = [];
            List data = snapshot.data.docs;
            data.forEach((element) {
              StaticData.categories.add(Category.fromJson(element.data()));
            });
            pushNextScreen();
          }
          return showLoading(snapshot);
        });
  }
}
