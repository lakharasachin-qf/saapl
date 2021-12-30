class CallDetailsModel {
  CallDetailsModel({
    required this.CALLID,
    required this.CALLDETAILS,
    required this.TICKETNO,
    required this.TICKETDATE,
    required this.WORKORDERID,
    required this.PARTYID,
    required this.MACHID,
    required this.COMPLAIN,
    required this.COMPLAINBY,
    required this.INWARRANTY,
    required this.CALLEMP,
    required this.VISITTYPE,
    required this.ISCHARGABLE,
    required this.COMPID,
    required this.COMPNAME,
    required this.ACCYEAR,
  });

  late final int CALLID;
  late final CALLDETAILSModel CALLDETAILS;
  late final String TICKETNO;
  late final String TICKETDATE;
  late final List<WORKORDERIDModel> WORKORDERID;
  late final List<PARTYIDModel> PARTYID;
  late final int MACHID;
  late final String COMPLAIN;
  late final String COMPLAINBY;
  late final int INWARRANTY;
  late final int CALLEMP;
  late final String VISITTYPE;
  late final int ISCHARGABLE;
  late final int COMPID;
  late final String COMPNAME;
  late final int ACCYEAR;

  CallDetailsModel.fromJson(Map<String, dynamic> json) {
    CALLID = json['CALLID'];
    CALLDETAILS = CALLDETAILSModel.fromJson(json['CALL_DETAILS']);
    TICKETNO = json['TICKETNO'];
    TICKETDATE = json['TICKETDATE'];
    WORKORDERID = List.from(json['WORKORDERID'])
        .map((e) => WORKORDERIDModel.fromJson(e))
        .toList();
    PARTYID = List.from(json['PARTYID'])
        .map((e) => PARTYIDModel.fromJson(e))
        .toList();
    MACHID = json['MACHID'];
    COMPLAIN = json['COMPLAIN'];
    COMPLAINBY = json['COMPLAIN_BY'];
    INWARRANTY = json['INWARRANTY'];
    CALLEMP = json['CALLEMP'];
    VISITTYPE = json['VISITTYPE'];
    ISCHARGABLE = json['ISCHARGABLE'];
    COMPID = json['COMPID'];
    COMPNAME = json['COMPNAME'];
    ACCYEAR = json['ACCYEAR'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['CALLID'] = CALLID;
    _data['CALL_DETAILS'] = CALLDETAILS.toJson();
    _data['TICKETNO'] = TICKETNO;
    _data['TICKETDATE'] = TICKETDATE;
    _data['WORKORDERID'] = WORKORDERID.map((e) => e.toJson()).toList();
    _data['PARTYID'] = PARTYID.map((e) => e.toJson()).toList();
    _data['MACHID'] = MACHID;
    _data['COMPLAIN'] = COMPLAIN;
    _data['COMPLAIN_BY'] = COMPLAINBY;
    _data['INWARRANTY'] = INWARRANTY;
    _data['CALLEMP'] = CALLEMP;
    _data['VISITTYPE'] = VISITTYPE;
    _data['ISCHARGABLE'] = ISCHARGABLE;
    _data['COMPID'] = COMPID;
    _data['COMPNAME'] = COMPNAME;
    _data['ACCYEAR'] = ACCYEAR;
    return _data;
  }
}

class CALLDETAILSModel {
  CALLDETAILSModel({
    required this.CALLID,
    required this.TICKETNO,
    required this.TICKETDATE,
    required this.WORKORDERID,
    required this.PARTYID,
    required this.MACHID,
    required this.COMPLAIN,
    required this.INWARRANTY,
    required this.CALLEMP,
    required this.VISITTYPE,
    required this.ISCHARGABLE,
    required this.COMPID,
    required this.ACCYEAR,
    required this.COMPLAINBY,
    required this.COMPLAINTYPE,
    required this.ISCLOSED,
    required this.COMPANY,
    required this.ENAME,
  });

  late final int CALLID;
  late final String TICKETNO;
  late final String TICKETDATE;
  late final int WORKORDERID;
  late final int PARTYID;
  late final int MACHID;
  late final String COMPLAIN;
  late final int INWARRANTY;
  late final int CALLEMP;
  late final String VISITTYPE;
  late final int ISCHARGABLE;
  late final int COMPID;
  late final int ACCYEAR;
  late final String COMPLAINBY;
  late final String COMPLAINTYPE;
  late final int ISCLOSED;
  late final String COMPANY;
  late final String ENAME;

  CALLDETAILSModel.fromJson(Map<String, dynamic> json) {
    CALLID = json['CALLID'];
    TICKETNO = json['TICKETNO'];
    TICKETDATE = json['TICKETDATE'];
    WORKORDERID = json['WORKORDERID'];
    PARTYID = json['PARTYID'];
    MACHID = json['MACHID'];
    COMPLAIN = json['COMPLAIN'];
    INWARRANTY = json['INWARRANTY'];
    CALLEMP = json['CALLEMP'];
    VISITTYPE = json['VISITTYPE'];
    ISCHARGABLE = json['ISCHARGABLE'];
    COMPID = json['COMPID'];
    ACCYEAR = json['ACCYEAR'];
    COMPLAINBY = json['COMPLAIN_BY'];
    COMPLAINTYPE = json['COMPLAIN_TYPE'];
    ISCLOSED = json['ISCLOSED'];
    COMPANY = json['COMPANY'];
    ENAME = json['ENAME'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['CALLID'] = CALLID;
    _data['TICKETNO'] = TICKETNO;
    _data['TICKETDATE'] = TICKETDATE;
    _data['WORKORDERID'] = WORKORDERID;
    _data['PARTYID'] = PARTYID;
    _data['MACHID'] = MACHID;
    _data['COMPLAIN'] = COMPLAIN;
    _data['INWARRANTY'] = INWARRANTY;
    _data['CALLEMP'] = CALLEMP;
    _data['VISITTYPE'] = VISITTYPE;
    _data['ISCHARGABLE'] = ISCHARGABLE;
    _data['COMPID'] = COMPID;
    _data['ACCYEAR'] = ACCYEAR;
    _data['COMPLAIN_BY'] = COMPLAINBY;
    _data['COMPLAIN_TYPE'] = COMPLAINTYPE;
    _data['ISCLOSED'] = ISCLOSED;
    _data['COMPANY'] = COMPANY;
    _data['ENAME'] = ENAME;
    return _data;
  }
}

class WORKORDERIDModel {
  WORKORDERIDModel({
    required this.WORDID,
    required this.WONO,
    required this.WODATE,
    required this.PANELNO,
    required this.VISITPLACE,
    required this.VISITGRADE,
    required this.PRTYID,
    required this.MACHCOMPID,
    required this.OEM,
    required this.DESC1,
    required this.VNO,
    required this.VDATE,
    required this.DESPDATE,
    required this.TYPEOFSALE,
    required this.WARRPERIOD,
    required this.ERRCOMDATE,
    required this.ERRCOMBY,
    required this.FINERRDATE,
    required this.FINALREEBY,
    required this.COMPID,
    required this.RESPOSIBLEPERSON,
    required this.MACHCOMP,
  });

  late final int WORDID;
  late final String WONO;
  late final String WODATE;
  late final String PANELNO;
  late final String VISITPLACE;
  late final String VISITGRADE;
  late final int PRTYID;
  late final int MACHCOMPID;
  late final String OEM;
  late final String DESC1;
  late final String VNO;
  late final String VDATE;
  late final String DESPDATE;
  late final String TYPEOFSALE;
  late final String WARRPERIOD;
  late final String ERRCOMDATE;
  late final String ERRCOMBY;
  late final String FINERRDATE;
  late final String FINALREEBY;
  late final int COMPID;
  late final String RESPOSIBLEPERSON;
  late final String MACHCOMP;

  WORKORDERIDModel.fromJson(Map<String, dynamic> json) {
    WORDID = json['WORDID'];
    WONO = json['WONO'];
    WODATE = json['WODATE'];
    PANELNO = json['PANELNO'];
    VISITPLACE = json['VISITPLACE'];
    VISITGRADE = json['VISITGRADE'];
    PRTYID = json['PRTYID'];
    MACHCOMPID = json['MACHCOMPID'];
    OEM = json['OEM'] ?? '';
    DESC1 = json['DESC1'];
    VNO = json['VNO'];
    VDATE = json['VDATE'];
    DESPDATE = json['DESPDATE'] ?? '';
    TYPEOFSALE = json['TYPEOFSALE'] ?? '';
    WARRPERIOD = json['WARRPERIOD'] ?? '';
    ERRCOMDATE = json['ERRCOMDATE'] ?? '';
    ERRCOMBY = json['ERRCOMBY'] ?? '';
    FINERRDATE = json['FINERRDATE'] ?? '';
    FINALREEBY = json['FINALREEBY'] ?? '';
    COMPID = json['COMPID'];
    RESPOSIBLEPERSON = json['RESPOSIBLEPERSON'] ?? '';
    MACHCOMP = json['MACHCOMP'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['WORDID'] = WORDID;
    _data['WONO'] = WONO;
    _data['WODATE'] = WODATE;
    _data['PANELNO'] = PANELNO;
    _data['VISITPLACE'] = VISITPLACE;
    _data['VISITGRADE'] = VISITGRADE;
    _data['PRTYID'] = PRTYID;
    _data['MACHCOMPID'] = MACHCOMPID;
    _data['OEM'] = OEM;
    _data['DESC1'] = DESC1;
    _data['VNO'] = VNO;
    _data['VDATE'] = VDATE;
    _data['DESPDATE'] = DESPDATE;
    _data['TYPEOFSALE'] = TYPEOFSALE;
    _data['WARRPERIOD'] = WARRPERIOD;
    _data['ERRCOMDATE'] = ERRCOMDATE;
    _data['ERRCOMBY'] = ERRCOMBY;
    _data['FINERRDATE'] = FINERRDATE;
    _data['FINALREEBY'] = FINALREEBY;
    _data['COMPID'] = COMPID;
    _data['RESPOSIBLEPERSON'] = RESPOSIBLEPERSON;
    _data['MACHCOMP'] = MACHCOMP;
    return _data;
  }
}

class PARTYIDModel {
  PARTYIDModel({
    required this.PRTYID,
    required this.PNAME,
    required this.CONTACT,
    required this.MAILID,
    required this.PROFILE,
    required this.ADDRESS,
    required this.COMPID,
    required this.CREATEDAT,
    required this.UPDATEDAT,
    required this.ADDEDBY,
    required this.CONTACTPERSON,
  });

  late final int PRTYID;
  late final String PNAME;
  late final String CONTACT;
  late final String MAILID;
  late final String PROFILE;
  late final String ADDRESS;
  late final String COMPID;
  late final String CREATEDAT;
  late final String UPDATEDAT;
  late final String ADDEDBY;
  late final String CONTACTPERSON;

  PARTYIDModel.fromJson(Map<String, dynamic> json) {
    PRTYID = json['PRTYID'];
    PNAME = json['PNAME'];
    CONTACT = json['CONTACT'] ?? '';
    MAILID = json['MAILID'] ?? '';
    PROFILE = json['PROFILE'] ?? '';
    ADDRESS = json['ADDRESS'] ?? '';
    COMPID = json['COMPID'] ?? '';
    CREATEDAT = json['CREATEDAT'] ?? '';
    UPDATEDAT = json['UPDATEDAT'] ?? '';
    ADDEDBY = json['ADDEDBY'] ?? '';
    CONTACTPERSON = json['CONTACTPERSON'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['PRTYID'] = PRTYID;
    _data['PNAME'] = PNAME;
    _data['CONTACT'] = CONTACT;
    _data['MAILID'] = MAILID;
    _data['PROFILE'] = PROFILE;
    _data['ADDRESS'] = ADDRESS;
    _data['COMPID'] = COMPID;
    _data['CREATEDAT'] = CREATEDAT;
    _data['UPDATEDAT'] = UPDATEDAT;
    _data['ADDEDBY'] = ADDEDBY;
    _data['CONTACTPERSON'] = CONTACTPERSON;
    return _data;
  }
}
