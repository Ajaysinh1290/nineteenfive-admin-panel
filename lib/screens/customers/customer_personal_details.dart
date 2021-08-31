import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/screens/chat/chat_screen.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CustomerPersonalDetails extends StatefulWidget {
  final UserData userData;
  final double? width;

  CustomerPersonalDetails({Key? key, required this.userData, this.width})
      : super(key: key);

  @override
  State<CustomerPersonalDetails> createState() =>
      _CustomerPersonalDetailsState();
}

class _CustomerPersonalDetailsState extends State<CustomerPersonalDetails> {
  bool showSendMessageScreen = false;

  sendMail() async {
    final url = 'mailto:${widget.userData.email}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      MyDialog.showMyDialog(context, "Something went wrong..!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 450,
      height: 650,
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Constants.containerBorderRadius)),
      child: showSendMessageScreen
          ? ChatScreen(
              userData: widget.userData,
              onBackButtonPressed: () {
                setState(() {
                  showSendMessageScreen = false;
                });
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: Container(
                    width: 270,
                    height: 270,
                    color: Theme.of(context).cardColor,
                    child: widget.userData.userProfilePic != null
                        ? ImageNetwork(
                            imageUrl: widget.userData.userProfilePic!,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.person,
                            color: Theme.of(context).accentColor,
                            size: 30,
                          ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    widget.userData.userName,
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.mail,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.userData.email,
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.userData.mobileNumber ?? 'Not Available',
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                LongBlueButton(
                  onPressed: () {
                    setState(() {
                      showSendMessageScreen = true;
                    });
                  },
                  text: 'Send Message',
                ),
                SizedBox(
                  height: 10,
                ),
                LongBlueButton(
                  onPressed: () {
                    sendMail();
                  },
                  text: 'Send Mail',
                  color: Theme.of(context).cardColor,
                  textStyle: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
    );
  }
}
