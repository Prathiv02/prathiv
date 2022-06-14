import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:prathivexample/database/api_service.dart';
import 'package:prathivexample/screens/plugin/plugin_screen.dart';
import 'package:uuid/uuid.dart';

import '../database/sp_util.dart';
import '../main.dart';
import '../utils/progress_utils.dart';

class LoginProvider with ChangeNotifier {
  late bool _isLocationServiceEnabled;
  late String uid;
  String? verificationId;
  bool otpSent = false;

  Future verifyUser(
      {required String number, required BuildContext context}) async {
    uid = number;
    sp.putString(SpUtil.userId, uid);
    ProgressUtils.showDialogProgress(context);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91$number",
        timeout: const Duration(seconds: 10),
        verificationCompleted: (AuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException authExcep) {
          ProgressUtils.toast(
              msg: authExcep.message ?? "verificationFailed Retry later");
          Navigator.of(context).pop();
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          this.verificationId = verificationId;
          ProgressUtils.toast(msg: "OTP has been Sent");
          otpSent = true;
          Navigator.of(context).pop();
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
    notifyListeners();
  }

  Future loginUser({required String otp, required BuildContext context}) async {
    try {
      ProgressUtils.showDialogProgress(context);
      FirebaseAuth auth = FirebaseAuth.instance;

      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: otp);
      UserCredential result = await auth.signInWithCredential(credential);
      User? user = result.user;
      if (user != null) {
        sp.putBool(SpUtil.loggedIn, true);
        otpSent = false;
        Navigator.of(context)
            .pushNamedAndRemoveUntil(PluginScreen.routeName, (route) => false);
      } else {
        Navigator.pop(context);
        ProgressUtils.toast(msg: "Invalid OTP!");
      }
    } catch (error) {
      Navigator.pop(context);
      if (error.toString().contains("invalid-verification-code")) {
        ProgressUtils.toast(msg: "invalid-verification-code");
      } else if (error.toString().contains("network-request-failed")) {
        ProgressUtils.toast(msg: "Please check your internet connection");
      } else {
        ProgressUtils.toast(msg: "Something went wrong try later");
      }
    }
  }

  Future getUserLocationAndIp({required BuildContext context}) async {
    LocationPermission permission;

    _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!_isLocationServiceEnabled) {
      if (!Platform.isIOS) {
        Location location = Location();
        _isLocationServiceEnabled = await location.requestService();
      } else {
        ProgressUtils.showBar(
            context: context, msg: "Turn on GPS for assessing your location");
      }
    }
    if (!_isLocationServiceEnabled) {
      ProgressUtils.showBar(
          context: context, msg: "Location permissions are denied");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {}
    }

    if (permission == LocationPermission.deniedForever) {
      ProgressUtils.showBar(
          context: context,
          msg:
              "Location permissions are permanently denied, we cannot request permissions.");
    }
    ProgressUtils.showDialogProgress(context);
    Position position = await Geolocator.getCurrentPosition();
    String? address = await reverseGeocodingForGettingAddress(
        longitude: position.longitude, latitude: position.latitude);
    String? ip = await getIPAddress();
    String uuid = const Uuid().v1();
    sp.putString(SpUtil.uuid, uuid);
    await ApiService.loginDetails.doc(uuid).set({
      "location": address ?? "",
      "userIp": ip ?? "",
      "userId": sp.getString(SpUtil.userId),
      "loginDate": DateFormat("dd/MM/yyyy").format(DateTime.now()).toString(),
      "loginTime": DateFormat("h:mm:a").format(DateTime.now()).toString(),
      "orderBy": DateTime.now(),
      "uuid": uuid
    });
    sp.putBool(SpUtil.gotLoginData, true);
    Navigator.of(context).pop();
  }

  Future reverseGeocodingForGettingAddress(
      {required double latitude, required double longitude}) async {
    final data = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyB0Pd6TkW7Ip2rIDZsXgPhyfLprulvDn7U"));
    return jsonDecode(data.body)["results"][0]["formatted_address"];
  }

  static Future<String?> getIPAddress() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org'));
      return response.statusCode == 200 ? response.body : null;
    } catch (e) {
      return null;
    }
  }
}
