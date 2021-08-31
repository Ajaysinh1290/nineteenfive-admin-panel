import 'package:flutter/material.dart';

class DeviceInfo {

  static const MOBILE_MAX_SIZE = 620;
  static const TABLET_MAX_SIZE  = 1050;
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= MOBILE_MAX_SIZE;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width <= TABLET_MAX_SIZE && MediaQuery.of(context).size.width>MOBILE_MAX_SIZE;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > TABLET_MAX_SIZE;
  }
}
