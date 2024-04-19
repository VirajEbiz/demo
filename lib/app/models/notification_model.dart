class NotificationModel {
  dynamic? id;
  String? userId;
  String? userImage;
  String? userName;
  String? commentText, time;
  String? venueId;
  String? venueName;
  String? venueAddress;
  String? venueType;
  String? totalcommentCount;
  String? totalLikeCount;
  String? venueImage;
  dynamic userLiked;
  String? venueDate;
  String? venueLocation;

  NotificationModel({
    this.id,
    this.userId,
    this.userImage,
    this.userName,
    this.commentText,
    this.time,
    this.venueId,
    this.venueName,
    this.venueAddress,
    this.venueType,
    this.totalcommentCount,
    this.totalLikeCount,
    this.venueImage,
    this.userLiked,
    this.venueDate,
    this.venueLocation,
  });

  NotificationModel.fromJson(Map<String, dynamic> responseBody) {
    id = responseBody["_id"].toString();
    userId =
        responseBody['userId'] != null ? responseBody['userId'].toString() : "";
    userImage = responseBody['userImage'] != null
        ? responseBody['userImage'].toString()
        : "";
    userName = responseBody['userName'] != null
        ? responseBody['userName'].toString()
        : "";
    commentText = responseBody['commentText'] != null
        ? responseBody['commentText'].toString()
        : "";
    time = responseBody['time'] != null ? responseBody['time'].toString() : "";
    venueId = responseBody['venueId'] != null
        ? responseBody['venueId'].toString()
        : "";
    venueAddress = responseBody['venueAddress'] != null
        ? responseBody['venueAddress'].toString()
        : "";
    venueName =
        responseBody['venueName'] != null && responseBody['venueName'] != ""
            ? responseBody['venueName'].toString()
            : "-";
    venueType = responseBody['venueType'] != null
        ? responseBody['venueType'].toString()
        : "";
    totalcommentCount = responseBody['totalCommentCount'] != null
        ? responseBody['totalCommentCount'].toString()
        : "00";
    venueImage = responseBody['venueImage'] != null
        ? responseBody['venueImage'].toString()
        : "";
    totalLikeCount = responseBody['totalLikeCount'] != null
        ? responseBody['totalLikeCount'].toString()
        : "0";
    userLiked = responseBody['userLiked'] != null
        ? responseBody['userLiked'].toString()
        : false;
    totalcommentCount = responseBody['totalCommentCount'] != null
        ? responseBody['totalCommentCount'].toString()
        : "00";
    venueDate =
        responseBody['venueDate'] != null && responseBody['venueDate'] != ""
            ? responseBody['venueDate'].toString()
            : "-";
    venueLocation = responseBody['venueLocation'] != null &&
            responseBody['venueLocation'] != ""
        ? responseBody['venueLocation'].toString()
        : "-";
  }
}
