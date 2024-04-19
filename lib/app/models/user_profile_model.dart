import 'dart:convert';

class UserProfileData {
  int? id;
  final dynamic userId;
  int? followers;
  int? following;
  String? username;
  final String? email;
  int? followerNetworkID;
  int? followingNetworkID;
  dynamic bio;
  String? profilePicture;
  final dynamic coverPicture;
  String? displayName;
  dynamic noOfInfluencer;
  final bool? specificUserPrivacy;
  int? totalSeeds;
  final String? shareProfileUrl;
  dynamic followStatus;
  final bool? followRequestStatus;
  final bool? followReqBack;
  // final bool? followStatus;

  UserProfileData({
    this.id,
    this.userId,
    this.followers,
    this.following,
    this.username,
    this.email,
    this.bio,
    this.profilePicture,
    this.coverPicture,
    this.displayName,
    this.noOfInfluencer,
    this.specificUserPrivacy,
    this.totalSeeds,
    this.shareProfileUrl,
    this.followStatus,
    this.followRequestStatus,
    this.followReqBack,
    this.followerNetworkID,
    this.followingNetworkID,
    // this.followRequestStatus,
  });

  factory UserProfileData.fromRawJson(String str) =>
      UserProfileData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfileData.fromJson(Map<String, dynamic> json) =>
      UserProfileData(
        userId: json["id"],
        followers: json["followers"],
        following: json["following"],
        username: json["username"],
        email: json["email"],
        bio: json["bio"],
        followerNetworkID: json["follower_network_id"],
        followingNetworkID: json["following_network_id"],
        profilePicture: json["profile_picture"],
        coverPicture: json["cover_picture"],
        displayName: json["display_name"],
        noOfInfluencer: json["no_of_influencer"],
        specificUserPrivacy: json["specific_user_privacy"],
        totalSeeds: json["total_seeds"],
        shareProfileUrl: json["share_profile_url"],
        followStatus: json["follow_status"],
        followRequestStatus: json["follow_request_status"],
        followReqBack: json["follow_back_status"],
        // followStatus: json["follow_status"],
      );

  factory UserProfileData.fromFollowerJson(Map<String, dynamic> json) =>
      UserProfileData(
        id: json["id"],
        userId: json["follower"]["id"],
        username: json["follower"]["username"],
        email: json["follower"]["email"],
        profilePicture: json["follower"]["userprofile"]["profile_picture"],
        displayName: json["follower"]["userprofile"]["display_name"],
        specificUserPrivacy: json["follower"]["specific_user_privacy"],
        totalSeeds: json["follower"]["total_seeds"],
        shareProfileUrl: json["follower"]["share_profile_url"],
      );

  factory UserProfileData.fromFollowingJson(Map<String, dynamic> json) =>
      UserProfileData(
        id: json["id"],
        userId: json["following"]["id"],
        username: json["following"]["username"],
        email: json["following"]["email"],
        profilePicture: json["following"]["userprofile"]["profile_picture"],
        displayName: json["following"]["userprofile"]["display_name"],
        specificUserPrivacy: json["following"]["specific_user_privacy"],
        totalSeeds: json["following"]["total_seeds"],
        shareProfileUrl: json["following"]["share_profile_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": userId,
        "followers": followers,
        "following": following,
        "username": username,
        "email": email,
        "bio": bio,
        "profile_picture": profilePicture,
        "cover_picture": coverPicture,
        "display_name": displayName,
        "no_of_influencer": noOfInfluencer,
        "specific_user_privacy": specificUserPrivacy,
        "total_seeds": totalSeeds,
        "share_profile_url": shareProfileUrl,
        "follow_status": followStatus,
        "follow_request_status": followRequestStatus,
        "follow_back_status": followReqBack
        //  "follow_request_status": followRequestStatus
      };
}
