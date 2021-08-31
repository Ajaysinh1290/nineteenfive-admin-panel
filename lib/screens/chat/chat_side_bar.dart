import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/chat_data.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';

class SideBar extends StatefulWidget {
  final Function(UserData) onUserChanged;
  final UserData? selectedChatUser;

  const SideBar(
      {Key? key, required this.onUserChanged, required this.selectedChatUser})
      : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  ScrollController scrollController = ScrollController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      height: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.black12,
                      spreadRadius: 3,
                      blurRadius: 10)
                ],
                borderRadius:
                    BorderRadius.circular(Constants.textFieldBorderRadius)),
            child: TextField(
              style: Theme.of(context).textTheme.headline5,
              onChanged: (value) => setState(() {
                searchQuery = value;
              }),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: Colors.white,
                    size: 18,
                  ),
                  hintText: 'Search',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.grey)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              List<UserData> users = [];
              if (snapshot.hasData) {
                List data = snapshot.data.docs;
                data.forEach((element) {
                  users.add(UserData.fromJson(element.data()));
                });
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                controller: scrollController,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  bool isSelected = false;
                  if(widget.selectedChatUser!=null) {
                    isSelected = users[index].userId == widget.selectedChatUser!.userId;
                  }
                  if (searchQuery.trim().isNotEmpty) {
                    if (!users[index]
                        .userName
                        .toLowerCase()
                        .contains(searchQuery.trim().toLowerCase())) {
                      return Container();
                    }
                  }
                  return InkWell(
                    onTap: () {
                      widget.onUserChanged.call(users[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).buttonColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                              Constants.containerBorderRadius)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Hero(
                            tag: users[index].userId,
                            child: users[index].userProfilePic != null
                                ? ClipOval(
                                    child: ImageNetwork(
                                      imageUrl:
                                          users[index].userProfilePic ?? '',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .cardColor),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  users[index].userName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w400),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(users[index].userId)
                                      .collection('chat')
                                      .limit(1)
                                      .orderBy('message_date_time',
                                          descending: true)
                                      .snapshots(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    String chatMessage = '';
                                    if (snapshot.hasData) {
                                      List data = snapshot.data.docs;
                                      data.forEach((element) {
                                        ChatData chatData =
                                            ChatData.fromJson(element.data());
                                        chatMessage = chatData.message;
                                      });
                                    }
                                    return Text(
                                      chatMessage,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: isSelected
                                                  ? Colors.black
                                                  : ColorPalette.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          if(!isSelected)
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(users[index].userId)
                                .collection('chat')
                                .where('is_send_by_user', isEqualTo: true)
                                .where('is_seen_by_receiver', isEqualTo: false)
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              int unReadMessages = 0;
                              if (snapshot.hasData) {
                                List data = snapshot.data.docs;
                                unReadMessages = data.length;
                              }
                              return unReadMessages == 0
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorPalette.skyBlue,
                                        ),
                                        child: Text(
                                          unReadMessages.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ))
        ],
      ),
    );
  }
}
