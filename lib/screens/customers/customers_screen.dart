import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/models/user_data.dart';
import 'package:nineteenfive_admin_panel/utils/color_palette.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/data/dummy_data.dart';
import 'package:nineteenfive_admin_panel/widgets/image/image_network.dart';
import 'package:nineteenfive_admin_panel/widgets/table/my_table.dart';

import 'customer_details.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  int numberOfUserInPage = 10;
  ScrollController scrollController = ScrollController();
  UserData? userData;

  void openCustomerDetailsScreen(UserData userData) {
    setState(() {
      this.userData = userData;
    });
  }


  @override
  void initState() {
    super.initState();
    print('Initlization of state');
  }

  @override
  Widget build(BuildContext context) {
    print('userdata : $userData');
    return userData != null
        ? CustomerDetails(
            userData: userData!,
            onBackButtonPressed: () {
              setState(() {
                userData = null;
              });
            },
          )
        : Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Users",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        late List<UserData> users;
                        if (snapshot.hasData) {
                          users = [];
                          List data = snapshot.data.docs;
                          data.forEach((element) {
                            users.add(UserData.fromJson(element.data()));
                          });
                        }
                        return !snapshot.hasData
                            ? Container(
                                width: double.infinity,
                                height: 400,
                                margin: EdgeInsets.all(20.0),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        Constants.tableBorderRadius),
                                    border: Border.all(
                                        color: Colors.grey[800] ?? Colors.grey,
                                        width: 1)),
                              )
                            : MyTable(
                                dataRowHeight: 70,
                                columns: List.generate(
                                    Constants.customersTableColumns.length,
                                    (index) => DataColumn(
                                            label: Text(
                                          Constants
                                              .customersTableColumns[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                          overflow: TextOverflow.ellipsis,
                                        ))),
                                rows: List.generate(
                                    users.length,
                                    (index) => DataRow(

                                        onSelectChanged: (bool? selected){
                                          if(selected??false){
                                            openCustomerDetailsScreen(users[index]);
                                          }
                                        },
                                        cells: [
                                          DataCell(
                                            ClipOval(
                                              child: ImageNetwork(
                                                imageUrl: users[index]
                                                        .userProfilePic ??
                                                    '',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorIcon: Icons.person,
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(
                                            users[index].userName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          )),
                                          DataCell(Text(
                                            users[index].email,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          )),
                                          DataCell(
                                            Text(
                                              users[index].mobileNumber ==
                                                          null ||
                                                      users[index]
                                                          .mobileNumber!
                                                          .isEmpty
                                                  ? 'Not Available'
                                                  : users[index].mobileNumber!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      color: users[index]
                                                                      .mobileNumber ==
                                                                  null ||
                                                              users[index]
                                                                  .mobileNumber!
                                                                  .isEmpty
                                                          ? Colors.grey[400]
                                                          : Colors.white),
                                            ),
                                          ),
                                        ])),
                              );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
