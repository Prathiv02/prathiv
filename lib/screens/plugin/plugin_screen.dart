import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prathivexample/database/sp_util.dart';
import 'package:prathivexample/main.dart';
import 'package:prathivexample/provider/login_provider.dart';
import 'package:prathivexample/screens/login/login_screen.dart';
import 'package:prathivexample/screens/plugin/widget/last_login_display_widget.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class PluginScreen extends StatefulWidget {
  static const routeName = "/PluginScreen";

  const PluginScreen({Key? key}) : super(key: key);

  @override
  State<PluginScreen> createState() => _PluginScreenState();
}

class _PluginScreenState extends State<PluginScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    if (sp.getBool(SpUtil.gotLoginData) != null) {
      if (!(sp.getBool(SpUtil.gotLoginData)!)) {
        generateRandomNumber();
        Provider.of<LoginProvider>(context, listen: false)
            .getUserLocationAndIp(context: context);
      }
    } else {
      generateRandomNumber();
      Provider.of<LoginProvider>(context, listen: false)
          .getUserLocationAndIp(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar();
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: const Color(0xff2f2b62),
      body: Column(
        children: [
          SizedBox(
              height: appBar.preferredSize.height + statusBarHeight + 10,
              child: Padding(
                padding: EdgeInsets.only(top: statusBarHeight, right: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    child: const Text("Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                    onPressed: () {
                      sp.clear();
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName, (route) => false);
                    },
                  ),
                ),
              )),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xff000000),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        top: -15,
                        child: Container(
                          width: 100,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Color.fromRGBO(69, 155, 241, 1)),
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "PLUGIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 23, color: Colors.white),
                          ),
                        )),
                    Positioned(
                      top: 220,
                      child: Container(
                        height: 150,
                        width: 300,
                        color: const Color.fromRGBO(89, 88, 87, .3),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              left: -5,
                              child: Transform.rotate(
                                angle: pi / 6,
                                child: Container(
                                  height: 160,
                                  width: 600,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xff2f2b62),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 5,
                            child: Screenshot(
                              controller: screenshotController,
                              child: QrImage(
                                data: sp.getString(SpUtil.generatedNumber),
                                size: 150,
                                padding: const EdgeInsets.all(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text("Generated Number",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          const SizedBox(height: 25),
                          Text(sp.getString(SpUtil.generatedNumber),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20)),
                        ],
                      ),
                    ),
                    LastLoginDisplayWidget(
                        screenshotController: screenshotController),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  void generateRandomNumber() {
    String randomNumber = "";
    Random rnd = Random();
    for (var i = 0; i < 5; i++) {
      randomNumber = randomNumber + rnd.nextInt(9).toString();
    }
    sp.putString(SpUtil.generatedNumber, randomNumber);
  }
}
