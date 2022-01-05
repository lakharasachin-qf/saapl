const String _base = "http://43.242.122.50:8080/saapl/";
const String api_login = _base + "getLogin";
const String api_work_order_list = _base + "callRegiByEmp";
const String api_call_details = _base + "getCallDetails";
const String api_set_visit_details = _base + "setVisitDetails";
const String getBrandCategories = "http://queryfinders.com/brandmania/public/api/getBrandCategory";
const String api_oem_list = _base+"getOemList";
const String api_employee_list = _base+"getEmployeeList";
const String api_party_list = _base+"getPartyList";
const String api_visit_type_list = _base+"getVisitType";
const String api_add_qwt = _base+"addQwtData";
const String api_in_out_data = _base+"addInOutData";


/*
*
* http://43.242.122.50:8080/saapl/getOemList
http://43.242.122.50:8080/saapl/getEmployeeList
http://43.242.122.50:8080/saapl/getPartyList
http://43.242.122.50:8080/saapl/getVisitType

http://43.242.122.50:8080/saapl/addQwtData

parameters
oemId:2
partyId:3
empId:111
visitType: I
woNo:123
enterBy:dhaval
remark:test

http://43.242.122.50:8080/saapl/addInOutData

parameters
empId:111
inout: I
location:test
*
*
* */
