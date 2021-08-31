import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/models/chat_data.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:time_machine/time_machine.dart';

class ChatBubbles extends StatefulWidget {
  final UserData userData;

  const ChatBubbles({Key? key, required this.userData}) : super(key: key);

  @override
  _ChatBubblesState createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  late ScrollController scrollController;

  late Map<String, List<ChatData>> chatsList;

  refreshScreen() async {
    // Future.delayed(Duration(milliseconds: 100))
    //     .then((value) => setState(() {}));
  }

  seenByAdmin(ChatData chatData) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userData.userId)
        .collection('chat')
        .doc(chatData.chatId)
        .set(chatData.toJson());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.userId)
          .collection('chat')
          .orderBy('message_date_time', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        chatsList = {};
        if (snapshot.hasData) {
          List data = snapshot.data.docs;
          List<ChatData> unreadChats = [];
          data.forEach((element) {
            ChatData chatData = ChatData.fromJson(element.data());

            String dateKey =
                Constants.onlyDateFormat.format(chatData.messageDateTime);

            if (chatsList.containsKey(dateKey)) {
              chatsList[dateKey]!.add(chatData);
            } else {
              chatsList[dateKey] = [chatData];
            }
            if (chatData.isSendByUser && !chatData.isSeenByReceiver) {
              chatData.isSeenByReceiver = true;
              unreadChats.add(chatData);
            }
          });
          unreadChats.forEach((element) {
            seenByAdmin(element);
          });
          unreadChats.clear();
          chatsList.keys.forEach((element) {
            chatsList[element] = chatsList[element]!.reversed.toList();
          });
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.minScrollExtent);
          }
        }
        return !snapshot.hasData
            ? Container()
            : ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: chatsList.keys.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    String dateOfChat = chatsList.keys.toList()[index];
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color : Theme.of(context).cardColor,

                                  borderRadius: BorderRadius.circular(
                                      Constants.chatBubbleBorderRadius)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                Constants.onlyDateFormat
                                            .format(DateTime.now()) ==
                                        dateOfChat
                                    ? 'Today'
                                    : dateOfChat,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Theme.of(context).accentColor),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: chatsList[dateOfChat]!.map((chatData) {
                                Color textColor = chatData.isSendByUser
                                    ? Colors.black
                                    : Colors.white;
                                Color containerColor = chatData.isSendByUser
                                    ? ColorPalette.lightSkyBlue
                                    : Colors.grey[600]!.withOpacity(0.1);
                                Alignment bubbleAlignment =
                                    chatData.isSendByUser
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight;
                                return Container(
                                  alignment: bubbleAlignment,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 20),
                                  width: double.infinity,
                                  constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth * 0.9),
                                  child: Column(
                                    crossAxisAlignment: chatData.isSendByUser
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(Constants
                                                      .chatBubbleBorderRadius),
                                              color: containerColor,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: chatData.isSendByUser
                                                      ? 0
                                                      : 10),
                                              child: Text(
                                                chatData.message,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          if (!chatData.isSendByUser)
                                            Positioned(
                                              bottom: 5,
                                              right: 5,
                                              child: Icon(
                                                chatData.isSeenByReceiver
                                                    ? Icons.done_all
                                                    : Icons.done,
                                                color: chatData.isSeenByReceiver
                                                    ? ColorPalette.skyBlue
                                                    : Colors.white,
                                                size: 18,
                                              ),
                                            )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          Constants.onlyTimeFormat
                                              .format(chatData.messageDateTime),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  fontSize: 10,
                                                  color: Colors.grey[200],
                                                  letterSpacing: 1.2,
                                                  fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              );
      },
    );
  }
}
