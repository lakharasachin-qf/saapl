import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saapl/models/login_model.dart';
import 'package:saapl/models/work_model.dart';
import 'package:saapl/utils/apis_collection.dart';
import 'package:saapl/utils/screen_loader.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class QWTScreen extends StatefulWidget {

  QWTScreen({Key? key}) : super(key: key);

  @override
  _QWTScreenState createState() => _QWTScreenState();
}

class _QWTScreenState extends State<QWTScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  ScreenshotController screenshotController = ScreenshotController();
  bool _isInAsyncCall = false;

  TextEditingController woNoController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    initSharedPref();

    getOEMApiCall(LoadingOem, api_oem_list);
    getPartyApiCall(LoadingParty, api_party_list);
    getEmployeeList(LoadingEmployee, api_employee_list);
    getVisitTypeApiCall(LoadingVisitType, api_visit_type_list);
  }

  late SharedPreferences pref;
  late Data user;
  late String userName;

  initSharedPref() async {
    pref = await SharedPreferences.getInstance();

    Map<String, dynamic> jsondatais = jsonDecode(pref.getString('user')!);
    user = Data.fromJson(jsondatais);

    if (jsondatais.isNotEmpty) {
      setState(() {
        userName = user.userName;
      });
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      key: new Key("te"),
      child: _getUI(context),
      inAsyncCall: _isInAsyncCall,
      opacity: 0.3,
    );

  }

  int LoadingOem = 0;
  int LoadingParty = 0;
  int LoadingEmployee = 0;
  int LoadingVisitType = 0;

  Future<String> getOEMApiCall(int apiSource, String apiURL) async {
    setState(() {
      _isInAsyncCall = true;
    });
    final response = await http.post(Uri.parse(apiURL));
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      print(apiURL + "=" + resBody.toString());
      setState(() {
        _isInAsyncCall = false;

        oemDataList = resBody['data'];
      });
    } else {
      print("Error");
    }
    return "Sucess";
  }

  Future<String> getPartyApiCall(int apiSource, String apiURL) async {
    final response = await http.post(Uri.parse(apiURL));
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      print(apiURL + "=" + resBody.toString());
      setState(() {
        partyDataList = resBody['data'];
      });
    } else {
      print("Error");
    }
    return "Sucess";
  }

  Future<String> getEmployeeList(int apiSource, String apiURL) async {
    final response = await http.post(Uri.parse(apiURL));
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      print(apiURL + "=" + resBody.toString());
      setState(() {
        employeeDataList = resBody['data'];
      });
    } else {
      print("Error");
    }
    return "Sucess";
  }

  Future<String> getVisitTypeApiCall(int apiSource, String apiURL) async {
    final response = await http.post(Uri.parse(apiURL));
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      print(apiURL + "=" + resBody.toString());
      setState(() {
        visitType = resBody['data'];
      });
    } else {
      print("Error");
    }
    return "Sucess";
  }

  late List oemDataList = [];
  late List partyDataList = [];
  late List employeeDataList = [];
  late List visitType = [];

  late String selectedOEM;
  late String selectedParty;
  late String selectedEmployee;
  late String selectedVisitType;

  Widget _getUI(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Stack(children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Add QWT",
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: formGlobalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownSearch(
                        validator: (value) =>
                            value == null ? 'Please fill in your gender' : null,
                        mode: Mode.MENU,
                        dropdownSearchDecoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Choose OEM',
                        ),
                        showSearchBox: true,
                        //list of dropdown items
                        items: oemDataList.map((item) {
                          return item["MACHCOMP"].toString().trim();
                        }).toList(),
                        label: "OEM",
                        onChanged: (val) {
                          selectedOEM = val.toString();
                          print(selectedOEM);
                          setState(() {});
                        },
                        //show selected item
                      ),
                      DropdownSearch(
                        validator: (item) {
                          if (item == null) {
                            return "Please choose party";
                          } else {
                            return null;
                          }
                        },
                        mode: Mode.MENU,
                        dropdownSearchDecoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Choose Party',
                        ),
                        showSearchBox: true,
                        //list of dropdown items
                        items: partyDataList.map((item) {
                          return item["PNAME"].toString().trim();
                        }).toList(),
                        label: "Party",
                        onChanged: (val) {
                          selectedParty = val.toString();
                          print(selectedParty);
                        },
                        //show selected item
                      ),
                      DropdownSearch(
                        validator: (item) {
                          if (item == null) {
                            return "Please choose employee";
                          } else {
                            return null;
                          }
                        },
                        mode: Mode.MENU,
                        dropdownSearchDecoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Choose Employee',
                        ),
                        showSearchBox: true,
                        //list of dropdown items
                        items: employeeDataList.map((item) {
                          return item["ENAME"].toString().trim();
                        }).toList(),
                        label: "Employee",
                        onChanged: (val) {
                          selectedEmployee = val.toString();
                          print(selectedEmployee);
                        },
                        //show selected item
                      ),
                      DropdownSearch(
                        validator: (item) {
                          if (item == null) {
                            return "Please choose visit type";
                          } else {
                            return null;
                          }
                        },
                        mode: Mode.MENU,
                        dropdownSearchDecoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Choose Visit Type',
                        ),
                        showSearchBox: true,
                        //list of dropdown items
                        items: visitType.map((item) {
                          return item["name"].toString().trim();
                        }).toList(),
                        label: "Visit Type",
                        onChanged: (val) {
                          selectedVisitType = val.toString();
                          print(selectedVisitType);
                        }, //show selected item
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter work order no.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "WoNo",
                        ),
                        controller: woNoController,
                        style: TextStyle(fontSize: 18, fontFamily: "proxi"),
                        cursorColor: primaryColor,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return "Please add remarks";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Remark",
                        ),
                        controller: remarkController,
                        style: TextStyle(fontSize: 18, fontFamily: "proxi"),
                        cursorColor: primaryColor,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RaisedButton(
                        child: Container(
                          alignment: Alignment.center,
                          width: getWidth(context),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                fontFamily: "proxi",
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {
                          if (formGlobalKey.currentState!.validate()) {
                            formGlobalKey.currentState!.save();
                            setState(() {
                              _isInAsyncCall = true;
                            });

                            screenshotController
                                .capture(delay: const Duration(milliseconds: 10))
                                .then((capturedImage) async {
                                await saveImage(capturedImage);
                                addQWTApi();

                            }).catchError((onError) {
                              print(onError);
                              addQWTApi();
                            });

                            // use the email provided here
                          }
                        },
                        color: secondaryColor,
                        textColor: Colors.white,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 18, bottom: 18),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

// function to show captured widget
  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(
                    capturedImage,
                  )
                : Container()),
      ),
    );
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  late String screenshotName;
  Future<bool> saveImage(image) async {
    //final boundary =
    //genKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    //final image = await boundary?.toImage();
    //final byteData = await image?.toByteData(format: ImageByteFormat.png);
    //final imageBytes = byteData?.buffer.asUint8List();
    final imageBytes =
        image; //await resizeImage(); // byteData?.buffer.asUint8List();
    screenshotName = "screenshot"+DateTime.now().millisecondsSinceEpoch.toString()+".jpeg";

    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getApplicationDocumentsDirectory());
          String newPath = "";

          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/RPSApp";
          directory = Directory(newPath);

          print(directory);
        } else {
          print("else -portion");
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {

        File saveFile =
            await File('${directory.path}/'+screenshotName).create();

        if (imageBytes != null) {
          final result = await ImageGallerySaver.saveImage(imageBytes,
              quality: 100, name: screenshotName);
          print("SAVEDIMAGE"+result.toString());
          if (Platform.isAndroid) {
            screenshotName="../Pictures/"+screenshotName;
          }
          print("SAVEDIMAGE = "+screenshotName);

        }
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
          screenshotName="../Pictures/"+screenshotName;

        }
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  String htmlSample = '';
  late String generatedPdfFilePath;

  addQWTApi() async {
    String selectedOEMId = "0";
    String selectedPartyId = "0";
    String selectedEmployeeId = "0";
    String selectedVisitId = "";

    print("selectedOEM " +selectedOEM);
    print("selectedParty " +selectedParty);
    print("selectedEmployee " +selectedEmployee);

    for(int i =0;i<oemDataList.length;i++){
      if (oemDataList[i]["MACHCOMP"].toString().trim() == selectedOEM) {
        selectedOEMId = oemDataList[i]["MACHCOMPID"].toString();
      }
    }

    for(int i =0;i<partyDataList.length;i++){
      if (partyDataList[i]["PNAME"].toString().trim() == selectedParty) {
        selectedPartyId = partyDataList[i]["PRTYID"].toString();
      }
    }

    for(int i =0;i<employeeDataList.length;i++){
      if (employeeDataList[i]["ENAME"].toString().trim() == selectedEmployee) {
        selectedEmployeeId = employeeDataList[i]["EMPID"].toString();
      }
    }
    for(int i =0;i<visitType.length;i++){
      if (visitType[i]["name"].toString().trim() == selectedVisitType) {
        selectedVisitId = visitType[i]["type"].toString();
      }
    }
    //{oemId: 15, partyId: 38, empId: 133, visitType: I, woNo: re frrr, enterBy: 0051, remark: rr}
//{oemId: 29, partyId: 19, empId: 69, visitType: WIRING, woNo: fggg, enterBy: 0051, remark: ggggggg}
    Map<String, dynamic> map = {
      'oemId': selectedOEMId,
      'partyId': selectedPartyId,
      'empId': selectedEmployeeId,
      'visitType': selectedVisitId,
      'woNo': woNoController.text,
      'enterBy': userName.trim(),
      'remark': remarkController.text
    };
    print("PostPARAM " +map.toString());
    final response = await http.post(Uri.parse(api_add_qwt), body: map);
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      setState(() {
        _isInAsyncCall = false;
      });
      print(resBody);
      _showToast(screenshotName);
      Navigator.pop(context);
    } else {
      print("Error");
    }
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
