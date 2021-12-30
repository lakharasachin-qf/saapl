import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saapl/models/intent_helper.dart';
import 'package:velocity_x/velocity_x.dart';

import '../colors.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  TextEditingController mobileNoController = TextEditingController();
  var intentHelper = IntentHelper();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              //child: Image.asset('assets/temp.jpg')
               child:  SvgPicture.asset(
                "assets/bg_login_top.svg",
                alignment: Alignment.centerRight ,
                fit: BoxFit.contain,
                height: 450,
              ),
              color: Colors.black12,
            ),

            Container(
                constraints: const BoxConstraints.expand(),
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20.0, 150, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          style:
                          const TextStyle(fontSize: 40.0, fontFamily: "proxi"),
                          children: [
                            TextSpan(
                                text: "Sign ",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontFamily: "proxi",
                                    fontWeight: FontWeight.w900)),
                            TextSpan(
                                text: "In",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontFamily: "proxi",
                                    fontWeight: FontWeight.w800))
                          ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "A perfact approach for creating Innovative, \nand trendy branding images.",
                      style: TextStyle(fontSize: 15, fontFamily: "proxi"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Mobile No"
                                .text
                                .semiBold
                                .fontFamily("proxi")
                                .color(Colors.black54)
                                .make(),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 55,
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 0,
                                ),
                                child: TextFormField(
                                  controller: mobileNoController,
                                  style:
                                  TextStyle(fontSize: 17, fontFamily: "proxi"),
                                  keyboardType: TextInputType.number,
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      borderSide: const BorderSide(
                                        color: secondaryColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    prefix: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        "(+91)",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontFamily: "proxi"),
                                      ),
                                    ),
                                    hintText: 'Mobile No',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Mobile no can't be empty";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    name = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1.0),
                              child: ButtonBar(
                                alignment: MainAxisAlignment.end,
                                buttonPadding: EdgeInsets.zero,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        // intentHelper.mobileNo =
                                        //     mobileNoController.text;
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             VerificationScreen(
                                        //                 intentData: intentHelper)));
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryColor),
                                          textStyle: MaterialStateProperty.all(
                                              const TextStyle(
                                                  fontFamily: "proxi",
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          shape: MaterialStateProperty.all(
                                            const StadiumBorder(),
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          "Sign In".text.make(),
                                          SvgPicture.asset(
                                            "assets/right_arrow.svg",
                                            height: 30,
                                            width: 30,
                                            color: Colors.white,
                                          )
                                        ],
                                      )).wh(120, 45)
                                ],
                              ).py64(),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      )
    ]);
  }
}
