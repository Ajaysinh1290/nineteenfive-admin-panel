import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/device_info.dart';
class DrawerScreen extends StatefulWidget {
  final Function(String)? onScreenChanged;
  final String selectedScreen;

  DrawerScreen(
      {Key? key, required this.onScreenChanged, required this.selectedScreen})
      : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  ScrollController scrollController = ScrollController();

  List<String> screensName = [
    Constants.HOME,
    Constants.ORDERS,
    Constants.CUSTOMERS,
    Constants.PRODUCTS,
    Constants.TRANSACTIONS,
    Constants.CATEGORIES,
    Constants.MESSAGES,
    Constants.POSTERS,
    Constants.PROMO_CODES,
    Constants.SETTINGS

  ];
  Map<String, dynamic> screensIcon = {
    Constants.HOME: CupertinoIcons.home,
    Constants.ORDERS: CupertinoIcons.bag,
    Constants.CUSTOMERS: CupertinoIcons.person,
    Constants.PRODUCTS: CupertinoIcons.tag,
    Constants.TRANSACTIONS: CupertinoIcons.creditcard,
    Constants.CATEGORIES: CupertinoIcons.rectangle_grid_2x2,
    Constants.MESSAGES: CupertinoIcons.bubble_left,
    Constants.POSTERS: CupertinoIcons.device_desktop,
    Constants.PROMO_CODES : CupertinoIcons.doc_on_doc,
    Constants.SETTINGS : Icons.settings
  };

  Map<String, dynamic> selectedScreensIcon = {
    Constants.HOME: CupertinoIcons.house_fill,
    Constants.ORDERS: CupertinoIcons.bag_fill,
    Constants.CUSTOMERS: CupertinoIcons.person_fill,
    Constants.PRODUCTS: CupertinoIcons.tag_fill,
    Constants.TRANSACTIONS: CupertinoIcons.creditcard_fill,
    Constants.CATEGORIES: CupertinoIcons.rectangle_grid_2x2_fill,
    Constants.MESSAGES: CupertinoIcons.bubble_left_fill,
    Constants.POSTERS: CupertinoIcons.device_desktop,
    Constants.PROMO_CODES : CupertinoIcons.doc_on_doc_fill,
    Constants.SETTINGS : Icons.settings
  };



  Widget getListTile(IconData icon, String title, Function() onPressed) {
    Color color = title != widget.selectedScreen
        ? Theme.of(context).disabledColor
        : Theme.of(context).accentColor;
    if (DeviceInfo.isTablet(context)) {
      return IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.symmetric(vertical: 20),
          icon: Icon(
            icon,
            size: 24,
            color: color,
          ));
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: title == widget.selectedScreen
              ? Colors.transparent
              : Colors.transparent),
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            vertical: 8,
          ),
          onTap: onPressed,
          leading: Icon(icon, size: 24, color: color),
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline3!.copyWith(
                color: color,
                letterSpacing: 1.5,
                fontWeight: title == widget.selectedScreen
                    ? FontWeight.w500
                    : FontWeight.w300),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.all(5.0),
        height: constraints.maxHeight,
        margin: EdgeInsets.only(right: 20),
        width: (DeviceInfo.isTablet(context)) ? 100 : 300,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: DeviceInfo.isTablet(context)
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (!DeviceInfo.isTablet(context))
                      SizedBox(
                        width: 10,
                      ),
                    ClipOval(
                        child: Image.asset(
                      'assets/logo/round_shaped_logo_with_white_background.png',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    )),
                    if (!DeviceInfo.isTablet(context)) SizedBox(width: 15),
                    if (!DeviceInfo.isTablet(context))
                      Text(
                        'Nineteenfive',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  children: List.generate(
                      screensName.length,
                      (index) => getListTile(
                              screensName[index] == widget.selectedScreen
                                  ? selectedScreensIcon[screensName[index]]
                                  : screensIcon[screensName[index]],
                              screensName[index], () {
                            if (widget.onScreenChanged != null) {
                              widget.onScreenChanged!.call(
                                  screensName[index]);
                            }
                          })),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
