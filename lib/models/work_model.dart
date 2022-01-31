// To parse this JSON data, do
//
//     final workOrderResponse = workOrderResponseFromJson(jsonString);

import 'dart:convert';



class WorkOrderAPIResponse {
  WorkOrderAPIResponse({
    required this.data,
  });

  late final WorkOrderResponse data;

  WorkOrderAPIResponse.fromJson(Map<String, dynamic> json) {
    data= (json['data'] == null ? null : WorkOrderResponse.fromJson(json['data']))!;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    return _data;
  }
}


 List<WorkOrderResponse> workOrderResponseFromJson(String str) =>
    List<WorkOrderResponse>.from(
        json.decode(str).map((x) => WorkOrderResponse.fromJson(x)));

String workOrderResponseToJson(List<WorkOrderResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkOrderResponse {

  WorkOrderResponse({
    required this.callid,
    required this.ticketno,
    required this.ticketdate,
    required this.workorderid,
    required this.partyid,
    required this.machid,
    required this.complain,
    required this.inwarranty,
    required this.callemp,
    required this.callempname,
    required this.visittype,
    required this.ischargable,
    required this.compid,
    required this.compname,
    required this.accyear,
  });

  int callid;
  String ticketno;
  DateTime ticketdate;
  List<Workorderid> workorderid;
  List<Partyid> partyid;
  int machid;
  String complain;
  int inwarranty;
  int callemp;
  String callempname;
  String visittype;
  int ischargable;
  int compid;
  String compname;
  int accyear;

  factory WorkOrderResponse.fromJson(Map<String, dynamic> json) =>

      WorkOrderResponse(
        callid: (json["CALLID"] == null) ? 0 :  json["CALLID"],
        ticketno: json["TICKETNO"]?? '',
        ticketdate: DateTime.parse(json["TICKETDATE"]),
        workorderid: List<Workorderid>.from(
            json["WORKORDERID"].map((x) => Workorderid.fromJson(x))),
        partyid:
            List<Partyid>.from(json["PARTYID"].map((x) => Partyid.fromJson(x))),

        machid: (json["MACHID"] == null) ? 0 : json["MACHID"],
        complain:  (json["COMPLAIN"] == null) ? "" : json["COMPLAIN"],
        inwarranty:  (json["INWARRANTY"] == null) ? 0 : json["INWARRANTY"],
        callemp:(json["CALLEMP"] == null) ? 0 : json["CALLEMP"],
        callempname: json["CALLEMPNAME"]?? '',
        visittype: json["VISITTYPE"]?? '',
        ischargable:(json["ISCHARGABLE"] == null) ? 0 : json["ISCHARGABLE"],
        compid: (json["COMPID"] == null) ? 0 :json["COMPID"],
        compname: json["COMPNAME"]?? '',
        accyear:(json["ACCYEAR"] == null) ? 0 : json["ACCYEAR"],
      );

  Map<String, dynamic> toJson() => {
        "CALLID": callid,
        "TICKETNO": ticketno,
        "TICKETDATE": ticketdate.toIso8601String(),
        "WORKORDERID": List<dynamic>.from(workorderid.map((x) => x.toJson())),
        "PARTYID": List<dynamic>.from(partyid.map((x) => x.toJson())),
        "MACHID": machid,
        "COMPLAIN": complain,
        "INWARRANTY": inwarranty,
        "CALLEMP": callemp,
        "CALLEMPNAME": callempname,
        "VISITTYPE": visittype,
        "ISCHARGABLE": ischargable,
        "COMPID": compid,
        "COMPNAME": compname,
        "ACCYEAR": accyear,
      };
}

class Partyid {
  Partyid({
    required this.prtyid,
    required this.pname,
    required this.contact,
    required this.mailid,
    required this.profile,
    required this.address,
    required this.compid,
    required this.createdat,
    required this.updatedat,
    required this.addedby,
    required this.contactperson,
  });

  int prtyid;
  String pname;
  dynamic contact;
  dynamic mailid;
  dynamic profile;
  dynamic address;
  dynamic compid;
  dynamic createdat;
  dynamic updatedat;
  dynamic addedby;
  dynamic contactperson;

  factory Partyid.fromJson(Map<String, dynamic> json) => Partyid(
        prtyid:  (json["PRTYID"] == null) ? 0 :json["PRTYID"],
        pname: json["PNAME"]?? '',
        contact: json["CONTACT"]?? '',
        mailid: json["MAILID"]?? '',
        profile: json["PROFILE"]?? '',
        address: json["ADDRESS"]?? '',
        compid: json["COMPID"]?? '',
        createdat: json["CREATEDAT"]?? '',
        updatedat: json["UPDATEDAT"]?? '',
        addedby: json["ADDEDBY"]?? '',
        contactperson: json["CONTACTPERSON"]?? '',
      );

  Map<String, dynamic> toJson() => {
        "PRTYID": prtyid,
        "PNAME": pname,
        "CONTACT": contact,
        "MAILID": mailid,
        "PROFILE": profile,
        "ADDRESS": address,
        "COMPID": compid,
        "CREATEDAT": createdat,
        "UPDATEDAT": updatedat,
        "ADDEDBY": addedby,
        "CONTACTPERSON": contactperson,
      };
}

class Workorderid {
  Workorderid({
    required this.wordid,
    required this.wono,
    required this.wodate,
    required this.panelno,
    required this.visitplace,
    required this.visitgrade,
    required this.prtyid,
    required this.machcompid,
    required this.oem,
    required this.desc1,
    required this.vno,
    required this.vdate,
    required this.despdate,
    required this.typeofsale,
    required this.warrperiod,
    required this.errcomdate,
    required this.errcomby,
    required this.finerrdate,
    required this.finalreeby,
    required this.compid,
    required this.resposibleperson,
    required this.machcomp,
  });

  int wordid;
  String wono;
  DateTime wodate;
  String panelno;
  String visitplace;
  String visitgrade;
  int prtyid;
  int machcompid;
  dynamic oem;
  String desc1;
  String vno;
  DateTime vdate;
  dynamic despdate;
  dynamic typeofsale;
  dynamic warrperiod;
  dynamic errcomdate;
  dynamic errcomby;
  dynamic finerrdate;
  dynamic finalreeby;
  int compid;
  dynamic resposibleperson;
  String machcomp;

  factory Workorderid.fromJson(Map<String, dynamic> json) => Workorderid(
        wordid: (json["WORDID"] == null) ? 0 : json["WORDID"],
        wono: json["WONO"]?? '',
        wodate: DateTime.parse(json["WODATE"]),
        panelno: json["PANELNO"]?? '',
        visitplace: json["VISITPLACE"]?? '',
        visitgrade: json["VISITGRADE"]?? '',
        prtyid:(json["PRTYID"] == null) ? 0 :  json["PRTYID"],
        machcompid:(json["MACHCOMPID"] == null) ? 0 :  json["MACHCOMPID"],
        oem: json["OEM"]?? '',
        desc1: json["DESC1"]?? '',
        vno: json["VNO"]?? '',
        vdate: DateTime.parse(json["VDATE"]),
        despdate: json["DESPDATE"]?? '',
        typeofsale: json["TYPEOFSALE"]?? '',
        warrperiod: json["WARRPERIOD"]?? '',
        errcomdate: json["ERRCOMDATE"]?? '',
        errcomby: json["ERRCOMBY"]?? '',
        finerrdate: json["FINERRDATE"]?? '',
        finalreeby: json["FINALREEBY"]?? '',
        compid:(json["COMPID"] == null) ? 0 :  json["COMPID"],
        resposibleperson: json["RESPOSIBLEPERSON"],
        machcomp: json["MACHCOMP"]?? '',
      );

  Map<String, dynamic> toJson() => {
        "WORDID": wordid,
        "WONO": wono,
        "WODATE": wodate.toIso8601String(),
        "PANELNO": panelno,
        "VISITPLACE": visitplace,
        "VISITGRADE": visitgrade,
        "PRTYID": prtyid,
        "MACHCOMPID": machcompid,
        "OEM": oem,
        "DESC1": desc1,
        "VNO": vno,
        "VDATE": vdate.toIso8601String(),
        "DESPDATE": despdate,
        "TYPEOFSALE": typeofsale,
        "WARRPERIOD": warrperiod,
        "ERRCOMDATE": errcomdate,
        "ERRCOMBY": errcomby,
        "FINERRDATE": finerrdate,
        "FINALREEBY": finalreeby,
        "COMPID": compid,
        "RESPOSIBLEPERSON": resposibleperson,
        "MACHCOMP": machcomp,
      };
}
