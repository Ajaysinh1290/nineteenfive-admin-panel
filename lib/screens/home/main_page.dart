import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/screens/categories/categories_screen.dart';
import 'package:nineteenfive_admin_panel/screens/chat/chat_main_screen.dart';
import 'package:nineteenfive_admin_panel/screens/customers/customers_screen.dart';
import 'package:nineteenfive_admin_panel/screens/home/drawer_screen.dart';
import 'package:nineteenfive_admin_panel/screens/home/home_page.dart';
import 'package:nineteenfive_admin_panel/screens/orders/orders_screen.dart';
import 'package:nineteenfive_admin_panel/screens/posters/posters_screen.dart';
import 'package:nineteenfive_admin_panel/screens/product/products_screens.dart';
import 'package:nineteenfive_admin_panel/screens/promocodes/promo_code_screen.dart';
import 'package:nineteenfive_admin_panel/screens/settings/settings.dart';
import 'package:nineteenfive_admin_panel/screens/transactions/transaction_screen.dart';
import 'package:nineteenfive_admin_panel/utils/constants.dart';
import 'package:nineteenfive_admin_panel/utils/device_info.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget child = HomePage();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String selectedScreen = Constants.HOME;
  Map<String, dynamic> screensWidgets = {
    Constants.HOME: HomePage(),
    Constants.ORDERS: OrderScreen(),
    Constants.CUSTOMERS: CustomersScreen(),
    Constants.PRODUCTS: ProductsScreen(),
    Constants.TRANSACTIONS: TransactionsScreen(),
    Constants.CATEGORIES: CategoriesScreen(),
    Constants.MESSAGES: ChatMainScreen(),
    Constants.POSTERS: PostersScreen(),
    Constants.PROMO_CODES : PromoCodeScreen(),
    Constants.SETTINGS : Settings()
  };

  getDrawerScreen() {
    return DrawerScreen(
      onScreenChanged: (selectedScreen) {
        setState(() {
          this.selectedScreen = selectedScreen;
          child = screensWidgets[selectedScreen];
          if (scaffoldKey.currentState!.isDrawerOpen) {
            Navigator.of(context).pop();
          }
        });
      },
      selectedScreen: selectedScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DeviceInfo.isMobile(context) ? getDrawerScreen() : null,
      appBar: DeviceInfo.isMobile(context)
          ? AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
              title: Text(
                'Nineteenfive',
                style: Theme.of(context).textTheme.headline2,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!DeviceInfo.isMobile(context)) getDrawerScreen(),
          Expanded(child: child)
        ],
      ),
    );
  }
}
