import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:saapl/models/event_model.dart';

import '../colors.dart';
import 'package:get/get.dart';

class EventDetails extends StatefulWidget {
  EventModel model;
  EventDetails(this.model, {Key? key}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String date = "2022-12-05 12:00:00";
    String date2 = "2022-12-08 12:00:00";
    var data1 = DateTime.parse(date);
    var data2 = DateTime.parse(date2);
    print(data2.compareTo(data1));
  }

  @override
  Widget build(BuildContext context) {
    return _getUI(context);
  }

  Widget _getUI(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: Text(
          "Event Detail",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "proxi",
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
              ),
              Text(
                "Event",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "proxi",
                ),
              ),
              Text(
                widget.model.title.capitalizeFirst.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "proxi-bold",
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 20,
              ),
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "proxi",
                ),
              ),
              Text(
                widget.model.description,
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "proxi",
                    color: Colors.black.withOpacity(0.9)),
              ),
              Container(
                height: 20,
              ),
              Text(
                "Event Date",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "proxi",
                ),
              ),
              Text(
                widget.model.dateofevent,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: "proxi",
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
