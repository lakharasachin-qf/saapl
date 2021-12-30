import 'dart:convert';

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
              height: 320,
            ),
            top: -20,
            left: -25,
          ),
          Positioned(
            top: 150,
            left: 30,
            child: Column(
              children: [
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "proxi",
                    color: Colors.white,
                  ),
                ),
                const Text(
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
                        top: 50, bottom: 0, right: 30, left: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Username",
                            ),
                            controller: usernameController,
                            style: TextStyle(fontSize: 17, fontFamily: "proxi"),
                            keyboardType: TextInputType.number,
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
                          RaisedButton(
                            child: Container(
                              alignment: Alignment.center,
                              width: getWidth(context),
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                    fontFamily: "proxi",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              // intentHelper.mobileNo =
                              //     mobileNoController.text;
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             VerificationScreen(
                              //                 intentData: intentHelper)));
                              String userName = usernameController.text;
                              String password = passwordController.text;
                              var apiService = APIService();
                              apiService
                                  .login(userName, password)
                                  .then((value) async {
                                    print(value);
                                if (value.status == 1) {
                                  pref = await SharedPreferences.getInstance();
                                  print(value.message);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  //await pref.setString("isInOut", "N");
                                  await pref.setString("isInOut", "O");
                                  var now = DateTime.now().subtract(Duration(days: 1));
                                  var formatter = DateFormat('yyyy-MM-dd');
                                  String formattedDate = formatter.format(now);
                                  print("NEW = " + formattedDate);

                                  await pref.setString("entryDate", formattedDate);
                                  await pref.setString(
                                      "user", jsonEncode(value.data));

                                  await pref.setBool("isLogin", true);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  _showToast(value.message);
                                }
                              });
                            },
                            color: secondaryColor,
                            textColor: Colors.white,
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 18, bottom: 18),
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
      key: new Key("te"),
      child: _uiSetup(context),
      inAsyncCall: isLoading,
      opacity: 0.3,
    );
  }

  _showToast(String msg) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: secondaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
              msg,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
