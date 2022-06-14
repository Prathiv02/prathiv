import 'package:flutter/material.dart';

import '../../../model/last_login_data_model.dart';

class LastLoginItemWidget extends StatelessWidget {
  final LastLoginDataModel data;

  const LastLoginItemWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(89, 88, 87, .1),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
              child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  data.loginTime,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  "IP: ${data.userIp}",
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  data.location,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          )),
          if (data.imageUrl != null)
            Positioned(
                right: 0,
                top: -20,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    height: 70,
                    child: Image.network(
                      data.imageUrl!,
                      color: Colors.black,
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
