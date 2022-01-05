import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:saapl/models/login_model.dart';
import 'package:saapl/pages/add_qwt_screen.dart';
import 'package:saapl/pages/login_screen.dart';
import 'package:saapl/utils/apis_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  initSharedPref() async {
    pref = await SharedPreferences.getInstance();
    //await pref.setString("entryDate", "2022-01-03");

    Map<String, dynamic> jsondatais = jsonDecode(pref.getString('user')!);
    user = Data.fromJson(jsondatais);
    String? lastEntryStatus = pref.getString("isInOut");
    String? previousEntryDate = pref.getString("entryDate");
    // print("app bar "+lastEntryStatus.toString());
    // print("app bar "+previousEntryDate.toString());

    if (jsondatais.isNotEmpty) {
      setState(() {
        userName = user.userName;
        empId = user.empId;

        if (previousEntryDate != null) {
          //if not null means there is entry of either today or previous day
          var formatter = DateFormat('yyyy-MM-dd');
          var now = DateTime.now();
          DateTime tempDate = formatter.parse(previousEntryDate);
          var berlinWallFellDate = tempDate.toUtc();

          int diff = now.difference(berlinWallFellDate).inDays;

          String formattedDate = formatter.format(now);
          //print("previous previousEntryDate"+formatter.format(berlinWallFellDate));
          if (diff == 1) {
            currentIconAsset = inIcon;
            flagSubmittingToApi = "I";
          } else {
            if (lastEntryStatus == "I") {
              currentIconAsset = outIcon;
              flagSubmittingToApi = "O";
            } else if (lastEntryStatus == "O") {
              // currentIconAsset = outIcon;
              // flagSubmittingToApi = "N";
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
      elevation: 3,
      shadowColor: shadowColor,
      backgroundColor: primaryColor,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                "Work Order",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "proxi",
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 20),
          child: Text(
            userName.trim(),
            style: TextStyle(
              fontSize: 18,
              fontFamily: "proxi",
              color: Colors.white,
            ),
          ),
        ),
        (currentIconAsset == "")
            ? Container()
            : InkWell(
                onTap: () {
                  attendanceApi();
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
        //widget.callback("apiEndS");
        await pref.remove("location");
        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);

        await pref.setString("entryDate", formattedDate);
        await pref.setString("isInOut", flagSubmittingToApi);
        if (flagSubmittingToApi == "O") {
          //await pref.setString("isInOut", "N");
        }
        _showToast("Attendance added");
        // makeInOutOPR();
        //initSharedPref();
        print(resBody);
      } else {
        await pref.remove("location");
        //     widget.callback("apiEnd");
        print("Error");
      }
    } else {
      eventToGetLocation();
      //widget.callback("getLocation");
    }
  }

// if icon == IN then make entry of In and then replace icon with out

  String location = 'Null, Press Button';
  String Address = 'search';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    pref = await SharedPreferences.getInstance();

    await pref.setString("location", Address);

    print("Address = " + Address);
    attendanceApi();
  }

  eventToGetLocation() async {
     _showToast("fetching location...");

    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    print("Location = " + location);
    GetAddressFromLatLong(position);
  }

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
      toastDuration: Duration(seconds: 1),
    );
  }
}
