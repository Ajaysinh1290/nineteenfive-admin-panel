import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/screens/chat/chat_side_bar.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';

import 'chat_screen.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  _ChatMainScreenState createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  UserData? selectedChatUser;
  bool showSideBar = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width>800&&!showSideBar) {
      showSideBar = true;
    }
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [

            Flexible(
              flex: 1,
              child: showSideBar
                  ? SideBar(
                      onUserChanged: (user) => setState(() {
                        this.selectedChatUser = user;
                        if (MediaQuery.of(context).size.width < 800) {
                          showSideBar = false;
                        }
                      }),
                      selectedChatUser: selectedChatUser,
                    )
                  : Container(
                      padding: EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(Constants.containerBorderRadius)),
                      child: ChatScreen(
                        userData: selectedChatUser!,
                        onBackButtonPressed: () {
                          setState(() {
                            showSideBar = true;
                          });
                        },
                      ),
                    ),
            ),
            if (MediaQuery.of(context).size.width > 800)
              SizedBox(
                width: 10,
              ),
            if (MediaQuery.of(context).size.width > 800)
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Constants.containerBorderRadius)),
                  child: selectedChatUser == null
                      ? Text(
                          'Select a chat to start conversion',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        )
                      : ChatScreen(
                          userData: selectedChatUser!,
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
