import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nineteenfive_admin_panel/screens/authentication/login_screen.dart';
import 'package:nineteenfive_admin_panel/screens/home/load_data.dart';
import 'package:nineteenfive_admin_panel/utils/app_theme.dart';

import 'firebase/authentication/authentication.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget with AppThemeMixin {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nineteenfive',
        debugShowCheckedModeBanner: false,
        theme: appThemeData,
        // home: LineChartWidget(),
        home: LoginScreen());
  }
}
