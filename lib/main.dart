import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saapl/pages/pages.dart';

import 'colors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Saapl',
        debugShowCheckedModeBanner: false,
        theme: MyTheme.lightTheme(context),
        home: const LoginScreen());
  }
}
