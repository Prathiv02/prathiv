import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProgressUtils {
  static Widget _buildProgress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          SizedBox(
            width: 10,
          ),
          CircularProgressIndicator(),
          SizedBox(
            width: 10,
          ),
          Text(
            "Please Wait...",
          )
        ],
      ),
    );
  }

  static void showDialogProgress(BuildContext context) {
    showPlatformDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
          material: (_, __) => MaterialAlertDialogData(
            contentPadding: EdgeInsets.zero,
          ),
          cupertino: (_, __) => CupertinoAlertDialogData(),
          content: _buildProgress(context),
        );
      },
    );
  }

  static toast({required String msg}) {
    Fluttertoast.showToast(
        msg: msg, backgroundColor: Colors.white, textColor: Colors.black);
  }

  static showBar({required BuildContext context, required String msg}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.white));
  }
}
