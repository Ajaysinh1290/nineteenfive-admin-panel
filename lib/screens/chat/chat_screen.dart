import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/firebase/notification/notification_service.dart';
import 'package:nineteenfive_admin_panel/models/chat_data.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/screens/chat/chat_bubbles.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';

class ChatScreen extends StatefulWidget {
  final UserData userData;
  final Function? onBackButtonPressed;

  ChatScreen({Key? key, required this.userData, this.onBackButtonPressed})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageController.text = '';
  }

  void sendMessage() {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      ChatData chatData = ChatData(
          chatId: DateTime.now().millisecondsSinceEpoch.toString(),
          message: message,
          isSeenByReceiver: false,
          isSendByUser: false,
          messageDateTime: DateTime.now());
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.userId)
          .collection('chat')
          .doc(chatData.chatId)
          .set(chatData.toJson());
      NotificationService.sendNotification(widget.userData.userId, "Nineteenfive","Customer care : "+ message, {
        "screen" : "chat_screen",
        "chat_id" : chatData.chatId
      });
          // .then((value) => setState(() {}));
    }
    messageController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    messageController.text = '';

    return Column(
      children: [
        Row(
          children: [
            if (widget.onBackButtonPressed != null)
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).accentColor,
                  ),
                  iconSize: 22,
                  onPressed: () {
                    widget.onBackButtonPressed!.call();
                  },
                ),
              ),
            widget.userData.userProfilePic != null
                ? ClipOval(
                    child: ImageNetwork(
                      imageUrl: widget.userData.userProfilePic ?? '',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.userData.userName,
              style: Theme.of(context).textTheme.headline5,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 1,
          color: Colors.white12,
          width: double.infinity,
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
            child: ChatBubbles(
          userData: widget.userData,
        )),
        Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(7.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius:
                  BorderRadius.circular(Constants.containerBorderRadius),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, -4),
                    color: Colors.black12,
                    blurRadius: 10)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 50, maxHeight: 150),
                  child: TextField(
                    minLines: 1,
                    maxLines: 10,
                    controller: messageController,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: ColorPalette.grey),
                        hintText: 'Type Something...'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: sendMessage,
                child: Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Constants.buttonBorderRadius),
                      gradient: LinearGradient(colors: [
                        ColorPalette.lightSkyBlue,
                        ColorPalette.skyBlue,
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                  child: Transform.rotate(
                    angle: -45 * pi / 180,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
