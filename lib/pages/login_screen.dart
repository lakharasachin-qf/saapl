import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saapl/models/intent_helper.dart';
import 'package:saapl/utils/api_services.dart';
import 'package:saapl/utils/screen_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var intentHelper = IntentHelper();
  late SharedPreferences pref;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    getToken();
  }

  bool _isObscure = true;
  bool isLoading = false;

  _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              'assets/bg_login_top_p.png',
              alignment: Alignment.centerRight,
              fit: BoxFit.cover,
              height: 300,
            ),
            top: -20,
            left: -25,
          ),
          Positioned(
            top: getHeight(context) / 4,
            left: 30,
            child: Column(
              children: const [
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "proxi",
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Log In!",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontFamily: "proxi",
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Container(
              constraints: const BoxConstraints.expand(),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20.0, 150, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1, bottom: 0, right: 30, left: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Username",
                            ),
                            controller: usernameController,
                            style: const TextStyle(
                                fontSize: 17, fontFamily: "proxi"),
                            cursorColor: primaryColor,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Username can't be empty";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              name = value;
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: _isObscure,
                            controller: passwordController,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                    icon: Icon(_isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    })),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password can't be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(secondaryColor),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.only(
                                      left: 15, right: 15, top: 18, bottom: 18),
                                ),
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontSize: 14, color: Colors.white))),
                            child: Container(
                              alignment: Alignment.center,
                              width: getWidth(context),
                              child: const Text(
                                "Log In",
                                style: TextStyle(
                                    fontFamily: "proxi",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String userName = usernameController.text;
                                String password = passwordController.text;
                                var apiService = APIService();
                                apiService
                                    .login(userName, password, deviceToken)
                                    .then((value) async {
                                  print(value);
                                  if (value.status == 1) {
                                    pref =
                                        await SharedPreferences.getInstance();
                                    print(value.message);
                                    setState(() {
                                      isLoading = false;
                                    });

                                    var lastEntryDateHold =
                                        value.ioStatus.IODATETIME;
                                    var now = DateTime.now();

                                    var formatter = DateFormat('yyyy-MM-dd');
                                    var lastEntryDate =
                                        DateFormat('yyyy-MM-dd h:m:s')
                                            .parse(lastEntryDateHold);
                                    String formattedDate =
                                        formatter.format(now);
                                    print("lastEntryDate = " +
                                        formatter.format(lastEntryDate));
                                    print("NEW = " + formattedDate);

                                    var berlinWallFellDate =
                                        lastEntryDate.toUtc();
                                    int diff = now
                                        .difference(berlinWallFellDate)
                                        .inDays;
                                    print("NEW = " + diff.toString());

                                    if (diff == 0) {
                                      if (value.ioStatus.INOUT == 'I') {
                                        await pref.setString("isInOut", "I");
                                        await pref.setString(
                                            "entryDate", formattedDate);
                                      } else {
                                        await pref.setString("isInOut", "O");
                                        await pref.setString(
                                            "entryDate", formattedDate);
                                      }
                                    } else if (diff > 0) {
                                      await pref.setString("isInOut", "O");
                                      await pref.setString(
                                          "entryDate", formattedDate);
                                    }

                                    await pref.setString(
                                        "user", jsonEncode(value.data));

                                    await pref.setBool("isLogin", true);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const HomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  } else {
                                    print('apiResponse::${value.message}');
                                    _showToast(value.message);
                                  }
                                });
                              } else {
                                print('Not Validate');
                              }

                              // intentHelper.mobileNo =
                              //     mobileNoController.text;
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             VerificationScreen(
                              //                 intentData: intentHelper)));
                            },
                            // color: secondaryColor,
                            // textColor: Colors.white,
                            // padding: const EdgeInsets.only(
                            //     left: 15, right: 15, top: 18, bottom: 18),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      key: Key("te"),
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  _showToast(String msg) {
    Widget toast = Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: secondaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Flexible(
            flex: 1,
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  String deviceToken = "";

  getToken() async {
    deviceToken = (await FirebaseMessaging.instance.getToken())!;
  }
}
