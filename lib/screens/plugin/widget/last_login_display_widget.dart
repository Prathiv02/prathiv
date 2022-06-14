import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prathivexample/database/api_service.dart';
import 'package:prathivexample/database/sp_util.dart';
import 'package:prathivexample/main.dart';
import 'package:prathivexample/screens/last_login/last_login_screen.dart';
import 'package:prathivexample/utils/progress_utils.dart';
import 'package:screenshot/screenshot.dart';

class LastLoginDisplayWidget extends StatelessWidget {
  final ScreenshotController screenshotController;

  const LastLoginDisplayWidget({Key? key, required this.screenshotController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            StreamBuilder(
                stream: ApiService.loginDetails
                    .where("userId", isEqualTo: sp.getString(SpUtil.userId))
                    .orderBy("orderBy", descending: true)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (snapshot.hasError) {
                    return Container();
                  } else {
                    if(snapshot.data.docs.isNotEmpty){
                      String displayString;
                      if (DateFormat("dd/MM/yyyy").format(DateTime.now()) ==
                          snapshot.data.docs.first["loginDate"]) {
                        displayString =
                        "Last login at Today, ${snapshot.data.docs.first["loginTime"]}";
                      } else {
                        displayString =
                        "Last login at, ${snapshot.data.docs.first["loginDate"]} ${snapshot.data.docs.first["loginTime"]}";
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(LastLoginScreen.routeName);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: const BorderSide(width: 1, color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              displayString,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }else{
                      return Container();
                    }

                  }
                }),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(89, 88, 87, .6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    screenshotController.capture().then((value) async {
                      if (value != null) {
                        if (sp.getBool(SpUtil.qrDataSaved) != null) {
                          if (!(sp.getBool(SpUtil.qrDataSaved)!)) {
                            ProgressUtils.showDialogProgress(context);
                            await ApiService()
                                .uploadImagesToDataBase(
                                    fileName:
                                        sp.getString(SpUtil.generatedNumber),
                                    image: value)
                                .then((value) async {
                              await ApiService.loginDetails
                                  .doc(sp.getString(SpUtil.uuid))
                                  .update({
                                "fileName":
                                    sp.getString(SpUtil.generatedNumber),
                                "imageUrl": value
                              });
                              sp.putBool(SpUtil.qrDataSaved, true);
                              ProgressUtils.toast(msg: "Saved");
                              Navigator.of(context).pop();
                            });
                          } else {
                            ProgressUtils.toast(
                                msg:
                                    "Already login details saved. Re-Login to again save");
                          }
                        } else {
                          ProgressUtils.showDialogProgress(context);
                          await ApiService()
                              .uploadImagesToDataBase(
                                  fileName:
                                      sp.getString(SpUtil.generatedNumber),
                                  image: value)
                              .then((value) async {
                            await ApiService.loginDetails
                                .doc(sp.getString(SpUtil.uuid))
                                .update({
                              "fileName": sp.getString(SpUtil.generatedNumber),
                              "imageUrl": value
                            });
                            sp.putBool(SpUtil.qrDataSaved, true);
                            Navigator.of(context).pop();
                          });
                        }
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "SAVE",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  )),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
