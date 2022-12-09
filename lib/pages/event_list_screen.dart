import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:saapl/models/event_model.dart';
import 'package:saapl/models/intent_helper.dart';
import 'package:saapl/models/login_model.dart';
import 'package:saapl/models/work_model.dart';
import 'package:saapl/pages/event_details_screen.dart';
import 'package:saapl/utils/api_services.dart';
import 'package:saapl/utils/apis_collection.dart';
import 'package:saapl/utils/screen_loader.dart';
import 'package:saapl/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../colors.dart';
import 'edit_work_order_screen.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventListPage>
    with WidgetsBindingObserver {
  bool isLoading = false;
  var apiService;
  late List<EventModel> dataList = [];
  final GlobalKey<_EventScreenState> _myWidgetState =
      GlobalKey<_EventScreenState>();

  void callback(String actionFlag) {
    setState(() {
      if (actionFlag == "apiStart") {
        _isInAsyncCall = true;
      } else if (actionFlag == "apiEnd") {
        _isInAsyncCall = false;
      } else if (actionFlag == "apiEndS") {
        _isInAsyncCall = false;
        _showToast("Attendance Submitted");
      }
    });
    if (actionFlag == "getLocation") {
      //eventToGetLocation();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    apiService = APIService();
    loadData();
    setState(() {
      isLoading = true;
    });
  }

  var intentHelper = IntentHelper();
  late CustomAppBar _appBar;
  bool _isInAsyncCall = true;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      key: new Key("te"),
      child: _getUI(context),
      inAsyncCall: _isInAsyncCall,
      opacity: 0.3,
    );
    
  }

  loadData() async {
    String deviceToken = (await FirebaseMessaging.instance.getToken())!;
    print(deviceToken);
    setState(() {
      isLoading = true;
    });
    pref = await SharedPreferences.getInstance();

    Map<String, dynamic> jsondatais = jsonDecode(pref.getString('user')!);
    Data user = Data.fromJson(jsondatais);

    Map<String, dynamic> map = {
      'empId': user.empId.toString(),
      'role': user.role.toString()
    };
    print("response " + (map.toString()));

    final response = await http.post(Uri.parse(callRegiByEventEmp), body: map);

    _isInAsyncCall = false;
    isLoading = false;
    //setState(() {});

    if (response.statusCode == 200 || response.statusCode == 400) {
      print("response " + (response.body));
      if (json != null) {
        List<WorkOrderResponse> tList = [];
        var data = eventModelFromJson(response.body);
        var currentDate = DateTime.now();
        if (isUpcomming) {
          data.removeWhere((element) {
            if (element.dateofevent.isNotEmpty) {
              var date = DateTime.parse(element.dateofevent);
              print("Yes Remove  : ");
              return (date.compareTo(currentDate) == -1);
            } else {
              return false;
            }
          });
        } else {
          data.removeWhere((element) {
            if (element.dateofevent.isNotEmpty) {
              var date = DateTime.parse(element.dateofevent);
              print("Yes Remove  : ");
              return (date.compareTo(currentDate) != -1);
            } else {
              return false;
            }
          });
        }

        data.sort(
          (a, b) {
            var data1 = DateTime.parse(a.dateofevent);
            var data2 = DateTime.parse(b.dateofevent);
            return data2.compareTo(data1);
          },
        );

        setState(() {
          isLoading = false;
          dataList.clear();
          dataList.addAll(data);
        });
      }
    } else {
      throw Exception('Failed to load data');
    }

    _isInAsyncCall = false;
    setState(() {});
  }

  bool isUpcomming = true;
  Widget _getUI(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: Text(
          "Events",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "proxi",
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        key: _myWidgetState,
        backgroundColor: secondaryColor,
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              loadData();
            },
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isUpcomming = true;
                        _isInAsyncCall = true;
                      });
                      loadData();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: isUpcomming ? primaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primaryColor, width: 0.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 0))
                          ]),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 7, bottom: 7),
                      child: Text(
                        "Upcoming",
                        style: TextStyle(
                            fontSize: 13,
                            color: isUpcomming ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      loadData();
                      setState(() {
                        isUpcomming = false;
                        _isInAsyncCall = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: isUpcomming ? Colors.white : primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primaryColor, width: 0.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 0))
                          ]),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 7, bottom: 7),
                      child: Text(
                        "Complate",
                        style: TextStyle(
                            fontSize: 13,
                            color: isUpcomming ? Colors.black : Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              (dataList.isNotEmpty)
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: getWidth(context),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.white),
                          margin: const EdgeInsets.only(
                              top: 10, left: 15, bottom: 10, right: 15),
                          child: _getBrandItem(dataList[index]),
                        );
                      })
                  : _buildProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (isLoading == false) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          heightFactor: 4,
          child: new Container(
            height: 200,
            child: Text(
              "No data found",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget _getBrandItem(EventModel model) {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EventDetails(model)));
        },
        child: Container(
          margin:
              const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.grey.shade200,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/calendar.svg',
                        height: 10,
                        width: 10,
                        color: Colors.black,
                      )),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 3.0),
                      child: Text(
                        model.title.capitalizeFirst.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      model.dateofevent.toString(),
                      maxLines: 1,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.arrow_right_alt_rounded),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.black12,
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  late FToast fToast;

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
  //   _handlePressPlay();
  // }

  void _handlePressPlay() {
    _appBar.makeApiCall();
  }

  late SharedPreferences pref;

  // eventToGetLocation() async {
  //   _showToast("fetching location...");

  //   Position position = await _getGeoLocationPosition();
  //   location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
  //   print("Location = " + location);
  //   GetAddressFromLatLong(position);
  // }
}
