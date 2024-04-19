class UserLoginModel {
  String? token;
  String? refreshToken;
  String? userId;
  String? username;
  String? mobile;
  String? email;
  String? userProfile;
  String? socialType;
  dynamic notificationFlag;
  dynamic notificationStatus;
  dynamic display_name;
  String? mobile_code;

  UserLoginModel(
      {this.token,
      this.userId,
      this.username,
      this.mobile,
      this.email,
      this.userProfile,
      this.refreshToken,
      this.socialType,
      this.notificationStatus,
      this.notificationFlag,
      this.display_name,
      this.mobile_code});

  UserLoginModel.fromJson(Map<String, dynamic> responseBody) {
    token = responseBody["token"].toString();
    userId = responseBody["id"].toString();
    username = responseBody['username'] != null
        ? responseBody['username'].toString()
        : "";
    display_name = responseBody['display_name'] != null
        ? responseBody['display_name'].toString()
        : "";
    notificationStatus = responseBody['notification_status'] != null
        ? responseBody['notification_status']
        : false;
    mobile = responseBody['mobile_no'] != null
        ? responseBody['mobile_no'].toString()
        : "";
    email =
        responseBody['email'] != null ? responseBody['email'].toString() : "";
    userProfile = responseBody['profile_picture'] != null
        ? responseBody['profile_picture'].toString()
        : "";
    socialType = responseBody['social_type'] != null
        ? responseBody['social_type'].toString()
        : "";
    notificationFlag = responseBody['firebase_is_active'] != null
        ? responseBody['firebase_is_active'].toString()
        : false;
    mobile_code = responseBody['mobile_code'] != null
        ? responseBody['mobile_code'].toString()
        : "+1";
    refreshToken = responseBody['refresh_token'] != null
        ? responseBody['refresh_token'].toString()
        : "";
  }
}
