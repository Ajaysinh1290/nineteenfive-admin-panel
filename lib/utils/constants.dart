import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';

class Constants {
  static const ADMIN_EMAIL_ID = 'nineteenfive@admin.com';
  static final dateFormat = new DateFormat("hh:mm a dd-MMM-yyyy");
  static final onlyDateFormat = new DateFormat("dd MMM yyyy");
  static final onlyTimeFormat = new DateFormat("hh:mm a");
  static const currencySymbol = '₹';
  static const TOP_POSTER_HEIGHT = 220.0;
  static const BOTTOM_POSTER_HEIGHT = 240.0;
  static const POSTER_WIDTH = 300.0;

  static const List<String> ordersTableColumns = [
    "Order",
    "Date",
    "Customer",
    "Product",
    "Qty",
    "Total",
  ];
  static const List<String> transactionsTableColumns = [
    "Transaction Id",
    "Date",
    "Customer",
    "Amount",
  ];

  static const List<String> promoCodesTableColumns = [
    "Promo code",
    "Discount",
    "Active On",
    "Expire On",
  ];
  static List timeFilters = [
    {"label": "Last 7 Days", "value": 7},
    {"label": "Last 30 Days", "value": 30},
    {"label": "Last 90 Days", "value": 90},
    {"label": "Last 180 Days", "value": 180},
    {"label": "Last 365 Days", "value": 365},

    {
      "label": "All",
      "value": LocalDate.dateTime(DateTime.now())
          .periodSince(LocalDate.dateTime(DateTime(2021, 5, 1)))
          .months*31
    }
  ];

  static const List<String> customersTableColumns = [
    "Profile Pic",
    "Name",
    "Email",
    "Mobile Number",
  ];

  // Drawer fields
  static const String HOME = 'Home';
  static const String ORDERS = 'Orders';
  static const String CUSTOMERS = 'Customers';
  static const String PRODUCTS = 'Products';
  static const String TRANSACTIONS = 'Transactions';
  static const String CATEGORIES = 'Categories';
  static const String MESSAGES = 'Messages';
  static const String POSTERS = 'Posters';
  static const String PROMO_CODES = 'Promocodes';
  static const String SETTINGS = 'Settings';

  //Border radius of different widget
  static const double tableBorderRadius = 5;
  static const double containerBorderRadius = 5;
  static const double cardBorderRadius = 5;
  static const double textFieldBorderRadius = 5;
  static const double buttonBorderRadius = 5;
  static const double dropDownButtonBorderRadius = 5;
  static const double chatBubbleBorderRadius = 10;
  static const double sliderBorderRadius = 5;
}

formatNumber(int number) {
  var _formattedNumber = NumberFormat.compactCurrency(
    decimalDigits: 0,
    symbol: '',
  ).format(number);
  return _formattedNumber;
}
