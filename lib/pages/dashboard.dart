import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:saapl/models/intent_helper.dart';
import 'package:saapl/models/login_model.dart';
import 'package:saapl/models/work_model.dart';
import 'package:saapl/pages/event_list_screen.dart';
import 'package:saapl/pages/home_screen.dart';
import 'package:saapl/utils/api_services.dart';
import 'package:saapl/utils/apis_collection.dart';
import 'package:saapl/utils/screen_loader.dart';
import 'package:saapl/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return _getUI(context);
  }

  logout() async {
    SharedPreferences pref;

    pref = await SharedPreferences.getInstance();
    await pref.setBool("isLogin", false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Widget _getUI(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteBackground,
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "proxi",
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              logout();
            },
            child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Image.asset(
                "assets/logo.png",
                height: 100,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: 15, right: 10, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: primaryColor, width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 0))
                            ]),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventListPage()));
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/images/calendar.svg',
                                height: 30,
                                width: 30,
                                color: Colors.black,
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                "Events",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "proxi",
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 15, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: primaryColor, width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 0))
                            ]),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/images/note.svg',
                                height: 30,
                                width: 30,
                                color: Colors.black,
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                "Work-Order",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "proxi",
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(bottom: 30),
                alignment: Alignment.bottomCenter,
                child: Text(
                  'App Version: 1.0.0',
                  style: TextStyle(fontSize: 12),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
