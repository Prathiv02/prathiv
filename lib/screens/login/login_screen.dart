import 'package:flutter/material.dart';
import 'package:prathivexample/provider/login_provider.dart';
import 'package:prathivexample/utils/progress_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar();
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    InputDecoration inputDecoration = InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        border: InputBorder.none,
        fillColor: const Color(0xff2f2b62),
        filled: true);
    return Scaffold(
      backgroundColor: const Color(0xff2f2b62),
      body: Column(
        children: [
          SizedBox(height: appBar.preferredSize.height + statusBarHeight + 10),
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
                            "LOGIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )),
                    Align(
                        alignment: AlignmentDirectional.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Phone number",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              const SizedBox(height: 10),
                              TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: phoneNumberController,
                                decoration: inputDecoration,
                              ),
                              const SizedBox(height: 30),
                              const Text("OTP",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              const SizedBox(height: 10),
                              TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: otpController,
                                decoration: inputDecoration,
                              ),
                              const SizedBox(height: 50),
                              Consumer<LoginProvider>(
                                builder: (BuildContext context, loginProvider,
                                    Widget? child) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: const Color.fromRGBO(
                                                89, 88, 87, .6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        onPressed: () {
                                          if (loginProvider.otpSent) {
                                            if (otpController.text.length !=
                                                6) {
                                              ProgressUtils.toast(
                                                  msg: "OTP Should be 6 digit");
                                            } else {
                                              loginProvider.loginUser(
                                                  otp: otpController.text,
                                                  context: context);
                                            }
                                          } else {
                                            if (phoneNumberController
                                                    .text.length !=
                                                10) {
                                              ProgressUtils.toast(
                                                  msg:
                                                      "Phone Number Should be 10 digit");
                                            } else {
                                              loginProvider.verifyUser(
                                                  number: phoneNumberController
                                                      .text,
                                                  context: context);
                                            }
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            loginProvider.otpSent
                                                ? "LOGIN"
                                                : "SEND OTP",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                        )),
                                  );
                                },
                              )
                            ],
                          ),
                        )),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}