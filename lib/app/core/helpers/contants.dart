import 'package:watermel/app/data/apis/friends.dart';

FriendApi? friendsAPI;
const String baseUrl =
    //'https://139.162.157.213';
// https://d8af-2401-4900-1c02-2217-d4a5-3468-c824-d94c.ngrok-free.app/
    // 'https://492b-2402-a00-400-1f99-7f96-7648-b2e3-da59.ngrok-free.app/';
    'https://flashlick.com/';

const noAuth = [
  baseUrl + googleLoginAPI,
];

//API list
const socialLogin = "socialLogin";
const userProfile = "auth/profile/";
const signUP = "auth/register/";
const logOut = "auth/logout/";
const userLogin = "auth/login/";
const baseForImage = "https://flashlick.com";
const userFeed = "auth/user-seed/";
const getAllFeedUrl = "seed/posts/";
const searchuser = "auth/search-user/?";
const createFeed = "seed/posts/";
const deleteFeed = "seed/posts/";
const getPeopleYouKnowEndpoint = "auth/relevant-people/?page=";
const bookMarkFeed = "seed/bookmark/";
//! GET BOOKMARK LIST
const getBookmarkFeeds = "seed/bookmark/";
const reportSeed = "seed/report/";
const markAsSeen = "seed/mark-seed-as-seen/";
const follow = "auth/follow/";
const help = "help/";
const terms = "terms/";
const aboutUS = "about/";
const privacy = "privacy/";
const like = "seed/reaction/";
const readTheSeed = "seed/mark-seed-as-seen/";
//! GOOGLE LOGIN API
const googleLoginAPI = "auth/social-sign-in/";

const getNotificationCount = "notifications/?count=True";

//! SEED COMMENT API
const likeComment = "seed/comment-reaction/";
const addComent = "seed/comment/";
const getCommentEndPoint = "seed/comment/";
const notificationSwitch = "push-notification/";
const getSpecifiPostDetails = "seed/single-post/";
const setRefreshToken = "auth/refresh-access-token/";
//accept Reject follow request
const acceptFollowReq = "auth/follow/";
//Get Notification List
const notificationList = "notifications/?page=";
//! Delete Account
const deleteAccount = "auth/user/";
const repostTheFeed = "seed/re-post/";
