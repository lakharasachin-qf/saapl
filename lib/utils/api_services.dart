import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:saapl/models/login_model.dart';
import 'package:saapl/models/work_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apis_collection.dart';

class APIService {
  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("isLogin") == true) {
      String? token = preferences.getString("token");
      if (token != null) {
        return token;
      }
    }
    return "";
  }

  Future<WorkOrderResponse> getWorkOrderList() async {
    Map<String, String> header = {};
    header["Accept"] = "application/x-www-form-urlencoded";
    header["Content-Type"] = "application/x-www-form-urlencoded";
    String tokens = await getToken();
    if (tokens.isNotEmpty) {
      header["X-Authorization"] = "Bearer " + tokens;
    }
    final response = await http.post(Uri.parse(api_login), headers: header);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print("response " + (response.body));
      var dataComment = {'data': json.decode(response.body)};

      return WorkOrderAPIResponse.fromJson(
              json.decode(json.encode(dataComment)))
          .data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<WorkOrderResponse> getWorkOrder(Map<String, dynamic> bodyData) async {
    Map<String, String> header = {};
    header["Accept"] = "application/x-www-form-urlencoded";
    header["Content-Type"] = "application/x-www-form-urlencoded";
    String tokens = await getToken();
    if (tokens.isNotEmpty) {
      header["X-Authorization"] = "Bearer " + tokens;
    }
    final response = await http.post(Uri.parse(getBrandCategories),
        headers: header, body: bodyData);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print("response " + (response.body));

      List<dynamic> list = json.decode(response.body);

      return WorkOrderAPIResponse.fromJson(json.decode(json.encode(""))).data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<LoginResponseModel> login(
      String userName, String password, String deviceToken) async {
    print("userName = " + userName);
    print("password = " + password);
    print("deviceToken = " + deviceToken);
    Map<String, dynamic> map = {
      'username': userName,
      'password': password,
      'deviceToken': deviceToken
    };

    final response = await http.post(Uri.parse(api_login), body: map);
    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print(response.body);
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
