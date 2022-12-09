import 'dart:convert';

List<EventModel> eventModelFromJson(String str) =>
    List<EventModel>.from(json.decode(str).map((x) => EventModel.fromJson(x)));

String eventModelToJson(List<EventModel> data) =>
    json.encode(List<EventModel>.from(data.map((x) => x.toJson())));

class EventModel {
  EventModel({
    required this.eventid,
    required this.title,
    required this.description,
    required this.meetinglocation,
    required this.dateofevent,
    required this.compid,
  });

  int eventid;
  String title;
  String description;
  String meetinglocation;
  String dateofevent;
  String compid;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        eventid: json["EVENTID"] ?? '',
        title: json["TITLE"] ?? '',
        description: json["DESCRIPTION"] ?? '',
        meetinglocation: json["MEETINGLOCATION"] ?? '',
        dateofevent: json["DATEOFEVENT"] ?? '',
        compid: json["COMPID"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "EVENTID": eventid == null ? null : eventid,
        "TITLE": title == null ? null : title,
        "DESCRIPTION": description == null ? null : description,
        "MEETINGLOCATION": meetinglocation == null ? null : meetinglocation,
        "DATEOFEVENT": dateofevent,
        "COMPID": compid,
      };
}
