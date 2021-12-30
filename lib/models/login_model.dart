class LoginResponseModel {
  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  late final int status;
  late final String message;
  late final Data data;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if(json['data']!=null) {
      data= (Data.fromJson(json['data']));
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
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
