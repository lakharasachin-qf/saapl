import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saapl/models/call_details_model.dart';
import 'package:saapl/models/work_model.dart';
import 'package:saapl/utils/apis_collection.dart';
import 'package:saapl/utils/screen_loader.dart';

import '../colors.dart';

class EditWorkOrderScreen extends StatefulWidget {
  WorkOrderResponse model;

  EditWorkOrderScreen({Key? key, required this.model}) : super(key: key);

  @override
  _EditWorkOrderScreenState createState() => _EditWorkOrderScreenState();
}

class _EditWorkOrderScreenState extends State<EditWorkOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();
  TextEditingController oemController = TextEditingController();
  TextEditingController complainController = TextEditingController();
  TextEditingController actionTakenController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController recAmountController = TextEditingController();
  TextEditingController conclusionController = TextEditingController();

  bool recAmoutEnable = false;
  bool amoutEnable = false;
  bool isTicketClose = false;
  late FToast fToast;
  String btnText = "Continue";
  int formStep = 1;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    setState(() {
      _isInAsyncCall = true;
    });
    loadDetails();
  }

  loadPreviousData() {}

  bool isLoading = false;
  late CallDetailsModel detailsObject;

  loadDetails() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = {'crid': widget.model.callid.toString()};
    final response = await http.post(Uri.parse(api_call_details), body: map);
    if (response.statusCode == 200 || response.statusCode == 400) {
      detailsObject = CallDetailsModel.fromJson(json.decode(response.body));
      print("response " + (jsonEncode(detailsObject)));
      partyNameController.text = detailsObject.PARTYID[0].PNAME;
      // oemController.text = detailsObject.WORKORDERID[0].OEM.isNotEmpty
      //     ? ' '
      //     : detailsObject.WORKORDERID[0].OEM;

      oemController.text =
          detailsObject.OEM.isEmpty ? ' ' : detailsObject.OEM.trim();
      print("detailsObject.OEM " + (detailsObject.OEM));
      // oemController.text ="Sach";
      complainController.text = detailsObject.COMPLAIN;

      if (detailsObject.ISCHARGABLE == 1) {
        _radioValue = 0;
        amoutEnable = true;
        recAmoutEnable = true;
      } else {
        _radioValue = 1;
        amoutEnable = false;
        recAmoutEnable = false;
      }

      setState(() {
        if (widget.model.ischargable == 1) {
          _radioValue = 0;
          amoutEnable = true;
          recAmoutEnable = true;
        } else {
          _radioValue = 1;
          amoutEnable = false;
          recAmoutEnable = false;
        }
      });
      setState(() {
        _isInAsyncCall = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

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

  var _image;

  Widget _getUI(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Work Order",
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Party Name",
                      ),
                      controller: partyNameController,
                      style: const TextStyle(fontSize: 18, fontFamily: "proxi"),
                      cursorColor: primaryColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "OEM",
                      ),
                      controller: oemController,
                      style: const TextStyle(fontSize: 18, fontFamily: "proxi"),
                      cursorColor: primaryColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Complain",
                      ),
                      controller: complainController,
                      style: const TextStyle(fontSize: 18, fontFamily: "proxi"),
                      cursorColor: primaryColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Action.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Action",
                      ),
                      controller: actionTakenController,
                      style: const TextStyle(fontSize: 18, fontFamily: "proxi"),
                      cursorColor: primaryColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Is Chargable?',
                      style: TextStyle(fontSize: 18, fontFamily: "proxi"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        const Text(
                          'Yes',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      enabled: amoutEnable,
                      decoration: const InputDecoration(
                        labelText: "Amount",
                      ),
                      controller: amountController,
                      style: const TextStyle(fontSize: 18, fontFamily: "proxi"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [DecimalTextInputFormatter()],
                      cursorColor: primaryColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      enabled: recAmoutEnable,
                      decoration: const InputDecoration(
                        labelText: "Receive Amount",
                      ),
                      controller: recAmountController,
                      style: const TextStyle(fontSize: 18, fontFamily: "proxi"),
                      inputFormatters: [DecimalTextInputFormatter()],
                      keyboardType: TextInputType.number,
                      cursorColor: primaryColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                      onEditingComplete: () {
                        print("compalte");
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Conclusion.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Conclusion',
                      ),
                      controller: conclusionController,
                      style: const TextStyle(fontSize: 18, fontFamily: "proxi"),
                      cursorColor: primaryColor,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    (formStep == 2)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                checkColor: Colors.greenAccent,
                                activeColor: Colors.red,
                                value: isTicketClose,
                                onChanged: (value) {
                                  setState(() {
                                    isTicketClose = value!;
                                    print(isTicketClose);
                                  });
                                },
                              ),
                              const Text(
                                'Ticket close',
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.black),
                              ), //Text
                            ], //<Widget>[]
                          )
                        : Container(), //Row
                    // (formStep == 2)
                    //     ? (documentUploadExt == "pdf")
                    //         ? Container(
                    //   margin: EdgeInsets.only(bottom: 10,top: 10),
                    //             child: Text(
                    //             generatedReportPDF.path,
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(fontSize: 14),
                    //           ))
                    //         : Container()
                    //     : Container(),
                    (formStep == 2)
                        ? RaisedButton(
                            child: Container(
                              alignment: Alignment.center,
                              width: getWidth(context) / 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.attach_file,
                                    color: Colors.white,
                                  ),
                                  const Text(
                                    "Upload File",
                                    style: TextStyle(
                                        fontFamily: "proxi",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              _showPicker(context);
                              // intentHelper.mobileNo =
                              //     mobileNoController.text;
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             VerificationScreen(
                              //                 intentData: intentHelper)));
                            },
                            color: secondaryColor,
                            textColor: Colors.white,
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 12, bottom: 12),
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _image != null
                            ? Image.file(
                                _image,
                                height: 200.0,
                                fit: BoxFit.contain,
                              )
                            : Container(),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Container(
                        alignment: Alignment.center,
                        width: getWidth(context),
                        child: Text(
                          btnText,
                          style: const TextStyle(
                              fontFamily: "proxi",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          if (formStep == 2) {
                            setState(() {
                              _isInAsyncCall = true;
                            });
                            _makeAPICall();
                          } else if (formStep == 1) {
                            generatePDFSample();
                          }
                        }
                      },
                      color: secondaryColor,
                      textColor: Colors.white,
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 18, bottom: 18),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }

  int _radioValue = -1;

  String selectedOption = "N";

  void _handleRadioValueChange(int? value) {
    setState(() {
      switch (value!) {
        case 0:
          selectedOption = "Y";
          break;
        case 1:
          selectedOption = "N";
          break;
      }
    });
  }

  String htmlSample = '';
  late String generatedPdfFilePath;

  generatePDFSample() async {
    //var date = new Date();
    var name = "sachin";
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var formattedDate = formatter.parse(detailsObject.TICKETDATE);

    //detailsObject.TICKETDATE
    print("DAAAA = " +
        formatter.format(formatter.parse(detailsObject.TICKETDATE)).toString());
    var _CompanyName = (detailsObject.COMPNAME.isNotEmpty)
        ? detailsObject.COMPNAME
        : 'Not Filled';
    var _PartyName = (detailsObject.PARTYID[0].PNAME.isNotEmpty)
        ? detailsObject.PARTYID[0].PNAME
        : 'Not Filled';
    var _PartyAddress = (detailsObject.PARTYID[0].ADDRESS.isNotEmpty)
        ? detailsObject.PARTYID[0].ADDRESS
        : 'Not Filled';
    var _ComplainNo = (detailsObject.TICKETNO.isNotEmpty)
        ? detailsObject.TICKETNO
        : 'Not Filled';
    var _ComplainDate = (detailsObject.TICKETDATE.isNotEmpty)
        ? detailsObject.TICKETDATE
        : 'Not Filled';
    var _ComplainType = (detailsObject.CALLDETAILS.COMPLAINTYPE.isNotEmpty)
        ? detailsObject.CALLDETAILS.COMPLAINTYPE
        : 'Not Filled';
    var _ComplainBy = (detailsObject.CALLDETAILS.COMPLAINBY.isNotEmpty)
        ? detailsObject.CALLDETAILS.COMPLAINBY
        : 'Not Filled';
    var _ComplainTakenBy = 'Not Filled';
    var _ServiceType = (detailsObject.CALLDETAILS.VISITTYPE.isNotEmpty)
        ? detailsObject.CALLDETAILS.VISITTYPE
        : 'Not Filled';
    var _ComplainDetails = (detailsObject.COMPLAIN.isNotEmpty)
        ? detailsObject.COMPLAIN
        : 'Not Filled';
    var _SerialNo = (detailsObject.WORKORDERID[0].PANELNO.isNotEmpty)
        ? detailsObject.WORKORDERID[0].PANELNO
        : 'Not Filled';
    var _ReferenceNo = (detailsObject.TICKETNO.isNotEmpty)
        ? detailsObject.TICKETNO
        : 'Not Filled';
    var _AnalysisBy = (detailsObject.CALLDETAILS.ENAME.isNotEmpty)
        ? detailsObject.CALLDETAILS.ENAME
        : 'Not Filled';
    var _AnalysisDate = (detailsObject.TICKETDATE.isNotEmpty)
        ? formatter.format(formatter.parse(detailsObject.TICKETDATE))
        : 'Not Filled';
    var _AnalysisDetails = (detailsObject.COMPLAIN.isNotEmpty)
        ? detailsObject.COMPLAIN
        : 'Not Filled';
    var _CurrentDate = formatter.format(now);
    var _ActionTaken = actionTakenController.text;
    var _Conclusions = conclusionController.text;

    htmlSample = "<html><head><title>Report</title></head><body>" +
        "<p style='text-align: center; font-weight: bold; font-size: 20px;'>" +
        _CompanyName +
        "</p>" +
        "<table width ='100%' style='border: 3px solid black;margin:auto;'><tr> <td height='100%' width='50%' style='border-right: 3px solid black;border-bottom: 3px solid black;'> <table width='100%'>" +
        "<tr> <th width ='40%'></th> <th width ='60%'></th> </tr> <tr> <td style='font-size: 12px; vertical-align: baseline;'>Party Name & Address</td> <td style='font-size: 12px; vertical-align: baseline;'>:" +
        _PartyName +
        ",<br>" +
        _PartyAddress +
        "</td> </tr> <tr> <td colspan='2'> <p style='margin-top: 40px; text-decoration: underline; font-weight: bold; color: black;'>Comaplains Details :</p> </td>" +
        "</tr> <tr> <td style='font-size: 12px; vertical-align: baseline;'>Complain No.</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _ComplainNo +
        "</td> </tr>" +
        "<tr><td style='font-size: 12px; vertical-align: baseline;'>Complaint Date</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _ComplainDate +
        "</td> </tr>" +
        "<tr> <td style='font-size: 12px; vertical-align: baseline;'>Complaint Type</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _ComplainType +
        "</td> </tr>" +
        "<tr> <td style='font-size: 12px; vertical-align: baseline;'>Complain By.</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _ComplainBy +
        "</td> </tr> <tr> <td style='font-size: 12px; vertical-align: baseline;'>Complain Taken By</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _ComplainTakenBy +
        "</td></tr>" +
        "<tr> <td style='font-size: 12px; vertical-align: baseline;'>Service Type</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _ServiceType +
        "</td> </tr>" +
        "<tr> <td style='font-size: 12px; vertical-align: baseline;'>Complain Details</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _ComplainDetails +
        "</td> </tr> " +
        "<tr> <td style='font-size: 12px; vertical-align: baseline;'>Serial No.</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _SerialNo +
        "</td> </tr> " +
        "<tr> <td style='font-size: 12px; vertical-align: baseline;'>Reference No.</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _ReferenceNo +
        "</td> </tr> </table> </td> " +
        "<td height='100%' width='50%' style='vertical-align: top;border-bottom: 3px solid black;'> <table width='100%'> <tr > <th width='40%'></th> <th width='60%'></th> </tr> <tr   style='vertical-align: top;'>" +
        "<td colspan='2' height='95px'> <p style='color: black; font-weight: bold; text-decoration: underline;'>Item Details: </p> </td> </tr> <tr> <td > <p style='color: black; font-weight: bold; text-decoration: underline;'>Analysis Details: </p> </td> </tr>" +
        " <tr> <td style='font-size: 12px; vertical-align: baseline;'>Analysis By</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _AnalysisBy +
        "</td> </tr>" +
        "<tr> <td style='font-size: 12px; vertical-align: baseline;'>Analysis Date</td> <td style='font-size: 12px; vertical-align: baseline;'>: " +
        _AnalysisDate +
        "</td> </tr>" +
        "<tr > <td style='font-size: 12px; vertical-align: baseline;'>Analysis Details</td> <td rowspan='12' valign='top' style='font-size: 12px; vertical-align: baseline;'>: " +
        _AnalysisDetails +
        "</td> </tr> <tr> <td>&nbsp;</td> </tr>" +
        "<tr> <td>&nbsp;</td> </tr> <tr> <td>&nbsp;</td> </tr> <tr> <td>&nbsp;</td> </tr> <tr> <td>&nbsp;</td> </tr> <tr> <td>&nbsp;</td> </tr> <tr> <td>&nbsp;</td> </tr> </table> </td> </tr>" +
        "<tr> <td> <table width='100%' style='border-right: 3px solid black;'><tr> <td width='40%' style='text-decoration: underline; font-weight: bold; color: black;'> Action Taken : </td> <td></td> </tr>" +
        " <tr> <td style='font-size: 12px; vertical-align: baseline;'> " +
        _CurrentDate +
        " </td> <td style='font-size: 12px; vertical-align: baseline;'> : " +
        _ActionTaken +
        "</td> </tr> </table> </td> <td> <table width='100%'> <tr> <td width='40%' style='text-decoration: underline; font-weight: bold; color: black;'> Conclusion : </td> <td></td> </tr>" +
        " <tr> <td style='font-size: 12px; vertical-align: baseline;'> " +
        _CurrentDate +
        " </td> <td style='font-size: 12px;  vertical-align: baseline;'> : " +
        _Conclusions +
        "</td> </tr> </table> </td> </tr> </table> </body> </html>";

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
        Directory appDocDir = await getApplicationDocumentsDirectory();
        final targetPath = await _setPath(); //directory.path;
        final targetFileName = "example-pdf";
        print('targetPath= ' + targetPath);

        final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
            htmlSample, targetPath, targetFileName);
        generatedPdfFilePath = generatedPdfFile.path;
        print('Success= ' + generatedPdfFilePath);
      }

      final File file = File(generatedPdfFilePath);
      Uint8List data = file.readAsBytesSync(); //Uint8List.fromList(sheets);
      MimeType type = MimeType.PDF;
      String path =
          await FileSaver.instance.saveAs("report", data, "pdf", type);
      generatedReportPDF = file;
      print(path);
      print(file.path);

      setState(() {
        formStep = 2;
        btnText = "Submit";
      });
    } catch (e) {
      print(e);
    }
  }

  String pdfBASE64 = "";

  Future<String> _setPath() async {
    Directory _path = await getApplicationDocumentsDirectory();
    String _localPath = _path.path + Platform.pathSeparator + 'Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    return _localPath;
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

  late File generatedReportPDF;
  String documentUploadExt = 'pdf';

  _makeAPICall() async {
    print("API START");
    var isDone = 0;
    if (isTicketClose) {
      isDone = 1;
    } else {
      isDone = 0;
    }

    var request =
        http.MultipartRequest('POST', Uri.parse(api_set_visit_details));

    request.fields['recAmount'] =
        recAmountController.text.isNotEmpty ? recAmountController.text : "0";
    request.fields['amount'] =
        amountController.text.isNotEmpty ? amountController.text : "0";
    request.fields['conclusion'] = conclusionController.text;
    request.fields['action'] = actionTakenController.text;
    request.fields['partyId'] = (detailsObject.PARTYID[0].PRTYID).toString();
    request.fields['workorder'] =
        detailsObject.WORKORDERID[0].WORDID.toString();
    request.fields['empId'] = (detailsObject.CALLEMP).toString();
    request.fields['isChargable'] = selectedOption;
    request.fields['callId'] = (detailsObject.CALLID).toString();
    request.fields['ext'] = documentUploadExt;
    request.fields['is_done'] = (isDone).toString();
    print(request.fields);
    if (documentUploadExt == 'pdf') {
      print("uploading pdf");
      request.files.add(await http.MultipartFile.fromPath(
          'uploads', generatedReportPDF.path));
    } else {
      print("uploading image");

      Uint8List imagebytes = await _image.readAsBytes(); //convert to bytes
      String base64string =
          base64.encode(imagebytes); //convert bytes to base64 strin
      print(base64string);
      request.fields['uploads'] = "data:image/jpeg;base64," + base64string;
    }

    var res = await request.send();
    print(res.statusCode);
    print(res.reasonPhrase);
    if (res.statusCode == 200) {
      print(res.stream);
      _showToast("Data has been added");
      Navigator.pop(context);
    } else {
      print(res);
      _showToast("There is an error");
    }
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
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            msg,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: Wrap(
                children: <Widget>[
                  // ListTile(
                  //     leading: new Icon(Icons.photo_library),
                  //     title: new Text('Use Generated Pdf'),
                  //     subtitle: Text(generatedReportPDF.path,
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //         ),
                  //         overflow: TextOverflow.ellipsis),
                  //     onTap: () {
                  //       choosePDF();
                  //       setState(() {
                  //         // uploadimage = null;
                  //         // documentUploadExt = "pdf";
                  //         // _image = null;
                  //
                  //
                  //
                  //       });
                  //
                  //       Navigator.of(context).pop();
                  //     }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Open Camera'),
                    onTap: () {
                      Navigator.of(context).pop();

                      chooseImage();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Select Gallery'),
                    onTap: () {
                      Navigator.of(context).pop();
                      getImage();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.cancel),
                    title: const Text(
                      'Cancel',
                      style: TextStyle(color: primaryColor),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  XFile? uploadimage;
  late var platformFile;

  Future<void> chooseImage() async {
    List<Media>? res = await ImagesPicker.openCamera(
      pickType: PickType.image,
      quality: 0.7
    );

    if (res != null) {
      documentUploadExt = "jpeg";
      _image = File(res[0].path);
      setState(() {});
    }
    //
    // final ImagePicker _picker = ImagePicker();
    // var choosedimage = await _picker.pickImage(source: ImageSource.camera);
    // if (choosedimage != null) {
    //   setState(() {
    //     uploadimage = choosedimage;
    //     documentUploadExt = "jpeg";
    //     _image = File(choosedimage.path);
    //   });
    // }
  }

  Future getImage() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      quality: 0.7
    );
    if (res != null) {
      documentUploadExt = "jpeg";
      _image = File(res[0].path);
      setState(() {});
    }
  }

  selectFromGalleryImage() async {
    return;

    try {
      var choosedimage = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (choosedimage == null) return;

      documentUploadExt = "jpeg";
      _image = File(choosedimage.path);
      uploadimage = choosedimage;
      setState(() {});
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  choosePDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) {
      return;
    }
    // if user don't pick any thing then do nothing just return.
    platformFile = result.files.first;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d+\.?\d{0,2}');
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}
