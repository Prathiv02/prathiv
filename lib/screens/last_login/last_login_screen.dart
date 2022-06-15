import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prathivexample/screens/last_login/widgets/other_tab_widget.dart';
import 'package:prathivexample/screens/last_login/widgets/today_tab_widget.dart';
import 'package:prathivexample/screens/last_login/widgets/yesterday_tab_widget.dart';

import '../../main.dart';
import '../login/login_screen.dart';

class LastLoginScreen extends StatefulWidget {
  static const routeName = "/LastLoginScreen";

  const LastLoginScreen({Key? key}) : super(key: key);

  @override
  State<LastLoginScreen> createState() => _LastLoginScreenState();
}

class _LastLoginScreenState extends State<LastLoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white)),
                    TextButton(
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
                    )
                  ],
                ),
              )),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xff131212),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          child: const Text(
                            "Last Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 50, bottom: 30, right: 30, left: 30),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: TabBar(
                                  controller: controller,
                                  isScrollable: true,
                                  indicator: const UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.white),
                                      insets:
                                          EdgeInsets.symmetric(horizontal: 15)),
                                  tabs: const [
                                    Text("TODAY"),
                                    Text("Yesterday"),
                                    Text("Other"),
                                  ]),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: controller,
                                children: const [
                                  TodayTabWidget(),
                                  YesterdayTabWidget(),
                                  OtherTabWidget()
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          const Color.fromRGBO(89, 88, 87, .6),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      "SAVE",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 20)
                          ],
                        ))
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
