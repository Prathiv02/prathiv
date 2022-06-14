class LastLoginDataModel {
  late String location;
  late String loginTime;
  late String userIp;
  late String? imageUrl;

  LastLoginDataModel(
      {required this.location,
      required this.loginTime,
      required this.userIp,
      this.imageUrl});

  LastLoginDataModel.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    loginTime = json['loginTime'];
    userIp = json['userIp'];
    imageUrl = json['imageUrl'];
  }
}
