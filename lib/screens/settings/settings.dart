import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nineteenfive_admin_panel/screens/settings/edit_password.dart';
import 'package:nineteenfive_admin_panel/screens/settings/edit_privacy_policy.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/widgets/button/long_blue_button.dart';
import 'package:nineteenfive_admin_panel/widgets/dialog/my_dialog.dart';
import 'package:nineteenfive_admin_panel/widgets/text_field/basic_text_field.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_about.dart';
import 'edit_shipping_charge.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ScrollController scrollController = ScrollController();

  editShippingCharge(int shippingCharge) {
    showDialog(
        context: context,
        builder: (context) {
          return EditShippingCharge(
            shippingCharge: shippingCharge,
          );
        });
  }

  editPassword() {
    showDialog(
        context: context,
        builder: (context) {
          return EditPassword();
        });
  }

  editAbout(String about) {
    showDialog(
        context: context,
        builder: (context) {
          return EditAbout(about: about);
        });
  }

  editPrimaryPolicy(String privacyPolicy) {
    showDialog(
        context: context,
        builder: (context) {
          return EditPrivacyPolicy(privacyPolicy: privacyPolicy);
        });
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  InkWell(
                    onTap: () {
                      editPassword();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Constants.buttonBorderRadius),
                          color: Theme.of(context).primaryColor),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Edit Password',
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admin')
                    .doc('settings')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  int shippingCharge = 0;
                  if (snapshot.hasData) {
                    print('shipping charge : ${snapshot.data.data()}');

                    if (snapshot.data.data() != null) {
                      shippingCharge = snapshot.data.data()['shipping_charge'];
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shipping Charge',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          InkWell(
                            onTap: () {
                              editShippingCharge(shippingCharge);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Constants.buttonBorderRadius),
                                  color: Theme.of(context).primaryColor),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Edit',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        Constants.currencySymbol + shippingCharge.toString(),
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontFamily: GoogleFonts.openSans().fontFamily),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admin')
                    .doc('about')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  String? about;
                  if (snapshot.hasData) {
                    if (snapshot.data.data() != null) {
                      about = snapshot.data.data()['about'];
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'About',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          InkWell(
                            onTap: () {
                              editAbout(about ?? '');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Constants.buttonBorderRadius),
                                  color: Theme.of(context).primaryColor),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Edit',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Html(
                        data: about ?? '',
                        onLinkTap: (String? url, RenderContext context,
                            Map<String, String> attributes, element) async {
                          if (await canLaunch(url!)) {
                            await launch(
                              url,
                            );
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                      // Text(
                      //   about ?? "No data Found",
                      //   style: Theme.of(context).textTheme.headline5,
                      // ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admin')
                    .doc('privacy_policy')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  String? privacyPolicy;
                  if (snapshot.hasData) {
                    if (snapshot.data.data() != null) {
                      privacyPolicy = snapshot.data.data()['privacy_policy'];
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Privacy Policy',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          InkWell(
                            onTap: () {
                              editPrimaryPolicy(privacyPolicy ?? '');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Constants.buttonBorderRadius),
                                  color: Theme.of(context).primaryColor),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Edit',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Html(
                        data: privacyPolicy ?? '',
                        onLinkTap: (String? url, RenderContext context,
                            Map<String, String> attributes, element) async {
                          if (await canLaunch(url!)) {
                            await launch(
                              url,
                            );
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                      // Text(
                      //   privacyPolicy ?? 'No data found',
                      //   style: Theme.of(context).textTheme.headline5,
                      // ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
