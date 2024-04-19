import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/helpers/contants.dart';

class FriendApi {
  final String authToken;

  FriendApi(this.authToken);

  Future<void> removeFriendOrRequest(int friendId) async {
    final url = '$baseUrl/auth/friend/$friendId/';
    await http.delete(Uri.parse(url),
        headers: {'Authorization': 'Bearer $authToken'});
  }

  Future<void> acceptFriendRequest(int friendId) async {
    final url = '$baseUrl/auth/friend/$friendId/';
    await http
        .put(Uri.parse(url), headers: {'Authorization': 'Bearer $authToken'});
  }

  Future<String> sendFriendRequest(int friendToId) async {
    const url = '$baseUrl/auth/friend/';
    final body = {'friend_to_id': friendToId.toString()};
    var response = await http.post(Uri.parse(url),
        headers: {'Authorization': 'Bearer $authToken'}, body: body);
    var data = jsonDecode(response.body);
    if (data['error'] == null) {
      return "Request sent";
    }
    return "Request already sent";
  }

  Future<List<dynamic>> getFollowers() async {
    const url = '$baseUrl/auth/followers/?is_approved=true';
    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $authToken'});
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getFollowing() async {
    const url = '$baseUrl/auth/following/?is_approved=false';
    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $authToken'});
    return jsonDecode(response.body)["results"];
  }
}
