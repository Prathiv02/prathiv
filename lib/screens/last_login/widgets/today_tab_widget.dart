import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prathivexample/database/api_service.dart';
import 'package:prathivexample/model/last_login_data_model.dart';
import 'package:prathivexample/screens/last_login/widgets/last_login_item_widget.dart';

class TodayTabWidget extends StatelessWidget {
  const TodayTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ApiService.loginDetails
          .where("loginDate",
              isEqualTo: DateFormat("dd/MM/yyyy").format(DateTime.now()))
          .orderBy("orderBy", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return Container();
        } else {
          var dbData = snapshot.data as QuerySnapshot;
          return dbData.docs.isNotEmpty
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (ctx, index) {
                    QuerySnapshot list = snapshot.data as QuerySnapshot;
                    LastLoginDataModel data = LastLoginDataModel.fromJson(
                        list.docs[index].data() as Map<String, dynamic>);
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
                  ),
                );
        }
      },
    );
  }
}
