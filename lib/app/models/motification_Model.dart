import 'dart:convert';

class NotificationList {
  final int? id;
  final bool? followRequestApproved;
  final dynamic notifSenderProfilePicture;
  final dynamic notifSenderDisplayName;
  final dynamic notifsenderusername;
  final String? title;
  final String? notifType;
  final dynamic description;
  final bool? hasBeenRead;

  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final int? user;
  final dynamic notificationBy;
  final int? followNetwork;
  final int? comment;
  final int? seed;
  NotificationList({
    this.id,
    this.followRequestApproved,
    this.notifSenderProfilePicture,
    this.notifType,
    this.notifSenderDisplayName,
    this.notifsenderusername,
    this.title,
    this.description,
    this.hasBeenRead,
    this.createdAt,
    this.modifiedAt,
    this.user,
    this.notificationBy,
    this.followNetwork,
    this.comment,
    this.seed,
  });

  factory NotificationList.fromRawJson(String str) =>
      NotificationList.fromJson(json.decode(str));

  factory NotificationList.fromJson(Map<String, dynamic> json) =>
      NotificationList(
        id: json["id"],
        followRequestApproved: json["follow_request_approved"],
        notifSenderProfilePicture: json["notif_sender_profile_picture"],
        notifType: json["notif_type"],
        notifSenderDisplayName: json["notif_sender_display_name"],
        notifsenderusername: json["notif_sender_username"],
        title: json["title"] ?? "",
        description: json["description"],
        hasBeenRead: json["has_been_read"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
        user: json["user"],
        notificationBy: json["notification_by"],
        followNetwork: json["follow_network"],
        comment: json["comment"],
        seed: json["seed"],
      );
}
