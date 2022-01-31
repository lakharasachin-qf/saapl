class LoginResponseModel {
  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
    required this.ioStatus,
  });

  late final int status;
  late final String message;
  late final Data data;
  late final IOStatus ioStatus;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if(json['data']!=null) {
      data= (Data.fromJson(json['data']));
    }  if(json['IOstatus']!=null) {
      ioStatus= (IOStatus.fromJson(json['IOstatus']));
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    _data['IOstatus'] = ioStatus.toJson();
    return _data;
  }
}
class IOStatus{
  late final String IODATETIME;
  late final String INOUT;
  IOStatus({
    required this.IODATETIME,
    required this.INOUT
  });
  IOStatus.fromJson(Map<String, dynamic> json) {
    IODATETIME = json['IODATETIME'];
    INOUT = json['INOUT'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['INOUT'] = INOUT;
    _data['IODATETIME'] = IODATETIME;
    return _data;
  }
}
class Data {
  Data({
    required this.userId,
    required this.userName,
    required this.userCode,
    required this.empId,
    required this.role,
  });

  late final int userId;
  late final String userName;
  late final String userCode;
  late final int empId;
  late final String role;

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userCode = json['user_code'];
    empId = json['emp_id'];
    role = json['role'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['user_name'] = userName;
    _data['user_code'] = userCode;
    _data['emp_id'] = empId;
    _data['role'] = role;
    return _data;
  }
}
