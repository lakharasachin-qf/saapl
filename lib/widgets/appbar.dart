import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:saapl/models/login_model.dart';
import 'package:saapl/pages/add_qwt_screen.dart';
import 'package:saapl/pages/login_screen.dart';
import 'package:saapl/utils/apis_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../colors.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  Function callback;
  final _CustomAppBarState state = _CustomAppBarState();

  CustomAppBar(this.callback, {Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => state;

  @override
  Size get preferredSize => const Size.fromHeight(58.0);

  changeState() {
    state.changeState();
  }

  makeApiCall() {
    state.attendanceApi();
    state.initSharedPref();
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  late SharedPreferences pref;
  late BuildContext dialogContext;
  late Data user;
  String userName = "";
  late int empId;
  String inIcon = "assets/in_icon.png";
  String outIcon = "assets/out_icon.png";
  String currentIconAsset = "";
  String flagSubmittingToApi = "N";
  bool isLoading = false;

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  initSharedPref() async {
    pref = await SharedPreferences.getInstance();

    Map<String, dynamic> jsondatais = jsonDecode(pref.getString('user')!);
    user = Data.fromJson(jsondatais);
    String? lastEntryStatus = pref.getString("isInOut");
    String? previousEntryDate = pref.getString("entryDate");

    if (jsondatais.isNotEmpty) {
      setState(() {
        userName = user.userName;
        empId = user.empId;

        if (previousEntryDate != null) {
          var formatter = DateFormat('yyyy-MM-dd');
          var now = DateTime.now();
          DateTime tempDate = formatter.parse(previousEntryDate);
          var berlinWallFellDate = tempDate.toUtc();

          int diff = now.difference(berlinWallFellDate).inDays;

          String formattedDate = formatter.format(now);
          if (diff == 1) {
            currentIconAsset = inIcon;
            flagSubmittingToApi = "I";
          } else {
            if (lastEntryStatus == "I") {
              currentIconAsset = outIcon;
              flagSubmittingToApi = "O";
            } else if (lastEntryStatus == "O") {
              currentIconAsset = inIcon;
              flagSubmittingToApi = "I";
            } else if (lastEntryStatus == "N") {
              currentIconAsset = "";
              flagSubmittingToApi = "O";
            }
          }
        } else {
          //direct allow to entry of IN
          currentIconAsset = inIcon;
          flagSubmittingToApi = "I";
        }
      });
    }
  }

  void changeState() {
    print("app bar state change");
    setState(() {});
  }

  logout() async {
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

  @override
  void initState() {
    super.initState();
    initSharedPref();
    print("inintState");
  }

  @override
  Widget build(BuildContext context) {
    initSharedPref();
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.white,
      ),
      elevation: 3,
      shadowColor: shadowColor,
      backgroundColor: primaryColor,
      title: Container(
        height: 30,
        child: Marquee(
          text: 'Work Order ${userName.trim()}                 ',
          scrollAxis: Axis.horizontal,
          style: TextStyle(
            fontSize: 18,
            fontFamily: "proxi",
            color: Colors.white,
          ),
          velocity: 50.0,
          pauseAfterRound: Duration(seconds: 1),
          accelerationDuration: Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        ),
      ),
      actions: [
        (currentIconAsset == "")
            ? Container()
            : InkWell(
                onTap: () {
                  attendanceApiWithoutLocation();
                  // attendanceApi();
                },
                child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: currentIconAsset.isNotEmpty
                        ? Image.asset(
                            currentIconAsset,
                            height: 25,
                            width: 25,
                          )
                        : Container()),
              ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => QWTScreen()));
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 15, left: 10),
            child: Text(
              "QWT",
              style: TextStyle(
                fontSize: 18,
                fontFamily: "proxi",
                color: Colors.white,
              ),
            ),
          ),
        ),
        // InkWell(
        //   onTap: () {
        //     logout();
        //   },
        //   child: Container(
        //       margin: const EdgeInsets.only(right: 10),
        //       child: Icon(
        //         Icons.logout,
        //         color: Colors.white,
        //       )),
        // )
      ],
    );
  }

  // makeInOutOPR() async {
  //   pref = await SharedPreferences.getInstance();
  //   if (flagSubmittingToApi == "I") {
  //     currentIconAsset = outIcon;
  //     flagSubmittingToApi = "O";
  //   } else if (flagSubmittingToApi == "O") {
  //     flagSubmittingToApi = "I";
  //     currentIconAsset = "";
  //   }
  //   setState(() {
  //     print("currentIconAsset " + currentIconAsset);
  //     print("AfterChange " + flagSubmittingToApi);
  //   });
  // }

  attendanceApiWithoutLocation() async {
    pref = await SharedPreferences.getInstance();
    print("attendanceApi:" + flagSubmittingToApi.toString());

    widget.callback("apiStart");

    Map<String, dynamic> map = {
      'empId': empId.toString(),
      'inout': flagSubmittingToApi,
      'date': pref.getString('entryDate'),
      'location': '',
    };
    print(map);

    final response = await http.post(Uri.parse(api_in_out_data), body: map);
    if (response.statusCode == 200) {
      widget.callback("apiEnd");
      var resBody = json.decode(response.body);
      await pref.remove("location");
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);

      await pref.setString("entryDate", formattedDate);
      await pref.setString("isInOut", flagSubmittingToApi);
      if (flagSubmittingToApi == "O") {}
      _showToast("Attendance added");
      print(resBody);
    } else {
      widget.callback("apiEnd");
      await pref.remove("location");
      print("Error");
    }
  }

  attendanceApi() async {
    pref = await SharedPreferences.getInstance();
    print("attendanceApi:" + flagSubmittingToApi.toString());

    String? location = pref.getString('location');
    if (location != null && location.isNotEmpty && location != "null") {
      print(location.toString() + "Make api call");
      //widget.callback("apiStart");
      Map<String, dynamic> map = {
        'empId': empId.toString(),
        'inout': flagSubmittingToApi,
        'date': pref.getString('entryDate'),
        'location': location,
      };
      print(map);

      final response = await http.post(Uri.parse(api_in_out_data), body: map);
      if (response.statusCode == 200) {
        var resBody = json.decode(response.body);
        await pref.remove("location");
        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);

        await pref.setString("entryDate", formattedDate);
        await pref.setString("isInOut", flagSubmittingToApi);
        if (flagSubmittingToApi == "O") {}
        _showToast("Attendance added");
        print(resBody);
      } else {
        await pref.remove("location");
        print("Error");
      }
    } else {
      // eventToGetLocation();
    }
  }

  String location = 'Null, Press Button';
  String Address = 'search';

  // Future<Position> _getGeoLocationPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {

  //     await Geolocator.openLocationSettings();
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {

  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  // Future<void> GetAddressFromLatLong(Position position) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   print(placemarks);
  //   Placemark place = placemarks[0];
  //   Address =
  //       '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  //   pref = await SharedPreferences.getInstance();

  //   await pref.setString("location", Address);

  //   print("Address = " + Address);
  //   attendanceApi();
  // }

  // eventToGetLocation() async {
  //   _showToast("fetching location...");

  //   Position position = await _getGeoLocationPosition();
  //   location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
  //   GetAddressFromLatLong(position);
  // }

  late FToast fToast;

  _showToast(String msg) {
    fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
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
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 1),
    );
  }
}
