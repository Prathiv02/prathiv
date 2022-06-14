import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../database/api_service.dart';
import '../../../database/sp_util.dart';
import '../../../main.dart';
import '../../../model/last_login_data_model.dart';
import 'last_login_item_widget.dart';

class OtherTabWidget extends StatelessWidget {
  const OtherTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ApiService.loginDetails
          .where("userId", isEqualTo: sp.getString(SpUtil.userId))
          .orderBy("orderBy", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return Container();
        } else {
          var dbData = snapshot.data as QuerySnapshot;
          String todayDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
          String yesterdayDate = DateFormat("dd/MM/yyyy")
              .format(DateTime.now().add(const Duration(days: -1)));
          List<QueryDocumentSnapshot> bdData = [];
          for (var element in dbData.docs) {
            if (todayDate != element["loginDate"] && yesterdayDate != element["loginDate"]) {
              bdData.add(element);
            }
          }
          return bdData.isNotEmpty
              ? ListView.builder(
                  itemCount: bdData.length,
                  itemBuilder: (ctx, index) {
                    LastLoginDataModel data = LastLoginDataModel.fromJson(
                        bdData[index].data() as Map<String, dynamic>);
                    return LastLoginItemWidget(
                        data: LastLoginDataModel(
                            location: data.location,
                            loginTime: data.loginTime,
                            userIp: data.userIp,
                            imageUrl: data.imageUrl));
                  })
              : const Center(
                  child: Text(
                  "No Login Details",
                  style: TextStyle(color: Colors.white),
                ));
        }
      },
    );
  }
}
