import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:saapl/models/intent_helper.dart';
import 'package:saapl/models/login_model.dart';
import 'package:saapl/models/work_model.dart';
import 'package:saapl/utils/api_services.dart';
import 'package:saapl/utils/apis_collection.dart';
import 'package:saapl/utils/screen_loader.dart';
import 'package:saapl/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import 'edit_work_order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool isLoading = false;
  var apiService;
  late List<WorkOrderResponse> dataList = [];
  final GlobalKey<_HomeScreenState> _myWidgetState =
      GlobalKey<_HomeScreenState>();

  getBrands() {
    var apiService = APIService();
    apiService.getWorkOrderList().then((value) async {
      setState(() {
        isLoading = false;
        //dataList = value.data;
      });
    });
  }

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
      eventToGetLocation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      print("OnResume Called");
      loadData();
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _appBar = CustomAppBar(
      callback,
      key: _myWidgetState,
    );

    WidgetsBinding.instance!.addObserver(this);

    apiService = APIService();
    loadData();
    setState(() {
      isLoading = true;
    });
  }

  var intentHelper = IntentHelper();
  late CustomAppBar _appBar;
  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      key: new Key("te"),
      child: _getUI(context),
      inAsyncCall: _isInAsyncCall,
      opacity: 0.3,
    );
    //return _getUI(context);
  }

  loadData() async {
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

    final response = await http.post(Uri.parse(api_work_order_list), body: map);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print("response " + (response.body));
      final json = jsonDecode(response.body);
      if (json != null) {
        List<WorkOrderResponse> tList = [];
        json.forEach((element) {
          final student = WorkOrderResponse.fromJson(element);
          tList.add(student);
        });

        setState(() {
          isLoading = false;
          dataList.clear();
          dataList.addAll(tList);
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget _getUI(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteBackground,
      appBar: _appBar,
      body: RefreshIndicator(
        color: Colors.white,
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
    if (isLoading) {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Center(
          child: new Opacity(
            opacity: isLoading ? 1.0 : 00,
            child: new CircularProgressIndicator(),
          ),
        ),
      );
    } else
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Center(
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

  Widget _getBrandItem(WorkOrderResponse model) {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditWorkOrderScreen(model: model)));
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/users_place.png"))),
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
                        (model.oem.isNotEmpty &&
                                model.oem.toString().trim().toUpperCase() !=
                                    "UNDFIND")
                            ? model.oem.trim() +
                                (model.workorderid.isNotEmpty
                                    ? " (" + model.workorderid[0].wono + ")"
                                    : "")
                            : 'Not Filled',
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
                      model.ticketdate.toString(),
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
    _handlePressPlay();
  }

  void _handlePressPlay() {
    _appBar.makeApiCall();
  }

  late SharedPreferences pref;

  eventToGetLocation() async {
    _showToast("fetching location...");

    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    print("Location = " + location);
    GetAddressFromLatLong(position);
  }
}
