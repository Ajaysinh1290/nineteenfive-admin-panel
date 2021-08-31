import 'dart:async';

import 'package:flutter/material.dart';

class MyDialog {
  static showLoading(BuildContext context) async {
    double angle = 0;
    double length = 130;
    double padding = 3;
    late Timer timer;
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.1),
        barrierDismissible: false,
        builder: (context) {
          return MyStatefulBuilder(
            builder: (context, setState) {
              timer = Timer(Duration(milliseconds: 1), () {
                setState.call(() {
                  angle += 1;
                });
              });
              return SimpleDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                insetPadding: EdgeInsets.zero,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Stack(
                          children: [
                            Container(
                              width: length,
                              height: length,
                              padding:
                                  EdgeInsets.all(30),
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
                        )),
                  )
                ],
              );
            },
            dispose: () {
              timer.cancel();
            },
          );
        });
  }

  //
  static showMyDialog(BuildContext context, String? text) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.2),
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              text!,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white),
            ),
            actions: [
              RaisedButton(
                color: Theme.of(context).buttonColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ok',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black),
                ),
              )
            ],
          );
        });
  }
}

typedef Disposer = void Function();

class MyStatefulBuilder extends StatefulWidget {
  const MyStatefulBuilder({
    Key? key,
    required this.builder,
    required this.dispose,
  }) : super(key: key);

  final StatefulWidgetBuilder builder;
  final Disposer dispose;

  @override
  _MyStatefulBuilderState createState() => _MyStatefulBuilderState();
}

class _MyStatefulBuilderState extends State<MyStatefulBuilder> {
  @override
  Widget build(BuildContext context) => widget.builder(context, setState);

  @override
  void dispose() {
    super.dispose();
    widget.dispose();
  }
}
